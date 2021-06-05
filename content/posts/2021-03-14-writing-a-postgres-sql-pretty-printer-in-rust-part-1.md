---
title: "Writing a Postgres SQL Pretty Printer in Rust: Part 1"
author: Dave Rolsky
type: post
date: 2021-03-14T12:48:04-05:00
url: /2021/03/14/writing-a-postgres-sql-pretty-printer-in-rust-part-1
discuss:
    - site: "/r/rust"
      uri: "https://www.reddit.com/r/rust/comments/m51oet/writing_a_postgres_sql_pretty_printer_in_rust/"
    - site: "/r/programming"
      uri: "https://www.reddit.com/r/programming/comments/m51odc/writing_a_postgres_sql_pretty_printer_in_rust/"
---

This is the first of a planned series of blog posts about [my pg-pretty
project](https://github.com/houseabsolute/pg-pretty). I'll cover some things
I've learned about Rust and Postgres SQL, as well as some things I still don't
know.

## Series Links

* Part 1: **Introduction to the project and generating Rust with Perl**
* Part 1.5: [More about enum wrappers and Serde's externally tagged enum
  representation]({{< relref
  "2021-03-21-writing-a-postgres-sql-pretty-printer-in-rust-part-1-5" >}})
* Part 2: [How I'm testing the pretty printer and how I generate tests from
  the Postgres docs]({{< relref
  "2021-04-24-writing-a-postgres-sql-pretty-printer-in-rust-part-2" >}})

## Why?

I really, *really*, **really**, ***really*** cannot stand unformatted code, or
a mishmash of code styles throughout a codebase. But at the same time,
rejecting PRs from other developers at $WORK just because of code formatting
is not okay. Making them manually fiddle with formatting is not a good use of
their time (or mine).

This is why we have linters, tidiers, and [meta code quality tools]({{< relref
"2020-05-08-comparing-code-quality-meta-tools.md" >}}) like [my
precious](https://github.com/houseabsolute/precious).

Combine these with a commit hook and CI checks for code cleanliness, and I
never have to reject a PR for formatting. Instead, it gets auto-"rejected" by
`git commit` or CI, and I'm off the hook.

And besides the value of not annoying me, there is also value to enforcing
code formatting rules throughout a large codebase. Consistency eliminates a
potential distraction, because every
[Go](https://pkg.go.dev/golang.org/x/tools/cmd/goimports),
[Perl](https://metacpan.org/release/Perl-Tidy), or
[Python](https://github.com/psf/black) file in the codebase will look like
every other Go, Perl, or Python file.

SQL is code, so it sure would be nice to do the same thing there, but I
can't. There are a few SQL pretty printing tools that I've found, but none of
them handle Postgres-specific idioms.

So of course I should write one!

And I should write one in Rust! Of course?[^1]

## Where to Start?

Writing a Postgres SQL parser from scratch would be quite
painful[^2]. Fortunately, a lot of the hard lower level work has already been
done.

At the very lowest level we have
[libpg_query](https://github.com/lfittl/libpg_query), created by [Lukas
Fittl](https://github.com/lfittl). This is a project to rip the parser out of
the Postgres source tree and turn it into a C library. It's a shame that the
Postgres source is not already organized this way. But I imagine that the
parser started off as an integral part of the Postgres codebase, and by the
time anyone thought of extracting it, it was more work than anyone wanted to
take on.

The next step is to create a Rust wrapper around this C library. Luckily that
was already done too. I'm using
[libpg_query-sys](https://lib.rs/crates/libpg_query-sys), which is a bare
bones wrapper around the C library. It exposes the same types and functions as
the C library, but in Rust.

## From C to Rust

These underlying tools work by parsing a string containing Postgres SQL and
returning a string containing JSON. That JSON represents the [AST (Abstract
Syntax Tree)](https://en.wikipedia.org/wiki/Abstract_syntax_tree) of the
parsed SQL.

But to actually _do_ anything with that AST, you want native Rust structs, not
a giant JSON blob.

And that's where my work started.

The libpg_query source has a handy directory containing JSON files describing
various parts of the AST. For example, the
[`nodestypes.json`](https://github.com/lfittl/libpg_query/blob/10-latest/srcdata/nodetypes.json)
file defines all of the possible nodes. Many parts of the AST reference the
`Node` type, which is basically "any valid bit of SQL".

But the most important file is
[`struct_defs.json`](https://github.com/lfittl/libpg_query/blob/10-latest/srcdata/struct_defs.json). This
file defines all the data structures we might care about, providing the name,
fields, and field types for each struct.

Rust is a statically typed language, so we can't just parse this stuff at
runtime and generate structs in memory. Instead, we need codegen. And since
these struct definitions reference C types, we need to translate this all into
Rust!

## Generating Rust

Enter my totally not-a-hacked-up-mess
[`json-to-parser.pl`](https://github.com/houseabsolute/pg-pretty/blob/master/tools/json-to-parser.pl)
script.

For each C struct that we care about we generate a corresponding Rust
struct[^3]. This mostly means translating from C types to Rust types. To make
things extra fun, I try to make the types more specific wherever I can. There
are a number of places where the C struct just uses `Node*`, but in reality
only a limited subset of nodes are valid.

I've figured this out a couple ways. Sometimes, the comment for the field
(which is in the `struct_defs.json` file) actually tells me. For example, many
comments include the text "list of Value strings", which means it's a list of
strings. For whatever reason, the Postgres C code just uses `List*` (an array
of `Node*)` here instead of `String*`[^4].

As an aside, I turn all the comments in the `struct_defs.json` file into Rust
documentation comments in the generated code, which has been quite
helpful. This lets me read the generated AST code and get a pretty good
understanding of what each struct and field contains.

But in Rust, we really want to know what our possible types are. That's
because I'm using Rust's enum-based pattern matching. The `Node` enum has over
100 variants. That's a lot of matching!

I also need to generate enum wrappers around many structs. Any time a struct
references another struct, I need the wrapper indirection. So for example,
here's a little bit of the `DeleteStmt` struct:

```rust
#[skip_serializing_none]
#[derive(Debug, Deserialize, PartialEq)]
pub struct DeleteStmt {
    // relation to delete from
    pub relation: RangeVarWrapper, // RangeVar*
    // ... more fields ...
}
```

The `relation` field is going to contain a `RangeVarWrapper`, which is a
one-variant enum that looks like this:

```rust
#[derive(Debug, Deserialize, PartialEq)]
pub enum RangeVarWrapper {
    RangeVar(RangeVar),
}
```

### Why the Wrapper?

The wrappers are annoying, and I'd like to get rid of them, but I can't figure
out how!

Let's take a very simple `DELETE` statement and parse it:

```sql
DELETE FROM films
```

The parser gives us this (with some outer bits removed for simplicity):

```json
{
  "DeleteStmt": {
    "relation": {
      "RangeVar": {
        "inh": true,
        "location": 12,
        "relname": "films",
        "relpersistence": "p"
      }
    }
  }
}
```

There's a lot to look at there, so let's zoom in on one part:

```json
{
  "DeleteStmt": {
    "relation": {
      "RangeVar": {...}
    }
  }
}
```

We need to deserialize this into a Rust struct. For deserialization in Rust
I'm using [`serde`](https://serde.rs/), which is a powerful Rust framework for
deserialization that supports many data formats, including JSON.

The particular structure of the JSON above corresponds to what the serde docs
call ["the externally tagged enum
representation"](https://serde.rs/enum-representations.html). In this format,
the "tags" such as `DeleteStmt` and `RangeVar` are used to indicate which enum
variant to deserialize to. A variant of what? Well, that's the problem.

As far as I can tell, the only way to make this work is to make an enum
wrapper for every single struct which might be contained in any other
struct. So for the `RangeVar` struct I need this wrapper:

```rust
#[derive(Debug, Deserialize, PartialEq)]
pub enum RangeVarWrapper {
    RangeVar(RangeVar),
}
```

And then when I'm working with the delete statement, I need to pattern match
`RangeVar` struct out of the `DeleteStmt`:

```rust
fn format_delete_stmt(&mut self, d: &DeleteStmt) -> R {
    let RangeVarWrapper::RangeVar(r) = &d.relation;
    // .. do something with the RangeVar in r
}
```

I really don't like this pattern, but from my reading so far I haven't seen a
simple way to eliminate it. I *think* the only way to do this would be to
provide custom serde deserialization logic for every struct which contains
another struct.

This is absolutely possible, but I've avoided this so far in order to focus on
other aspects of the project. But I want to come back to this in the future,
because these wrappers require a lot of extra pattern matching in the
formatter code.

### So ...

So that's why I need a Perl script to generate Rust code, though I can think
of at least a couple other approaches.

One would be to rewrite the Perl in Rust. That would work, but the Perl script
is already fast. The naive Rust approach would probably be slower, since I
would have to re-compile the Rust generator code every time I changed it,
though I could ameliorate that by moving some data to config files. But Perl
is a great language for reading JSON and generating code.

Another, almost certainly terrible option, would be to write one or more
macros that could read the JSON source data and generate the Rust code
directly. I'm fairly sure this is possible with [procedural
macros](https://doc.rust-lang.org/reference/procedural-macros.html). A
procedural macro looks like a function call or an attribute when you use
it. The implementation is just regular Rust code that takes either its
"function" arguments as input, or the thing that they are an attribute of (a
type, struct field, etc.). Either way, the macro implementation returns a new
AST of Rust code that is effectively inlined in place of the macro.

Procedural macros are incredibly powerful, and I ~~[wrote one to change how
bitflags are
serialized](https://github.com/houseabsolute/pg-pretty/tree/master/bitflags_serde_int)
so that serde expects these flags to be integers during deserialization,
rather than expecting a JSON object like `{ "bits": 42 }`~~ later realized
that `serde` already did what I needed, so I didn't need to write that
wrapper. The [bitflags crate](https://lib.rs/crates/bitflags) itself is a proc
macro, ~~so it's macros all the way down~~.

But a procedural macro that parses arbitrary JSON files to generate Rust code
seems a bit gross[^5]. And right now I find myself constantly referring to the
generated SQL AST structs. Having those available as regular Rust code that I
can examine in my editor is very helpful.

## Can You Try it Out?

Err, sort of. If you want to give it a whirl you can [clone the
repo](https://github.com/houseabsolute/pg-pretty), then edit the contents of
[`cli/src/main.rs`](https://github.com/houseabsolute/pg-pretty/blob/master/cli/src/main.rs),
which has some SQL to be formatted in it. But I haven't actually built a
proper CLI for it yet. I've just been focused on the core formatting
implementation, which I exercise through its test suite.

## Coming Soon

This post is already quite long, but there are many other things I've learned
while working on this project that I plan to write about, including:

* Diving into the Postgres grammar to understand the AST.
* [How I'm approaching tests for this project, and how I generate test cases
  from the Postgres documentation]({{< relref
  "2021-04-24-writing-a-postgres-sql-pretty-printer-in-rust-part-2" >}}).
* The benefits of Rust pattern-matching for working with ASTs.
* How terrible my solution to generating SQL in the pretty printer is, and how
  I wonder if there's a better way to do this.
* How the proc macro in the `bitflags_serde_int` crate works[^6].
* Who knows what else?

[^1]: Rust turned out to be a great fit for this project. More on that in a
    future post.

[^2]: That's an understatement. It would be a mammoth project of its own.

[^3]: I figured out what to care about by a combination of trial and error and
    experimentation. The `struct_defs.json` file organizes structs based on
    what files they're defined in. I was able to determine that (so far) I
    only care about types from a small subset of these files.

[^4]: Probably because if you're writing the parser and the thing that
    consumes it at the same time, you can write code that knows that it's only
    a String. Also, C doesn't have Rust's exhaustive pattern matching, so
    you're not forced to deal with all possible Node types.

[^5]: More than a bit. Really, really gross.

[^6]: Edit 2021-04-24: Nope, not gonna write about this. It turns out I was
    reimplementing the already existing `#[serde(transparent)]` feature.
