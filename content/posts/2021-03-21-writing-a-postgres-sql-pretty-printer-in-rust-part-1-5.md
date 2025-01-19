---
title: "Writing a Postgres SQL Pretty Printer in Rust: Part 1.5"
author: Dave Rolsky
type: post
date: 2021-03-21T13:19:05-05:00
url: /2021/03/21/writing-a-postgres-sql-pretty-printer-in-rust-part-1-5
discuss:
  - site: "/r/rust"
    uri: "https://www.reddit.com/r/rust/comments/ma416y/writing_a_postgres_sql_pretty_printer_in_rust/"
  - site: "/r/programming"
    uri: "https://www.reddit.com/r/programming/comments/ma420h/writing_a_postgres_sql_pretty_printer_in_rust/"
---

Last week I wrote the [first post in this series]({{< relref
"2021-03-14-writing-a-postgres-sql-pretty-printer-in-rust-part-1" >}}), where I introduced the
project and wrote about generating Rust code for the parsed Postgres AST.

I also wrote about the need for wrapper enums in the generated code, but I don't think I went into
enough detail, based on questions and discussions I had after I
[shared that post in /r/rust](https://www.reddit.com/r/rust/comments/m51oet/writing_a_postgres_sql_pretty_printer_in_rust/).

So this week I will go into more detail on exactly why I had to do this.

## Series Links

- Part 1: [Introduction to the project and generating Rust with Perl]({{< relref
  "2021-03-14-writing-a-postgres-sql-pretty-printer-in-rust-part-1" >}})
- Part 1.5: **More about enum wrappers and serde's externally tagged enum representation**
- Part 2: [How I'm testing the pretty printer and how I generate tests from the Postgres
  docs]({{< relref
  "2021-04-24-writing-a-postgres-sql-pretty-printer-in-rust-part-2" >}})

## A Tagged Enum Example

I've made [an example crate](https://github.com/autarch/tagged-enum-example) with all of the code I
walk through below at https://github.com/autarch/tagged-enum-example.

In order to make this simpler, I'll use some very simple JSON, as opposed to the rather complex JSON
we get back from the Pg parser. However, I cannot change the JSON to make parsing easier, just like
I cannot do that with the Pg parser's output[^1].

```json
{
  "Root": {
    "first": {
      "Foo": {
        "size": 42,
        "color": "blue"
      }
    },
    "second": {
      "Bar": {
        "mood": "indigo",
        "car": "Super"
      }
    },
    "actions": [
      {
        "Run": {
          "speed": 84
        }
      },
      {
        "Sleep": {
          "hours": 8
        }
      }
    ]
  }
}
```

I'll use [JSONPath](https://tools.ietf.org/html/draft-goessner-dispatch-jsonpath-00) to refer to
parts of the document. You can see that every object in the JSON is "tagged" with its type. Those
are the title case keys: `$.Root`, `$.Root.first.Foo`, `$.Root.second.Bar`, `$.Root.actions[0].Run`,
and `$.Root.actions[1].Sleep`.

Let's assume that the `$.Root.second` key is optional, so it could be entirely omitted in some
documents.

### The Naive Approach

Now let's make some Rust structs that correspond to this JSON. This corresponds to the
[naive directory](https://github.com/autarch/tagged-enum-example/tree/master/naive) in my example
repo.

```rust

#[derive(Debug, Deserialize)]
struct Root {
    first: Foo,
    second: Option<Bar>,
    actions: Vec<Action>,
}

#[derive(Debug, Deserialize)]
struct Foo {
    size: i8,
    color: String,
}

#[derive(Debug, Deserialize)]
struct Bar {
    mood: String,
    car: String,
}

#[derive(Debug, Deserialize)]
enum Action {
    Run { speed: i64 },
    Sleep { hours: i8 },
}
```

This is all pretty straightforward. We have a `Root` struct that can contain a `Foo`, an optional
`Bar`, and zero or more `Action` structs.

And here's our parsing code:

```rust
fn main() {
    let output: Root = serde_json::from_str(DOC).expect("parsed");
    println!("{:#?}", output);
}
```

So what happens when we run this?

We get this error:

```
... 'parsed: Error("missing field `first`", line: 29, column: 1)', ...
```

The important bit is ``"missing field `first`", line: 29, column: 1``. What's at line 29, column 1
of our JSON document? That's the end of the document, actually.

So basically we're seeing that the serde JSON parser looked through the entire top-level object for
a `first` key but could not find one. That makes sense, since the top-level object in the actual
document only contains a key named `Root`.

Fortunately, serde has a solution to this, in the form of its
["externally tagged enum representation"](https://serde.rs/enum-representations.html#externally-tagged)
handling. For this type of JSON, each object is annotated with an extra "tag" indicating its type,
just like we see with `$.Root` and `$.Root.first.Foo` and so on.

But the key word here is "enum". Serde does not offer a way to handle this style of JSON without
using enums. So I need to make a bunch of enums, one for each possible tag.

### The So Many Enums Approach

This corresponds to the
[with-enums directory](https://github.com/autarch/tagged-enum-example/tree/master/with-enums) in my
example repo.

And here are our structs and enums:

```rust

#[derive(Debug, Deserialize)]
enum RootWrapper {
    Root(Root),
}

#[derive(Debug, Deserialize)]
struct Root {
    first: FooWrapper,
    second: Option<BarWrapper>,
    actions: Vec<Action>,
}

#[derive(Debug, Deserialize)]
enum FooWrapper {
    Foo(Foo),
}

#[derive(Debug, Deserialize)]
struct Foo {
    size: i8,
    color: String,
}

#[derive(Debug, Deserialize)]
enum BarWrapper {
    Bar(Bar),
}

#[derive(Debug, Deserialize)]
struct Bar {
    mood: String,
    car: String,
}

#[derive(Debug, Deserialize)]
enum Action {
    Run { speed: i64 },
    Sleep { hours: i8 },
}
```

And our `main()` is:

```rust
fn main() {
    let output: RootWrapper = serde_json::from_str(DOC).expect("parsed");
    println!("{:#?}", output);
}
```

Note that the type of `output` is now `RootWrapper` instead of `Root`. This runs without an error,
giving us:

```
Root(
    Root {
        first: Foo(
            Foo {
                size: 42,
                color: "blue",
            },
        ),
        second: Some(
            Bar(
                Bar {
                    mood: "indigo",
                    car: "Super",
                },
            ),
        ),
        actions: [
            Run {
                speed: 84,
            },
            Sleep {
                hours: 8,
            },
        ],
    },
)
```

Yay, it works! But it has tons of pointless enums. Boo!

The enums generally clutter up the code with a lot of destructuring. For example, if I want to get
the struct corresponding to `$.Root.first.Foo`, I have to write this:

```rust
    let RootWrapper::Root(root) = output;
    let FooWrapper::Foo(foo) = root.first;
```

In my Pg formatting code, multiply that destructuring by a thousand.

## There must be some way out of here

When I
[shared this in /r/rust](https://www.reddit.com/r/rust/comments/m51oet/writing_a_postgres_sql_pretty_printer_in_rust/)
last week, [/u/nicoburns](https://www.reddit.com/user/nicoburns/) had some helpful suggestions for
working around this. We
[went back and forth a bit](https://www.reddit.com/r/rust/comments/m51oet/writing_a_postgres_sql_pretty_printer_in_rust/gr0f8wj)
and I was able to get something that worked a little bit. But it only worked for simple cases. I
couldn't get it to work for cases like `Option<Bar>` or `Vec<Action>`. And in the Pg parser AST, I
also end up with `Option<Vec<Something>>` too, as well as cases with tuple structs like
`Vec<(Foo, Bar)>` and probably some other weird things too.

What I would love is a solution that changes the code generated by the serde macros to just "skip
over" the tag instead of creating an enum for it when the enum only has one variant.

A solution that still requires the wrappers and even more generated code for them would be fine,
though I suspect it'd make the AST code's slow compilation even slower.

I started digging into serde a bit to try to understand how I might do this, but it's pretty
complex, and I'm still pretty new to Rust.

For now, I have enough other things to work on with this project. For example, the way I generate
formatted SQL is horrific and unscalable (lots of inline `some_str.push_str("WHERE ")` and
`format!`). I'm starting on a refactor to generate some sort of intermediate representation of the
AST that I can then turn into a string.

## Next up

Here's a list of what I want to cover in future posts.

- Diving into the Postgres grammar to understand the AST.
- [How I'm approaching tests for this project, and how I generate test cases from the Postgres
  documentation]({{< relref "2021-04-24-writing-a-postgres-sql-pretty-printer-in-rust-part-2" >}}).
- The benefits of Rust pattern-matching for working with ASTs.
- How terrible my initial solution to generating SQL in the pretty printer is, and how I fixed it
  (once I actually fix it).
- How the proc macro in the `bitflags_serde_int` crate works[^2].
- Who knows what else?

[Stay tuned](/index.xml) for more posts in the future.

[^1]:
    Ok, technically I _could_ do that, but that would involve parsing the JSON and rewriting it in
    order to ... make it easier to parse?

[^2]:
    Edit 2021-04-24: Nope, not gonna write about this. It turns out I was reimplementing the already
    existing `#[serde(transparent)]` feature.
