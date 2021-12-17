---
title: "Writing a Postgres SQL Pretty Printer in Rust: Part 2"
author: Dave Rolsky
type: post
date: 2021-04-24T13:00:33-05:00
url: /2021/04/24/writing-a-postgres-sql-pretty-printer-in-rust-part-2
discuss:
    - site: "/r/rust"
      uri: "https://www.reddit.com/r/rust/comments/mxsko0/writing_a_postgres_sql_pretty_printer_in_rust/"
    - site: "/r/programming"
      uri: "https://www.reddit.com/r/programming/comments/mxskm6/writing_a_postgres_sql_pretty_printer_in_rust/"
---

It's been a few weeks since my last post on this project. I was distracted by
[Go reflection]({{< relref "2021-03-27-down-the-golang-nil-rabbit-hole" >}})
and [security issues with Perl IP address modules]({{< relref
"2021-03-29-security-issues-in-perl-ip-address-distros" >}}). But now I can
get back to my Postgres SQL pretty printer project[^1].

One of the challenges for this project has been figuring out the best way to
test it. I tried a standard unit test approach before giving up and settling
on integration testing instead, so in this post I'll talk about what I tried
and what I ended up with.

## Series Links

* Part 1: [Introduction to the project and generating Rust with Perl]({{<
  relref "2021-03-14-writing-a-postgres-sql-pretty-printer-in-rust-part-1"
  >}})
* Part 1.5: [More about enum wrappers and Serde's externally tagged enum
  representation]({{< relref
  "2021-03-21-writing-a-postgres-sql-pretty-printer-in-rust-part-1-5" >}})
* Part 2: **How I'm testing the pretty printer and how I generate tests from
  the Postgres docs**

## Unit Tests

Whenever possible, I prefer to write unit tests for my code. Let's define
"unit test", since people use that term all the time, but with slightly
different definitions

When I say "unit tests" I'm referring to tests that test the functionality of
a single module[^2], focusing on its public API. If that module integrates
with other modules, unit tests may require mocking. Some will say it _always_
requires mocking, but I think that is often a waste of effort, so I avoid
mocking in many cases. And though I said "focusing on its public API",
sometimes I will test private functions directly, if they are complex enough
to warrant this and doing so is not too painful.

Unit tests are great when you can write them. They let you focus on one small
piece of a code base at a time to make sure that it does what you expect. Good
unit tests cover the standard use cases, corner cases (zero values, extreme
values, etc.), various permutations of argument combinations, and error
handling.

If you unit test all of your modules, you know that each module probably does
what you want it to. This doesn't tell you whether they all work together
properly, but it's a good start.

