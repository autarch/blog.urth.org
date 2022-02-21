---
title: Checking Tailwind Class Names at Compile Time with Rust
author: Dave Rolsky
type: post
date: 2022-02-21T10:07:18-06:00
url: /2022/02/21/checking-tailwind-class-names-at-compile-time-with-rust
discuss:
  - site: "/r/rust"
    uri: "https://www.reddit.com/r/rust/comments/sxx7gm/checking_tailwind_class_names_at_compile_time/"
  - site: "/r/programming"
    uri: "https://www.reddit.com/r/programming/comments/sxx7om/checking_tailwind_class_names_at_compile_time/"
---

At the end of [my last post, "Frontend Rust Without Node"]({{< relref
"2022-02-14-frontend-rust-without-node.md" >}}), I talked about my big issue
with using [Tailwind CSS](https://tailwindcss.com/). **It has a huge number of
classes, I can't remember their names, so I often typed them incorrect. This
made it difficult to figure out why my styling wasn't doing what I thought.**

{{< aside >}}
**TLDR**: Don't care about how any of this works, but just want to use the
tooling I wrote? [Jump to the end and ignore all my
blather](#putting-it-all-together).
{{< /aside >}}

Here's a recap of _why_ this is the case ...

Tailwind consists of class names and "modifiers". A class name is something
like `text-lg` or `grid`. Any class name can also have a number of modifiers
attached to it, separated by colons, so you can write something like this:

```html
<div class="hidden lg:visible hover:background-indigo-200">
  Content that will only be visible above a certain screen size.
</div>
```

You can also combine modifiers to create classes like
`lg:hover:background-indigo-200`. So while there are "only" a few hundred CSS
class names, the number of names you can use is `"base" names × modifiers!`
(that's a factorial sign on `modifiers!`). It's not _really_ a factorial since
you can't combine every modifier with every other modfifier
(`sm:md:lg:visible` makes no sense), but it's a lot more than a simple
multiplication.

As such, it's not practical to simply generate a CSS file with all
possible classes. Well, I lied. In fact, it's entirely practical because it's
trivially doable. Just add this to your `tailwind.config.js` ...

```js
module.exports = {
  content: {
    ...
    safelist: {
      pattern: /.*/,
      variants: [ "sm", "md", "lg", "xl", ... ],
    }
    ...
  }
};
```

... and then run the `tailwindcss` program to generate the CSS file[^1]. When
I tried this, without even including all variants, I ended up with a 7MB CSS
file, and I'd only be using a tiny fraction of what it contained.

So it's not a good idea, and it's not how the Tailwind CSS authors intend
Tailwind to be used. Instead, the `tailwindcss` program will scan your code
with some broad regexes to find strings that _could be_ Tailwind CSS class
names. Then it generates a CSS file containing just those strings which match
actual Tailwind names.

But this scanning process, because it matches so broadly, errs on the side of
false positives, and the `tailwindcss` program will not emit any warnings when
it finds a string that _could_ be a match, but which isn't. If it did that,
you'd end up with hundreds or thousands of warnings quite quickly, as it could
match nearly every variable and function name in your codebase, depending on
your naming conventions.

So in my first attempts to use Tailwind with Dioxus, my workflow ended up like
this:

- Add some class names in my
  [React](https://reactjs.org/)/[Dioxus](https://dioxuslabs.com/)/[Seed](https://seed-rs.org/)/[Yew](https://yew.rs/)
  code.
- Re-run `tailwindcss` against my code base to regenerate my "compiled" CSS
  file. [^2]
- Look at my app, which since I'm using [Trunk](https://trunkrs.dev/) will
  have hot-reloaded in my browser.
- Scream into the void when my CSS changes did not do what I intended,
  usually doing absolutely nothing. Then try to debug what happened by asking:
  - Did my CSS actually get regenerated or is my Trunk config not doing what I
    think it should do?
  - Does the regenerated CSS contain the new class names?
    - If yes ...
      - Did the browser properly load the new CSS file[^3]?
      - Does the CSS do what I think it does when attached to the element I
        think I attached it?
    - If no ...
      - Did the `tailwindcss` work as I expected it to or did I screw up its
        config so it didn't see the class names I just added?
      - **Or did I typo a class name for the thousandth time today?**

I spent a _lot_ of time asking these questions. And most of the time, I had
typoed a Tailwind class name but nothing in my toolchain was telling me I had
done so.

This was annoying.

It was doubly annoying because I'm using Rust. If Rust does one thing well,
that thing is telling me at compile time all the many things I did wrong.

## Enlisting the Rust Compiler to Check my CSS

Fortunately, I knew I could make the Rust compiler check this for me. When I
experimented with Seed before Dioxus, [the quickstart template I
used](https://github.com/seed-rs/seed-quickstart-webpack) included a plugin
for [PostCSS](https://postcss.org/) written by [Martin
Kavik](https://github.com/MartinKavik),
[postcss-typed-css-classes](https://www.npmjs.com/package/postcss-typed-css-classes),
that hooked into PostCSS and generated Rust code for all of its classes[^4].

But I didn't want to use that plugin for a couple reasons:

1. I had so far managed to avoid needing to run `node` for my project, so I
   didn't want to use PostCSS, which requires `node`.
2. The code generated by that PostCSS puts _all_ of the classes, tens of
   thousands of them, into a single struct in an 8MB file. The reason it's so
   large is because it includes a huge number of `class × modifiers`, and it
   doesn't even come class to including all possible modifier/class
   combinations.

   This _killed_ my editor[^5] when it came to auto-completion. Even loading
   the generated file in my editor is slow, probably because syntax
   highlighting. And jumping around the file or searching in it is also quite
   slow.

Obviously, #2 is fixable, but to fix #1 I needed a new tool, ideally written
in Rust, since that's what everything else I'm using is in.

## So I Wrote That New Tool

It's called
[`tailwindcss-to-rust`](https://lib.rs/crates/tailwindcss-to-rust). It
generates Rust code with _all_ of the available Tailwind CSS class names and
modifiers as static strings. It _doesn't_ generate strings for modifier/class
combinations, which means that the full file is only 624kb. That's still
pretty big, but an order of magnitude smaller than the one generated by the
PostCSS plugin. My editor takes a slight pause when it loads, but it's only a
second or two. And jumping around the file and searching it are quick enough
to feel instantaneous.

And to further speed up code completion, I split up the classes into a set of
structs, where each struct represents a "group" of classes based on function
(layout, typography, animation, etc.). These groups are taken from [the
Tailwind documentation](https://tailwindcss.com/docs/) headings.

Unfortunately, there's nothing in the Tailwind code base to make this
easier. There's no list of all the available class names, and there's no
reference to the documentation groups in the code base at all. So all the
information I needed, the group and class names, only exists in the
documentation or in a generated CSS file. And to make it even worse, the
documentation itself is entirely generated by code.

Fortunately, as an old school Perl hacker, I know how to whip up some horrible
hacks, sanity be damned! I wrote [a Perl
script](https://github.com/houseabsolute/tailwindcss-to-rust/blob/master/dev/bin/get-categories.pl)[^6]
that crawls the Tailwind documentation site and generates a Rust data
structure mapping individual class names to groups.

If you're running in terror, don't worry, **you don't need to use Perl to use
the `tailwindcss-to-rust` tool**. I wrote the Perl to help me write the Rust
to generate the Rust. And you just need to run the Rust that generates the
Rust, not the Perl that generates (some of) the Rust to generate the Rust. I
hope that clears things up.

The _actual_ generator, `tailwindcss-to-rust` (written in Rust) takes as its
input your `tailwind.config.js` file and an input CSS file for the
`tailwindcss` program. We'll call that input file `tailwind.css` for this
explanation. This input file is usually just a few lines, see [step 3 of the
Tailwind installation docs](https://tailwindcss.com/docs/installation) for
details. Then the generator does the following:

- Creates a temp directory.
- Copies your `tailwind.config.js` and input CSS file to the temp dir.
- Adds `safelist: [ { pattern: /.*/ } ]` to the `tailwind.config.js` in the
  temp dir.
- If the directory containing the given `tailwind.config.js` file contains a
  `node_modules` directory, that directory is symlinked from the temp
  directory. This is so it can access any tailwind plugins in that
  directory. I'm honestly not sure if this achieves anything, but I haven't
  experimented with any plugins that don't ship as part of the `tailwindcss`
  binary.
- Runs `tailwindcss` in the temp directory, using the modified config
  file. Because it added that `safelist` item to the config, the generated
  file will include _every_ possible CSS class. The exact classes vary based
  on what Tailwind plugins you are using.
- "Parses" the generated CSS file to find all the class names it contains.[^7]
- Generates Rust code with structs for all of those classes. If there are
  class names the generator doesn't recognize then they are put in a struct
  named "Unknown".

  In the future I may add an option to provide a group mapping for class
  names. If this tool sees broader adoption I'm sure people will want this,
  because one of the most powerful features of Tailwind is that you can quite
  easily create your own custom classes and modifiers.

The generated Rust code looks like this[^8]:

```rust
#[derive(Clone, Copy)]
pub(crate) struct Modifiers {
    pub(crate) active: &'static str,
    pub(crate) after: &'static str,
    ...
    pub(crate) lg: &'static str,
    pub(crate) ltr: &'static str,
    ...
    pub(crate) visited: &'static str,
    pub(crate) xl: &'static str,
}

pub(crate) const M: Modifiers = Modifiers {
    active: "active",
    after: "after",
    ...
    lg: "lg",
    ltr: "ltr",
    ...
    visited: "visited",
    xl: "xl",
};


#[derive(Clone, Copy)]
pub(crate) struct Accessibility {
    pub(crate) not_sr_only: &'static str,
    pub(crate) sr_only: &'static str,
}

pub(crate) const ACCESSIBILITY: Accessibility = Accessibility {
    not_sr_only: "not-sr-only",
    sr_only: "sr-only",
};

...

#[derive(Clone, Copy)]
pub(crate) struct Sizing {
    ...
}

...

pub(crate) const C: C = C {
    acc: ACCESSIBILITY,
    ...
    siz: SIZING,
    ...
};
```

Then you can use the generated code like this:

```rust
use gen::{C, M};
let class = [[M.lg, C.siz.w_6].join(":").as_str(), C.typ.text_lg].join(" ");
```

{{< aside >}}
(Except that's incredibly disgusting, so I made some macros to make this more
ergonomic. But more on that in a second.)
{{< /aside >}}

If you remember, back at the beginning of this post, I mentioned that the
`tailwindcss` program scans your code to figure out which class names you are
actually using, and then generates a CSS file with only those classes. But in
order to turn class names like "w-3/6", "h-0.5", or "text-lg" into valid Rust
identifiers, I had to transform them a bit. **This means that `tailwindcss`
will no longer recognize what classes you're using!**

Fortunately, Tailwind allows you to provide a custom "extractor" to find class
names, on a per-file extension basis. So you need to modify your
`tailwind.config.js` file:

```js
module.exports = {
  content: {
    files: ["index.html", "**/*.rs"],
    // You do need to copy this big blog of code in, unfortunately.
    extract: {
      rs: (content) => {
        const rs_to_tw = (rs) => {
          if (rs.startsWith("two_")) {
            rs = rs.replace("two_", "2");
          }
          return rs
            .replaceAll("_of_", "/")
            .replaceAll("_p_", ".")
            .replaceAll("_", "-");
        };

        let classes = [];
        let class_re = /C\.[^ ]+\.([^\. ]+)\b/g;
        let mod_re = /(?:M\.([^\. ]+)\s*,\s*)+C\.[^ ]+\.([^\. ]+)\b/g;
        let matches = [...content.matchAll(mod_re)];
        if (matches.length > 0) {
          classes.push(
            ...matches.map((m) => {
              let pieces = m.slice(1, m.length);
              return pieces.map((p) => rs_to_tw(p)).join(":");
            })
          );
        }
        classes.push(
          ...[...content.matchAll(class_re)].map((m) => {
            return rs_to_tw(m[1]);
          })
        );
        return classes;
      },
    },
  },
  ...
};
```

What the custom extractor does is find places in the Rust code that use
modifiers or class names, then it transform the names from Rust identifiers
back to the Tailwind CSS names.

And with that in place you now have compile-time checked Tailwind CSS class
names, and a workflow that uses the `tailwindcss` tool without requiring
`node`, `npm`, or `yarn`.

You might be tempted to add the `tailwindcss-to-rust` invocation to your
`Trunk.toml` file (or other bundler tool). But in many cases this won't be
necessary. For most projects, you will run the generator very rarely, possibly
running it once only. The only things that require a re-run are:

1. You add/remove plugins from your `tailwind.config.js`.
2. You make changes to your `tailwind.config.js` that change the names of
   custom CSS classes you have configured.

So unless you have a config that generates custom names, you will almost never
need to regenerate your CSS file. If you _do_ have custom config, then it may
make sense to have Trunk run `tailwindcss-to-rust`.

## The Ergonomic Macros

The example I gave of using the generated structs earlier was this:

```rust
use gen::{C, M};
let class = [[M.lg, C.siz.w_6].join(":").as_str(), C.typ.text_lg].join(" ");
```

I said this was gross, and there's a couple reasons I think so. First, I hate
having to manually join modifiers with a colon, and then the overall class
list with the space. Second, because the first join with the modifier produces
a `String`, you have to convert it to a `&str` to join it with the static
`&str` in `C.typ.text_lg`. You could also write `C.typ.text_lg.to_string()`
and drop the earlier `.as_str()`. But yuck either way.

You'll be using these modifiers and classes a _lot_, so having to constantly
repeat these `join` calls is horrible. To make using this generated code _not_
horrible, I wrote [a crate with helper macros called
`tailwindcss-to-rust-macros`](https://lib.rs/crates/tailwindcss-to-rust-macros). Much
of this crate's content is a slightly tweaked version of code copied from [the
Seed framework](https://seed-rs.org/) code base, adjusted to make it more
generic.

Using the macros looks like this:

```rust
let class = C![M![M.lg, C.siz.w_6], C.typ.text_lg];
```

Yay, no `join` calls! The "arguments" to these macros can be any of these
types:

- `&str`
- `String`
- `&String`
- `Option<T>` and `&Option<T>` where `T` is any of the above.
- `Vec<T>`, `&Vec<T>`, and `&[T]` where `T` is any of the above.

There's also a `DC![...]` macro for use with Dioxus inside its `rsx!` macro.

The big downside of using macros is that you won't get any auto-completion
help from your IDE inside the macros, at least for now[^9]. This is a bit
ironic, since one of my main motivations for this tool was to make something
that worked better with auto-completion. But there are some tricks. You can
write this:

```rust
let class = [[M...., C.siz....], C.typ...
```

Where the `...` is where your IDE will kick in and provide
auto-completion. Then you can transform that into the equivalent macros. I bet
you could even write an editor plugin to do this for you, but I haven't done
this yet.

If you hate macros, you could just write some helper functions:

```rust
fn m(names: &[&str]) -> String {
    names.join(":")
}

fn c(classes: &[&str]) -> String {
    classes.join(" ")
}

let class = c(&[&m(&[M.lg, C.siz.w_6]), C.typ.text_lg]);
```

This isn't entirely terrible, but that sure is a lot of references to read.
And they don't handle all the `Option` and `Vec`/slice combinations that the
macros handle.

## A Future Feature?

One person who looked at this tool commented that they didn't like the name
transformations I used and would prefer to just use the original Tailwind
names in code. I was thinking about how this might work and I _think_ you
could use these names with a procedural macro. So you could write this ...

```rust
let class = C!["hidden", "lg:visible", "w-6", "text-lg"];
```

... and it would produce code something like this:

```rust
let _ = C.lay.hidden;
let _ = M.lg;
let _ = C.lay.visible;
let _ = C.siz.w_6;
let _ = C.typ.text_lg;
let class = ["hidden", "lg:visible", "w-6", "text-lg"];
```

But there's a couple wrinkles. First, it's not clear how to go from a class
name to it's _group_ at compile time. How does the macro know that "hidden"
belongs to `C.lay`? This might require producing a single struct with all the
classes so the generated code could just reference `C.hidden`. Or maybe it
could generate a bunch of structs split up by the first letter of the class
name if one big struct causes editor issues.

Second, I suspect the compilation errors from typos will be kind of horrible,
since they'll end up referring to things like `C.lay.hiddden` that simply
don't exist in the code you wrote.

But if someone really wants this, please [make an issue in the
repo](https://github.com/houseabsolute/tailwindcss-to-rust/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc)
and we can discuss it.

## Putting It All Together

You'll probably want a module in your code that wraps up the generated code
and macros together into a convenient set of exports. [The macros
documentation](https://docs.rs/tailwindcss-to-rust-macros/latest/tailwindcss_to_rust_macros/)
shows you how to do that.

There's a lot of moving parts here, so here's the summary:

1. Follow [the instructions for installing and running the
   `tailwindcss-to-rust` tool](https://lib.rs/crates/tailwindcss-to-rust).
2. Create the module as described in [the docs for the
   macros](https://docs.rs/tailwindcss-to-rust-macros/latest/tailwindcss_to_rust_macros/).
3. Import the module and use it:

   ```rust
   use css::*;

   fn some_func() {
       let class = C![
           C.spc.p_2,
           C.typ.text_white,
           M![M.hover, C.typ.text_blue],
       ];
       ...
   }
   ```

And that's how you can have compile-time checking for your Tailwind class
names. Of course, in doing all of this I've probably learned more about the
Tailwind class names than I ever knew before, so I'll never typo a class name
again. Hah!

[^1]:
    See my ["Frontend Rust Without Node" post]({{< relref
    "2022-02-14-frontend-rust-without-node.md" >}}) for a lot more details on
    what the `tailwindcss` tool is and how it's used.

[^2]:
    Which you can automate with [Trunk](https://trunkrs.dev/). See my
    ["Frontend Rust Without Node" post]({{< relref
    "2022-02-14-frontend-rust-without-node.md" >}}) for example code.

[^3]:
    [Trunk](https://trunkrs.dev/) should make sure this happens by appending
    a content hash to the CSS file to ensure your browser doesn't use an old
    cached version.

[^4]:
    The template also uses PostCSS to generate the "compiled" Tailwind CSS
    file, which is a way to use Tailwind without needed to run `tailwindcss`.

[^5]:
    I'm using [Emacs](https://www.gnu.org/software/emacs/) (a great OS with
    excellent editing built in) along with the fabulous [LSP
    mode](https://emacs-lsp.github.io/lsp-mode/) to give me the full IDE
    experience. As an aside, I only started using LSP mode a few years ago,
    and it's been a huge game-changer when writing code in languages with a
    good LSP server, mostly Go and Rust in my case.

[^6]:
    I _could_ have written this in Rust, but for me this sort of thing is
    much, much quicker to whip up in Perl, especially using some great
    libraries off CPAN, notably
    [`LWP::Simple`](https://metacpan.org/pod/LWP::Simple) and
    [`Mojo::DOM`](https://metacpan.org/pod/Mojo::DOM).

[^7]:
    I put "parses" in quotes because all it does is use a regex to match
    names like ".foo". I tried using some CSS parsing crates but they were all
    enormously complex, and just getting a list of all the classes in a file
    was ridiculously hard. But then I remembered I'm an old-school Perl hacker
    and that regexes are always the best worst solution to any problem.

[^8]:
    The default is `pub(crate)` but you can make it `pub` with the
    `--visibility` flag.

[^9]:
    See [the "IDEs and Macros"
    post](https://rust-analyzer.github.io/blog/2021/11/21/ides-and-macros.html)
    on the rust-analyzer blog for why.
