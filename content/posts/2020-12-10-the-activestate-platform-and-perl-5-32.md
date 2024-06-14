---
title: The ActiveState Platform and Perl 5.32
author: Dave Rolsky
type: post
date: 2020-12-10T15:16:00-06:00
url: /2020/12/10/the-activestate-platform-and-perl-5-32
---

**Note:** Technically, this post qualifies as paid promotion, because I work for
[ActiveState](https://www.activestate.com/). But I volunteered to write about our new Platform and
put it on my personal blog because I think what we're doing is really cool and might be of interest
to the Perl community at large.

## TLDR

- We have an entirely new system that supports Windows and Linux (macOS coming soon), providing you
  binary builds of the Perl core, Perl distros, and supporting C/C++ libraries[^0].
- When you use our [State Tool](https://www.activestate.com/products/platform/state-tool/)[^1],
  **you can create any number of entirely self-contained virtual environments, one per project**.
  This makes switching between projects trivial and these virtual environments are easily shared
  across a team or organization.
- **No more ActiveState Community License**[^2]**!** The only licenses that apply are the original
  licenses for each open source package we build for you.
- **You don't need a Platform account to try this out.** But you can play with our system and sign
  up at any time and keep all the work you've done so far.
- It's usually **quite fast**. If we've already built a particular distro/language core for the
  given platform, we use a cached version, so many builds take a few seconds. Entirely new builds
  are slower, but still faster than doing it by hand locally in many cases, because we distribute
  work throughout a build farm.
- **The core features are all free.** Most features are free for public projects. We also have paid
  features including private projects, build engineering support, support for older platforms,
  indemnification, and more.
- The Platform has **lots of other cool features** like revisioned projects, advanced dependency
  resolution, and more.

## What Is It?

So what is "The ActiveState Platform"? We describe it as
["multi-project, cross-platform package management for Perl 5.32"](https://www.activestate.com/perl-532/).
But here's my description for Perl people. It's like [perlbrew](https://perlbrew.pl/) plus
[Carton](https://metacpan.org/release/Carton) on steroids, except not because it gives you binaries.

It's cross-platform and easy for organizations to use across teams.

Besides Perl, we offer Python and Tcl (with our old licensing, for now), with other languages coming
in the future.

But that's still a mouthful, so instead, let's dig into each of the features in detail.

Note that some of what I'm describing only applies to Perl 5.32 right now. We're in the process of
moving from using a legacy build tool[^3] to new tooling that's much better. This new tooling lets
us do faster parallel builds, as well as providing a better base for future features.

### Package Management (with Versioning)

Because we give you binaries, the Platform is really more like
[Apt](<https://en.wikipedia.org/wiki/APT_(software)>),
[RPM](https://en.wikipedia.org/wiki/RPM_Package_Manager), [Chocolatey](https://chocolatey.org/), or
[Homebrew](https://brew.sh/), not CPAN tooling like
[cpanminus](https://metacpan.org/release/App-cpanminus) or
[Carton](https://metacpan.org/release/Carton).

You don't need to figure out how to build that pain in the rear distro. Instead, we do all of the
compilation and building on our side and give you the bits. This includes not just the Perl core and
Perl module code (XS or pure Perl), but _also_ C/C++ library dependencies, which are statically
linked as needed[^4].

All of this is managed from the command line using our
[State Tool](https://www.activestate.com/products/platform/state-tool/). The State Tool takes care
of downloading your build and installing it locally. In addition, you can use it to add, remove, or
change the Perl modules associated with your project, though we have a very usable web UI too.

One of the coolest features of our package management system is that it's all versioned. Every
change to your requirements creates a new "commit" in our system. This works a lot like any VCS. You
can see your commit history, revert to an earlier state, etc. And we have work in progress to
support branches, to be released in the future.

The set of packages associated with each commit is frozen in time, down to the binary level. I have
more details about that later in this post.

### Cross Platform (OS)

We support builds on Windows and Linux, with macOS in the works. The
[State Tool](https://www.activestate.com/products/platform/state-tool/) is entirely cross-platform
as well.

One thing that we're still working on is making it possible to have a multi-OS project with per-OS
package additions/removals. Right now, if you have a project that builds on both Windows and Linux,
you can only add Perl distros that work on both platforms. So for example if you tried to add
[Win32](https://metacpan.org/release/Win32), you'd get an error saying this can't be built on Linux.

I think the solution to this will be via the in-progress branch support I mentioned previously. This
would allow you to have a shared set of base packages, with additional Windows and Linux branches.
Or you could have Linux as your main branch and Windows as a branch off that with any necessary
distro additions and removals.

### Multiple Projects with Shared Virtual Environments

Because all of your project's configuration is stored in our system, it's trivial for an entire team
to share that configuration. All a new team member needs to do to get started is to `state activate`
the project, and they'll get the same virtual environment as everyone else, with the same Perl core,
Perl modules, and any C/C++ libraries those modules need.

This makes onboarding new team members or contributors trivial. And it makes it trivial to have many
projects with different sets of requirements. And these environments can be packaged up into a file
tree that you can distribute in production with
[the `state deploy` command](https://docs.activestate.com/platform/state/commands/deploy/).

### But Wait, There's More!

The [State Tool](https://www.activestate.com/products/platform/state-tool/) has a lot of other
features including shared secret management, support for shared scripts, and the ability to execute
those scripts in response to events. See
[its documentation](https://docs.activestate.com/platform/state/) for more details.

Of course, we have more features in the works including CVE reporting and mitigation, license
reporting, and support for other languages like Ruby, JavaScript, and Java.

## Fun Technical Bits

The team I lead here at ActiveState has worked on some of the core components of the Platform, so I
want to talk about the nitty gritty a bit.

### Solver and Ingredients Database

The two big things we created are the (Dependency) Solver and the Ingredients Database (and its
API).

Let's start with the database.

Our entire package database is based on timestamped revisions. When we go to resolve dependencies
for a project configuration, that request is always timestamped based on the project's most recent
commit. That means the project does not see any data changes that were made after its commit.

So let's say that a project requires `DateTime`. You will always get the same version of `DateTime`
no matter how many times we solve for your dependencies. But you also get the same version of each
of `DateTime`'s dependencies, like `DateTime-Locale` and `DateTime-TimeZone`. And that applies
through the entire dependency graph.

So if we add a new version of `DateTime-Locale` that breaks your `DateTime` version[^5], your
project is unaffected. You can opt into newer versions explicitly, however.

This is actually even more granular than at the version level. We revision every version of every
Perl core and distro that we know about[^6]. So all of a distro's dependency data is revisioned.
This means that we can freely change that data without every breaking your build, allowing you to
opt into changes on your own schedule.

The system supports a lot of static metadata that cannot be expressed in the Perl ecosystem. We can
declare conflicts between distros or conflicts between a distro and a platform. But our platforms
are defined very granularly, so we are really defining dependencies or conflicts in terms of
platform components such as the kernel version, libc version, CPU architecture, etc.

And because we can add a new revision to an existing release, we can update this metadata as things
change. Take my `DateTime-Locale` example from up above. With CPAN, the only way to fix this is for
me to upload a new `DateTime` version that works with the new `DateTime-Locale`. I have no way to
tell the CPAN toolchain that every earlier version of `DateTime` _would_ work as long as it doesn't
use `DateTime-Locale` past a certain version. But our system supports all sorts of version
requirements, including defining minimum and maximum versions for dependencies, and even excluding
arbitrary versions in a range.

Another cool feature we built is support for dependency conditions, so we can easily say that a
dependency is only needed on a certain platform or with certain version of the Perl core. All of
this data is stored statically, so our Solver can give you useful errors when these constraints
cannot be satisfied.

I'm really proud of the design my team came up with for this. It's as simple as it can be, and we've
done a good job of ensuring that we apply this revisioning in a consistent way across all relevant
data, because we need to revision _everything_ that factors into dependency resolution. That
includes things like platform/OS data, global and per-package options like enabling debugging or
threading (coming soonish), the VM/Docker images in which we do builds, and anything else that could
affect the build output.

This extreme revisioning has made it much easier for us to change and update our data without the
risk of breaking existing projects[^7].

The Solver is based on an algorithm created by [Natalie Weizenbaum](https://github.com/nex3) while
working on the library tooling for the [Dart language](https://dart.dev/). She developed a
[SAT Solver](https://en.wikipedia.org/wiki/Boolean_satisfiability_problem) called
[PubGrub](https://medium.com/@nex3/pubgrub-2fb6470504f). Natalie has written
[a great introductory article on PubGrub](https://medium.com/@nex3/pubgrub-2fb6470504f), which I
highly recommend. There is also a
[detailed technical specification in the pub repository](https://github.com/dart-lang/pub/blob/master/doc/solver.md).

I wrote
[a post about this for the ActiveState blog](https://www.activestate.com/blog/dependency-resolution-optimization-activestates-approach/)
that goes into more detail on the specifics of our implementation and some of the ways it differs
from Natalie's design.

## Try It Out

Remember, you don't need an account to try it out. If you like it, you can always make an account
and associate it with your anonymous project.

If you have questions you can email me at autarch@urth.org, though depending on your question I may
ask you to post it on our [Community Forums (using Discourse)](https://community.activestate.com/).

[^0]:
    If you're wondering how this is entirely new since I just described what ActivePerl has always
    been, keep reading.

[^1]:
    We named it the State Tool so you can run `state activate` to start using it for a project. See
    what we did there?

[^2]:
    If you're about to point out that you can't necessarily relicense this software anyway, we know.
    Our license applied to the bundle, not the individual components. It is legally possible to
    license a software collection with a different license than applies to the individual
    components.

[^3]: Which is called "camel". You'll never guess what language it's written in!

[^4]:
    XS modules are still compiled to `.so` files, but those `.so` files statically link to any
    needed C libraries.

[^5]:
    Surely the author of those packages would never be so sloppy as to allow this to happen, but
    let's just imagine it could happen.

[^6]: Of course we do the same for all supported languages.

[^7]: For some reason users complain when their builds stop working.
