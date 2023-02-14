---
title: "All My Perl Modules Are in Maintenance Mode"
author: Dave Rolsky
type: post
date: 2023-02-11T12:06:14-06:00
url: /2023/02/11/all-my-perl-modules-are-in-maintenance-mode
---

This is probably obvious to anyone paying attention to my CPAN releases over
the past few years, but in case it's not, I wanted to state this
clearly. **All of [my Perl modules](https://metacpan.org/author/DROLSKY) are
in maintenance mode.**

Why? I no longer do any professional work with Perl, and I haven't done any
since 2017 or so. All of my most enjoyable personal projects are in
[Rust](https://www.rust-lang.org/) these days. Also, I'm a bit burned out on
the Perl community. I think as it's shrunk some of the most unpleasant aspects
of it have been amplified for me, and my time on the Perl and Raku Foundation
board exposed me to even more of this, further burning me out. Please note
that **I'm not talking about TPRF's board or volunteers here!**

So here's what "maintenance mode" means to me ...

**I will not _personally_ work on significant new features.** The definition
of "significant" here is nebulous, but basically, if it takes more then a few
hours of effort, I'm probably not going to work on it.

I _may_ review PRs for significant features, but honestly, I probably won't
have the motivation for this. If you want to propose a significant new feature
that requires careful review, then the best way to get this to be merged would
be to _also_ find some reviewers to look at it. If someone submits a bigger PR
and a few other people review it that I trust[^1], I'm a lot more likely to
merge it.

**I will not _personally_ make releases that break backward compatibility for
most of my modules.** I qualify this with "most" because there are some things
that aren't widely used that I'm okay with breaking, for example, my [personal
`Dist::Zilla`
bundle](https://metacpan.org/dist/Dist-Zilla-PluginBundle-DROLSKY) and other
things where I'm the main (or only) user.

**I will _probably_ not hand off ownership of widely used modules.** Some of
my code is _very_ widely used, including things like
[`DateTime`](https://metacpan.org/dist/DateTime) and
[`Log-Dispatch`](https://metacpan.org/dist/Log-Dispatch). I'm very wary of
giving others control of these since breakage in one of them can break a lot
of CPAN or a lot of existing applications. **I _do_ welcome help with
maintenance in the form of PRs and PR reviews!**

This includes modules like [`Specio`](https://metacpan.org/dist/Specio), where
it's in wide use entirely because it's used in `DateTime`.

Given all this, if for example, you have a suggestion for a `DateTime` 2.0
feature, I think the best option is to fork `DateTime` (into a namespace not
starting with `DateTime`) and go ham on it.

**I will _try_ to keep my Perl modules working with newer Perl versions.** So
far this has generally not been too difficult. If that changes, I will
reconsider my stance on handing over ownership.

**I will _try_ to fix bugs in code and land mines in APIs. I will do this as
long as they can be fixed in a backward-compatible way, without major surgery
on the code, in a reasonable amount of my time.** Backwards compatibility
trumps correctness here, especially if the buggy behavior is documented. This
goes double for "bugs" of the form "I don't like this documented"
behavior. That's not a bug, that's a design decision you disagree with. See
above about forking.

One safe way to fix land mines is to add new methods/functions/parameters,
like I've done with
[`Time::Local`](https://metacpan.org/dist/Time-Local). **PRs to do this sort
of thing are welcome and encouraged**, with the caveat about significant
features from above.

How long will I continue to do this? I don't know. I'm amazed that people are
still using code I wrote over 20 years ago! Will they still be using it 20
years from _now_? Maybe. Will there be new versions of Perl to deal with then?
Will I still want to touch any of this code? I have no clue.

[^1]:
    I can't list all the people I trust. But I'd say that a good reviewer is
    someone with a long history of using Perl who understands [The River of
    CPAN](http://neilb.org/2015/04/20/river-of-cpan.html) metaphor. If you
    want to know if someone would be a good reviewer, you can [email me to
    ask](mailto:autarch@urth.org) or find me on the TPRF Slack.
