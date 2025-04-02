---
title: "My Azure Pipelines Tooling Is Dead"
author: Dave Rolsky
type: post
date: 2025-04-02T16:56:02+02:00
url: /2025/04/02/my-azure-pipelines-tooling-is-dead
---

Many years ago, in the glory days of 2019, when I was young and carefree, with the wind in my hair
and all the youthful joy of the world in my soul, I wrote
[created my `ci-perl-helpers` project for testing Perl modules in Azure Pipelines](/2019/11/18/my-new-ci-helpers-for-perl/).
Why Azure Pipelines? Well, at the time, GitHub Actions didn't support caching, and it was generally
immature.

How things have changed. GitHub Actions is the de facto default for FOSS project these days. It
supports caching, and is otherwise fairly mature. Meanwhile, Azure Pipelines appears to be mostly
neglected.

Recently, something changed in Azure Pipelines that broke my
[`ci-perl-helpers` project](https://github.com/houseabsolute/ci-perl-helpers). I'm not sure _what_
changed, but I don't have the interest or energy to investigate it. This project did a lot of cool
stuff, but it was a pile of confusing shell scripts and generated Dockerfiles and stuff. Also, from
what I can tell, no one but me ever used it.

I've started to move my Perl modules over to GitHub Actions using a much simpler workflow. This
workflow builds on top of
[`shogo82148/actions-setup-perl`](https://github.com/shogo82148/actions-setup-perl), which installs
a pre-compiled Perl. Along with GitHub caching for prereqs, this makes running CI in GitHub Actions
performant enough to not need all the complexity of my `ci-perl-helpers` project.

I might take
[what I've done for DateTime-Locale](https://github.com/houseabsolute/DateTime-Locale/blob/master/.github/workflows/ci.yml)
and turn it into a real action. But that's work, so I might just make it something _I_ can re-use
easily, without making it a real Action.

The downside to this is I'm no longer able to test with Perl dev releases or blead (git `HEAD`). The
Perl that [`shogo82148/actions-setup-perl`](https://github.com/shogo82148/actions-setup-perl)
installs comes from the
[`skaji/relocatable-perl` project](https://github.com/skaji/relocatable-perl), and that project
doesn't provide dev versions of Perl.

I'm also going to just cut down my testing breadth a fair bit. With my Azure Pipelines setup, I'd
test on every stable Perl from 5.8.9 or 5.10.1 to the latest Perl, plus dev and blead. With my new
setup, I plan to test one old version (5.10.1 for most modules), plus the latest two versions of
Perl. I'll also test with _only_ the latest Perl on macOS and Windows. I think this should be enough
to keep my modules stable on the Perl versions people care about.