The bulk of the (non-generated) code for pg-pretty lives in one library crate
named
[`formatter`](https://github.com/houseabsolute/pg-pretty/tree/master/formatter),
and initially this was all in the [crate root's `lib.rs`
file](https://github.com/houseabsolute/pg-pretty/blob/master/formatter/src/lib.rs),
though I'm working on rewriting this in a branch named `new-formatter` (no
links because the branch will be deleted after I merge it to master).

The original formatter code[^3] has many functions, but the vast majority of them
work the same way. They take a struct[^4] or slice of structs defined in the
[parser crate's ast
module](https://github.com/houseabsolute/pg-pretty/blob/master/parser/src/ast.rs)
and return a string representing the formatted SQL for that piece of the AST[^5].

Here's a simple function from that code:

```rust
fn format_range_var(&self, r: &RangeVar) -> String {
    let mut names: Vec<String> = vec![];
    if let Some(c) = &r.catalogname {
        names.push(c.clone());
    }
    if let Some(s) = &r.schemaname {
        names.push(s.clone());
    }
    names.push(r.relname.clone());

    let mut e = names
        .iter()
        .map(Self::maybe_quote)
        .collect::<Vec<String>>()
        .join(".");

    if let Some(AliasWrapper::Alias(a)) = &r.alias {
        e.push_str(&Self::alias_name(&a.aliasname));
        // XXX - do something with colnames here?
    }

    e
}
```

A `RangeVar` is a struct representing a name in a `FROM` clause. This will
always have a `relname` (a table, view, or subselect), with optional database
and schema names, like `some_db.some_schema.some_table`. In addition, it may
have an alias.

This is a relatively simple example, as this type of struct doesn't contain
any complex structs itself. Other functions, like for formatting a select
statement, mostly consist of calls to other formatting functions:

```rust
fn format_select_stmt(&mut self, s: &SelectStmt) -> R {
    let t = match &s.target_list {
        Some(tl) => tl,
        None => return Err(Error::NoTargetListForSelect),
    };
    let mut select = self.format_select_clause(t)?;
    if let Some(f) = &s.from_clause {
        select.push_str(&self.format_from_clause(f)?);
    }
    if let Some(w) = &s.where_clause {
        select.push_str(&self.format_where_clause(w)?);
    }
    if let Some(g) = &s.group_clause {
        select.push_str(&self.format_group_by_clause(g)?);
    }
    if let Some(o) = &s.sort_clause {
        select.push_str(&self.format_order_by_clause(o)?);
    }

    Ok(select)
}
```

This is an early, incomplete version which doesn't handle `HAVING` clauses,
`LIMIT` clauses, window clauses, locking clauses, `UNION` queries, etc. The
point I'm trying to make is that these functions get complex quickly. While
breaking them down into lots of smaller functions helps, I've ended up with a
huge number of small functions.

So how do we test this with unit tests? To do that, we need a way to produce
structs from the `ast` module like `RangeVar` or `SelectStmt`. For reference,
here's `RangeVar`:

```rust
pub struct RangeVar {
    // the catalog (database) name, or NULL
    pub catalogname: Option<String>, // char*
    // the schema name, or NULL
    pub schemaname: Option<String>, // char*
    // the relation/sequence name
    pub relname: String, // char*
    // expand rel by inheritance? recursively act
    // on children?
    #[serde(default)]
    pub inh: bool, // bool
    // see RELPERSISTENCE_* in pg_class.h
    pub relpersistence: Option<char>, // char
    // table alias & optional column aliases
    pub alias: Option<AliasWrapper>, // Alias*
    // token location, or -1 if unknown
    pub location: Option<i64>, // int
}
```

The `RangeVar` struct only refers to one other ast enum or struct,
`AliasWrapper`, which in turn contains an `Alias`. But the `SelectStmt` is
_much_ more complex[^6]:

```rust
pub struct SelectStmt {
    // NULL, list of DISTINCT ON exprs, or
    // lcons(NIL,NIL) for all (SELECT DISTINCT)
    #[serde(rename = "distinctClause")]
    pub distinct_clause: Option<List>, // List*
    // target for SELECT INTO
    #[serde(rename = "intoClause")]
    pub into_clause: Option<IntoClauseWrapper>, // IntoClause*
    // the target list (of ResTarget)
    #[serde(rename = "targetList")]
    pub target_list: Option<List>, // List*
    // the FROM clause
    #[serde(rename = "fromClause")]
    pub from_clause: Option<List>, // List*
    // WHERE qualification
    #[serde(rename = "whereClause")]
    pub where_clause: Option<Box<Node>>, // Node*
    // GROUP BY clauses
    #[serde(rename = "groupClause")]
    pub group_clause: Option<List>, // List*
    // HAVING conditional-expression
    #[serde(rename = "havingClause")]
    pub having_clause: Option<Box<Node>>, // Node*
    // WINDOW window_name AS (...), ...
    #[serde(rename = "windowClause")]
    pub window_clause: Option<List>, // List*
    // untransformed list of expression lists
    #[serde(rename = "valuesLists")]
    pub values_lists: Option<Vec<List>>, // List*
    // sort clause (a list of SortBy's)
    #[serde(rename = "sortClause")]
    pub sort_clause: Option<Vec<SortByWrapper>>, // List*
    // # of result tuples to skip
    #[serde(rename = "limitOffset")]
    pub limit_offset: Option<Box<Node>>, // Node*
    // # of result tuples to return
    #[serde(rename = "limitCount")]
    pub limit_count: Option<Box<Node>>, // Node*
    // FOR UPDATE (list of LockingClause's)
    #[serde(rename = "lockingClause")]
    pub locking_clause: Option<Vec<LockingClauseWrapper>>, // List*
    // WITH clause
    #[serde(rename = "withClause")]
    pub with_clause: Option<WithClauseWrapper>, // WithClause*
    // type of set op
    pub op: Option<SetOperation>, // SetOperation
    // ALL specified?
    #[serde(default)]
    pub all: bool, // bool
    // left child
    pub larg: Option<Box<SelectStmtWrapper>>, // SelectStmt*
    // right child
    pub rarg: Option<Box<SelectStmtWrapper>>, // SelectStmt*
}
```

Besides having many more fields than `RangeVar`, most of those fields are
other types of ast nodes. In fact, many of these are a boxed `Node` or a
`List`, which is a `Vec<Node>`. One field, `values_lists`, is a `Vec<List>`! A
`Node` is an enum which can be _any_ AST node[^7].

So how exactly do we produce the various `SelectStmt` structs that we'd want
to feed into `format_select_stmt` for testing? The structs themselves have no
constructors. The parser only generates them based on the results of parsing,
which is done in C code for which there is no public API. That C code produces
a JSON representation of the AST, which we deserialize into structs.

So the only way left to do this is to construct them "by hand" with code like
this:

```rust
fn make_range_var(
    c: Option<&str>, s: Option<&str>, r: &str, a: Option<&str>,
) -> Node {
    let alias = match a {
        Some(a) => Some(AliasWrapper::Alias(Alias {
            aliasname: a.to_string(),
            colnames: None,
        })),
        None => None,
    };
    let catalogname = match c {
        Some(c) => Some(c.to_string()),
        None => None,
    };
    let schemaname = match s {
        Some(s) => Some(s.to_string()),
        None => None,
    };

    Node::RangeVar(RangeVar {
        catalogname,
        schemaname,
        relname: r.to_string(),
        inh: false,
        relpersistence: None,
        alias,
        location: None,
    })
}
```

This isn't entirely terrible, but as I noted before, the `RangeVar` struct is
one of the simpler structs in the AST. The equivalent for a `SelectStmt` would
be absolutely enormous. Even for a `RangeVar`, constantly having to pass
mostly `None` for the arguments gets old very fast. To make this simpler, I
made a macro:

```rust
macro_rules! range_var {
    ( $relname:literal $(,)? ) => {
        make_range_var(None, None, $relname, None)
    };
    ( $relname:literal AS $alias:literal ) => {
        make_range_var(None, None, $relname, Some($alias))
    };
    ( $catalogname:literal, $relname:literal $(,)? ) => {
        make_range_var(None, Some($catalogname), $relname, None)
    };
    ( $catalogname:literal, $relname:literal AS $alias:literal ) => {
        make_range_var(None, Some($catalogname), $relname, Some($alias))
    };
    ( $schemaname:literal, $catalogname:literal, $relname:literal $(,)? ) => {
        make_range_var(Some($schemaname), Some($catalogname), $relname, None)
    };
    ( $schemaname:literal, $catalogname:literal, $relname:literal AS $alias:literal ) => {
        make_range_var(
            Some($schemaname),
            Some($catalogname),
            $relname,
            Some($alias),
        )
    };
}
```

This covers every possible combination of optional arguments, so I could write
`range_var!("people")` or `range_var!("people" AS "persons")` or
`range_var!("some_schema", "people")` and so on.

This made the tests more concise, but the equivalent macro implementation for
a `SelectStmt` might be hundreds or even thousands of lines long.

## Giving Up on Unit Tests

I quickly realized that this approach simply wouldn't scale. The structs that
the formatter deals with are _so complex_, there are _so many_ of them, and
each struct has _so many_ possible variations of optional fields, types of
contained nodes, etc.

With my macro plus function approach, I'd have to write tens of thousands of
lines of code in support of these unit tests. And that code would itself be so
complex that it would really demand its own test suite!

But that's not even the biggest problem. The biggest problem is that because
these AST structs are produced by the Postgres parser C code, I really have no
idea what all the possibilities for a given struct are. Given that many
structs simply contain `Node` or `List` structs, the possibilities are
literally limitless.

So in summary:

* Writing struct generation code would be much more work than writing the
  formatter.
* The struct generation code would be so complex that it'd require its own
  test suite.
* There's no good way for me to know what structs to generate for tests
  without lots of real-world examples.

That last bullet point mentions "lots of real-world examples". That's what I
needed. So how to get them? I could scour my own projects for examples, though
in many cases I use an ORM, so it's not a trivial matter of just copying some
SQL. I could look for projects on GitHub that use Postgres. Maybe I could look
on Stack Overflow.

But finally, I had a good idea[^8]. The Postgres documentation is quite
extensive, and it includes _many_ SQL examples! If I could extract those
examples then those examples could form the basis of a test suite.

## Integration Tests to the Rescue

Taking a step back, I realized that what I really wanted to test was the
formatter as a whole. While unit tests are great, I could greatly simplify my
test code by simply comparing SQL statement input to SQL statement output. Any
time my output diverged from what I expected, that's a bug in the formatter
(or in my expectations). And if the formatter panics because it can't handle a
particular node[^9], that's a missing piece of the implementation.

This was yet another case where Perl came in handy. I wrote a quick script to
parse the entire documentation tree[^10] and find `programlisting` elements
which contained SQL. These are then put into files named after the doc file
that contained them, giving me files with content like this:

```
++++
1
----
CREATE TABLE base_table (id int, ts timestamptz)
----
???
----
```

The first section, `1`, is a test description, to be filled in later by
me. The second section is the input, and the third, `???`, is the expected
output. These generated files are useful seeds for test cases, though I have
to fill in the test name and expected output. An example from an actual test
looks like this:

```
++++
SELECT FOR UPDATE in subselect
----
SELECT * FROM (SELECT * FROM mytable FOR UPDATE) ss ORDER BY column1
----
SELECT *
FROM (
         SELECT *
         FROM mytable
         FOR UPDATE
     ) AS ss
ORDER BY column1
----
```

_(I will be improving the formatting, because I don't like the output the
original version gives!)_

These files are easy to edit, and adding new tests by hand is easy as well.

The [test
harness](https://github.com/houseabsolute/pg-pretty/blob/master/formatter/tests/formatter.rs)
simply reads each file, splits them up into individual cases, and runs the
input through the formatter and compares it to the output.

In order to make failures more understandable, I use
[`prettydiff`](https://lib.rs/crates/prettydiff)'s [`diff_lines`
function](https://docs.rs/prettydiff/0.4.0/prettydiff/text/fn.diff_lines.html)
to compare the expected output to what I actually got. This is quite helpful,
but in cases where they differ by whitespace, especially trailing newlines,
it's not as helpful as I'd like.

So I also added some optional debugging output (based on an env var) that
shows me each escaped character in the expected versus actual input. This lets
me easily see whitespace differences, and newlines are printed as `\n`, which
makes extra newlines obvious as well.

## In Summary

Sometimes integration tests are better than unit tests. In this case, focusing
on integration tests freed me from a testing morass I was stuck in, letting me
focus on the formatting code. The fact that I can generate a huge number of
integration tests gives me some confidence that this approach will work.

I definitely won't get 100% test coverage (which is basically impossible given
the recursive nature of the fact that an AST `Node`s can contain another
`Node`). But I think I can use this approach to product a decent first
release. Once people start using it, I will quickly get bug reports with more
test cases.

## Next up

Here's a list of what I want to cover in future posts.

* Diving into the Postgres grammar to understand the AST.
* The benefits of Rust pattern-matching for working with ASTs.
* How terrible my initial solution to generating SQL in the pretty printer is,
  and how I fixed it (once I actually fix it).
* Who knows what else?

[^1]: Try saying that three times fast.

[^2]: I'm referring to Rust modules here. Substitute package, library,
    etc. for your language of choice.

[^3]: The examples are from [commit
    `71b6e24`](https://github.com/houseabsolute/pg-pretty/tree/71b6e24a83d867900fb8c868b8501ff79e0f09f0).

[^4]: These are the structs that [I wrote about generating in Part 1]({{<
    relref "2021-03-14-writing-a-postgres-sql-pretty-printer-in-rust-part-1"
    >}}).

[^5]: Having each function return a string directly was the wrong approach. In
    my new branch I'm having these functions return something else that is
    then formatted later. But more on that in a future blog post once I've
    solidified this new approach.

[^6]: You don't need to read the entire struct definition. Just take note that
    this struct has a lot of fields and move on.

[^7]: In practice, these fields cannot really contain _any_ node. For example,
    the `where_clause` field, which is a `Box<Node>`, is not going to contain
    an `InsertStmt` or `CreateDomainStmt` or an `IntoClause`. But this is what
    the underlying Postgres data structures use, and I have no easy way of
    knowing _which_ subset of nodes a `Node`-typed field will contain. In some
    cases, I've actually figured this out through reading the Postgres parser
    code and my generator code overrides the field definition to use a
    simpler type. I plan to write about how I do this in a future blog post.

[^8]: This happens every once in a while. It's always very exciting.

[^9]: There are _so many_ node types that I didn't even try to list them all
    in the initial `format_node` implementation's `match`. Instead, I had [a
    default match (`_`) that just returned an
    error](https://github.com/houseabsolute/pg-pretty/blob/2272a2010ad214b98831535ce8732cc5c98fa2fd/formatter/src/lib.rs#L192)
    saying that formatting for the given node type wasn't implemented.

[^10]: The documentation files all have an `sgml` extension so I used an SGML
    parser, but just now I looked more closely and I think it's mostly XML,
    but without a DTD in most files. Regardless, I ended up using an SGML
    parser in my Perl code.
