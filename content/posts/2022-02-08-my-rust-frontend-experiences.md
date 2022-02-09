---
title: My Rust Frontend Experiences
author: Dave Rolsky
type: post
date: 2022-02-08T17:11:40-06:00
url: /2022/02/08/my-rust-frontend-experiences
---

As [I mentioned in a previous post]({{< relref
"2021-12-22-working-with-musicbrainz-name-data.md" >}}), I've been working on
a music player for a while as a fun side project. Though since I've been
jobless this has actually been my primary project, and I've probably spent
more time coding than I did at work[^1].

{{%
    figure
    src="/image/crumb.png"
    alt="The artists list in my webapp"
    caption="This almost looks like a real app but don't be fooled. Half the buttons don't work yet."

%}}

My goal was always to build a backend that could support multiple frontends,
especially a web app and mobile apps. I decided to work on the web app
frontend first. I wanted to build _a_ frontend quickly so I could work on the
backend and importer and have a way to exercise them.

Rust can compile down to [WASM](https://webassembly.org/), which means you can
run Rust in the browser, and there are quite a few Rust frameworks for
frontend development. Check out this [LogRocket blog post for a good
list](https://blog.logrocket.com/current-state-rust-web-frameworks/) that's
current as of early 2022[^2]. There are a number of options including some
that provide an experience very similar to [React](https://reactjs.org/) or
[Elm](https://elm-lang.org/).

My initial plan was to use Rust, but after a little investigation I ended up
trying Flutter instead. It promises to support both mobile apps and the web,
and there was no Rust frontend framework that did that. But then some quick
experiments with Flutter's web output convinced me not to use it. Flutter's
web renderer works by creating a `<canvas>` tag and drawing your entire app
inside it. This means that _nothing_ in the app works the way you'd
expect. You can't even select text without explicitly re-implementing it. So
it basically breaks everything the browser does. No. Just no.

So it was back to Rust. After looking at a few options, I decided to start
with [Seed](https://seed-rs.org/). It was web only, unfortunately, but it
seemed like a good design. I got something working fairly quickly and it was a
good experience. The message-passing based API meant I had to create a _lot_
of `Msg` enums, basically one per component with any interactive piece. And
then I was constantly calling `some_view(foo).map_msg(Msg::SomeViewMsg)`
because of the message types. If this makes no sense, just trust me that it's
a bit annoying, but not a dealbreaker.

But then a month ago, Jonathan Kelley announced
[Dioxus](https://dioxuslabs.com/), which supports the web as well as
mobile[^3] and desktop apps. This was exactly what I'd wanted!

So I decided to give it a try. If it worked well for the web app, I'd be way
ahead on desktop and mobile versions too. I've been working with it for a few
months and I quite like it. It's very React-like, though since my last use of
React was in 2017, the whole "hooks" thing is new to me. The [Dioxus Discord
community](https://discord.gg/XgGxMSkvUM) has been great, and the author has
been _incredibly_ responsive to questions and bug reports. Often he fixes
things within minutes or hours of my report, and he's also been very helpful
when I'm confused about how to do something (which happens a lot).

I even wrote a first draft of a (web-only for now) router, which was a fun
learning exercise for me. The Dioxus author merged it pretty quickly[^4], so
it's there for anyone else to try out too.

I've also released a few more Rust crates related to frontend work, but I'll
go into those in a future blog post. I'll also talk a bit about how I set this
up the development environment, and how I've so far managed to avoid needing
any Node tools like [webpack](https://webpack.js.org/).

I'll be looking for a new position soon[^5], but until then I'll keep working
on this app. It's been a great learning experience, and a lot of fun too.

[^1]: Hey, I was in management. I wasn't slacking.
[^2]: Which means it will be out of date in a few months? Weeks?
[^3]: Just iOS for now though.
[^4]: So maybe he doesn't have the best judgement all the time.
[^5]: My current plan is to start my search in March, but if you have a great
    Rust job for me please [let me know](mailto:autarch@urth.org).
