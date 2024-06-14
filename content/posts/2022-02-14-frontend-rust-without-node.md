---
title: Frontend Rust Without Node
author: Dave Rolsky
type: post
date: 2022-02-14T11:40:55-06:00
url: /2022/02/14/frontend-rust-without-node
discuss:
  - site: "/r/rust"
    uri: "https://www.reddit.com/r/rust/comments/ssghyx/frontend_rust_without_node/"
  - site: "/r/programming"
    uri: "https://www.reddit.com/r/programming/comments/ssgi8n/frontend_rust_without_node/"
---

When I started [my frontend Rust project]({{< relref
"2022-02-08-my-rust-frontend-experiences.md" >}}), I used a [Seed](https://seed-rs.org/) project [starter template](https://github.com/seed-rs/seed-quickstart-webpack)
that included [Tailwind](https://tailwindcss.com/), [webpack](https://webpack.js.org/), some more JS
frontend dev stuff, and some [TypeScript](https://www.typescriptlang.org/) glue code that launches the
app.

This was a _lot_ of stuff. Stuff for me to install. Stuff for me to run. Stuff for me to (not)
understand. So. Much. Stuff!

To be clear, I don't want to dump on the author of this template. For one thing, it was created in
2019, and Rust frontend has advanced a _lot_ since then[^1]. And the template did what it says. It
_was_ a quick start. I just didn't understand how most of it worked. And it was a bit slow to run on
code changes. And making changes to it was frustrating because of all the stuff I didn't understand.

So when I went to try [Dioxus](https://dioxuslabs.com/), I wanted to see if I could avoid using any
Node technologies, especially a bundler like webpack, and doubly especially avoiding any JS/TS glue
code for the app.

Can I avoid that? Well, let's figure that out.

## What Does Webpack Do?

It's called a "bundler", which is pretty clear. It takes all your stuff and bundles it into a thing
you can run from a local dev server or distribute to production. That stuff includes:

- Your JS/TS[^2] application code.
- At least one HTML file, which you need to kick off the application in the browser.
- Your CSS, which may need to be generated from
  [SCSS or SASS](https://sass-lang.com/documentation/syntax).
- Images.
- Fonts.
- Anything else.

The output of Webpack is an `index.html` file that has been processed to load your compiled CSS[^3],
your compiled JS[^4], and maybe other stuff. It will also place the compiled CSS, images, fonts,
etc. in a single directory tree, usually in a top-level folder named `dist`. Then you can start a
dev server to serve this tree or ship it off to production (by making a tarball, a Docker image,
etc.).

When working on a frontend application in Rust, you still need to do some of these tasks. You need
to compile your application from Rust to WASM. You need an `index.html` to load that application.
You'll probably want that `index.html` to load a CSS file. You might have fonts or images you need
to distribute. And you _can_ do all of that with webpack.

But you don't have to!

## Just Use [Trunk](https://trunkrs.dev/)

Trunk is to Rust WASM web apps what Webpack is to JS web apps. It will compile your Rust code to
WASM, process SASS or SCSS files, minify things, copy images, etc.

Trunk integrates with [the wasm-bindgen tool](https://rustwasm.github.io/docs/wasm-bindgen/), which
is the CLI tool that turns Rust into WASM. This tool also generates some polyfill code to implement
features not yet implemented in all browsers.

The [`wasm-bindgen`](https://rustwasm.github.io/docs/wasm-bindgen/) crate also provides
[an API for communicating with JS code from Rust](https://docs.rs/wasm-bindgen/latest/wasm_bindgen/),
which allows you to integrate with existing JS libraries[^5]. There are a number of libraries that
build on top of this integration, like [`wasm-logger`](https://lib.rs/crates/wasm-logger), which
makes the output from [`log` crate](https://lib.rs/crates/log) go the browser's console.

Here's a very minimal `index.html` that will make Trunk compile your Rust app:

```html
<html>
  <head> </head>
  <body>
    <div id="main"></div>
  </body>
</html>
```

Wait, what? There's nothing in there! If you don't point it at any code in your HTML, then Trunk
will automatically compile the crate containing your `index.html` and turn it into a WASM
application that your index.html loads.

If you want some CSS you can add this to the `<head>`:

```html
<head>
  <link data-trunk rel="css" href="/css/my-compiled.css" />
</head>
```

If you use `rel="scss"` or `rel="sass"` then Trunk will compiled that file into a CSS file. Trunk
also hashes the file and puts that hash in the path to ensure that browsers reload the CSS whenever
the CSS source changes.

Other file types all use the same `<link rel="$type" href="/path/to/file.$type">` pattern. Trunk
supports icons (for your favicon), images, and it can copy files and directories wholesale for
images, fonts, etc. At the present, it doesn't support any sort of fancy processing of those files
natively, and it doesn't do hashing of them (yet).

However, you can use your own hooks to make it do other stuff by running arbitrary programs. And
this is how I've been able to avoid using webpack and I'm able to not run node at all for my web
app.

Ok, I lied, I do run node.

## Tailwindcss

I'm using the standalone `tailwindcss` executable, which effectively bundles `node` plus some JS
code into a single executable. You can download this from
[the tailwindcss GitHub project's releases page](https://github.com/tailwindlabs/tailwindcss/releases).

I have an "input CSS file" for tailwind that looks like this:

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

I also have a `tailwind.config.js` file that looks like this:

```js
module.exports = {
  content: ["index.html", "**/*.rs"],
  theme: {
    extend: {},
  },
  plugins: [require("@tailwindcss/forms")],
};
```

Then I have this bit of configuration in my `Trunk.toml` file:

```toml
[[hooks]]
stage = "build"
# I'm not sure why we can't just invoke tailwindcss directly, but that doesn't
# seem to work for some reason.
command = "sh"
command_arguments = [
    "-c",
    "tailwindcss -i css/tailwind.css -o css/tailwind_compiled.css"
]
```

Why can't I just run `tailwindcss` directly. I don't have a damn clue.

What exactly does `tailwindcss` do? To answer that, it's important to understand the basic design of
Tailwind. Unlike most CSS frameworks, with Tailwind you don't build your own SASS/SCSS/CSS file
using the framework as a base. You don't define new classes based on Tailwind classes.

Instead, Tailwind provides hundreds of small utility classes like `mr-8` (right margin size 8),
`flex` (use a flexbox layout for this element), and `text-lg` (make this text larger). You use those
classes directly in your code which generates HTML. Here's an example using JSX:

```jsx
export default function App() {
  return <h1 className="text-3xl font-bold underline">Hello world!</h1>;
}
```

This example uses three Tailwind classes, `text-3xl`, `font-bold`, and `underline`. Your first
reaction may be shock and horror. Mine was! But when I read more about the reasoning behind it I
realized that this actually works very nicely with modern frontend web app practices.

Nowadays, you don't write your HTML in one set of files and then make it dynamic with separate JS
code. Having lots of HTML was the original reason to use CSS classes. It meant that you could have
many different HTML pages with the same styles easily. Anywhere you embedded a search box you'd slap
a `search` class on the `<div>`.

In modern apps, your JS (or in my case, Rust) code generates the HTML directly. So your HTML
generation can be factored into functions or methods. And that means that you never need to repeat
the same sets of Tailwind classes across your application. If you need to reuse some particular
piece of layout, you can turn that into a reusable component. Here's one from my music player:

```rust
#[inline_props]
pub(crate) fn UserFacingError<'a>(
    cx: Scope, error: &'a crate::client::Status,
) -> Element {
    cx.render(rsx! {
        PageTitle {
            "Error"
        },
        div {
            class: "flex flex-row flex-wrap justify-center",
            "{error.message}",
        }
    })
}
```

If I need that set of classes, `"flex flex-row flex-wrap justify-center"`, in other components then
I can either make a new component for that `<div>` with those classes, _or_ I can just have a
function that returns those classes:

```rust
fn center_flex_classes() -> &str {
    "flex flex-row flex-wrap justify-center"
}
```

I'm using a real programming language to generate HTML, so I can take advantage of that fact to
avoid repeating my CSS classes all over the place[^6].

Finally, to tie it all together, I load the CSS in my `index.html:`

```html
<head>
  <link data-trunk rel="css" href="/css/tailwind_compiled.css" />
</head>
```

## What Does `tailwindcss` Do?

Remember that I'm running `tailwindcss` via Trunk as part of my build process? Why? If tailwind is
just a bunch of already-defined classes what is that command doing?

Well, calling it a "bunch" of classes may be understating things. To see how many, I generated a
file containing _all_ of the available-by-default CSS classes, with various media-size modifiers and
pseudo-classes for `hover` and so on. It came out to around 7MB. That's a big CSS file. Too big.

So what `tailwindcss` does is figure out which classes you're using by looking at your code. Then it
generates a CSS file with just the ones that you need. For my app I currently end up with a file
that's just 19k. That's much better than 7MB!

## Tailwind Typos

Have I mentioned that Tailwind offers a _lot_ of CSS classes? Take a look at just
[the padding classes](https://tailwindcss.com/docs/padding). There are a lot, and the names aren't
all that memorable.

If you typo a name then `tailwindcss` simply ignores it and it's missing from the generated CSS. As
I worked on my app I did this a lot. And it was always confusing. Was my layout wrong because of my
HTML? Was it the CSS classes I chose? Did the CSS generation process not regen the file, so the
class wasn't in the generated CSS? Or did I just typo a class name, so something had "px-13" as a
class, which doesn't exist.

It turns out I made a lot of typos. I kept wasting time trying to debug why my newly modified CSS
wasn't applying any styles, only to realize I'd made a typo.

Wouldn't it be nice if I could get the Rust compiler to check my CSS class names? Yes, that would be
nice.

In fact, the Seed quickstart template I'd been using provides exactly that through a
[PostCSS](https://postcss.org/)[^7] plugin that generates Rust code from your Tailwind config.

Wouldn't it be nice to have something like that for Dioxus? And maybe it could be generic enough for
any framework? And maybe it could be written in Rust?

Yes, that would be fantastic! And I'll talk about that in my next blog post, covering
[my new `tailwindcss-to-rust` tool](https://lib.rs/crates/tailwindcss-to-rust). I'll also cover the
Dioxus helper crate I wrote that makes it super easy[^8] to use
[SVG icons from HeroIcons](https://heroicons.com/) in your Dioxus project.

{{< aside >}}

P.S. If you _don't_ want a framework like Tailwind and you'd prefer to use CSS styles directly in
your Rust frontend, but you want compile-time safety, check out the
[stylist crate](https://lib.rs/crates/stylist). Thanks to @cryptoquick on the Dioxus Discord for
making me aware of this crate.

{{< /aside >}}

[^1]: The first commit was in March, 2019, so it's been about three years.

[^2]:
    TS = [TypeScript](https://www.typescriptlang.org/). Your app could also be in another language
    like [Elm](https://elm-lang.org/) or [PureScript](https://www.purescript.org/).

[^3]:
    Compiled from SASS or generated by `tailwindcss` or, in the case of plain CSS files, just
    concatenated together and maybe minified.

[^4]:
    Compiled from ES2015 or TS or [JSX](https://reactjs.org/docs/introducing-jsx.html) or Elm
    (probably using [Babel](https://babeljs.io/)) and processed to handle imports, then concatenated
    into one file and maybe minified.

[^5]:
    Fortunately, I haven't had to do that yet, because these sorts of cross-language integrations
    are often painful in my experience.

[^6]:
    Of course, "can" is the operative word here. Am I doing this consistently? No, because I'm doing
    a lot of experimentation so I'm okay with some quick cut and paste for now. But if I was
    building something that I expected many other people to hack on and maintain, I would (I hope)
    exercise more discipline.

[^7]: Oh yay, another tool to run and another config file in my project I don't understand.

[^8]: Barely an inconvenience!
