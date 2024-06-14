---
title: Caching and the travis-perl Helpers
author: Dave Rolsky
type: post
date: 2017-10-01T17:36:22+00:00
url: /2017/10/01/caching-and-the-travis-perl-helpers/
---

The [travis-perl helpers][1] are great. If you haven't heard about them before, what they do is let
you test your Perl projects on Travis with a much wider range of Perls than Travis provides
natively. They also run your tests from the perspective of end users. What that means is that if
you're using [`Dist::Zilla`][2] or another module builder tool, the helpers will build a
distribution tarball, then unpack that and test it. This is a great way of ensuring that your dzil
configuration does what you think it does and that it produces something usable when uploaded to
CPAN.

However, one of the big downsides of the helpers is that they make your Travis runs quite a bit
slower. It'd be nice to speed these up. Fortunately, Travis has a nice caching system that lets you
cache part of the filesystem from a build to re-use later.

For Perl projects, one of the best things to cache is the tree of installed modules. If your
distribution has a lot of dependencies, not re-installing these each time can be a big win.

But in the past, this wasn't a good idea when using travis-perl. The reason is that it always ran
`cpanm` with the `--skip-satisfied` argument. This options tells `cpanm` that it should not upgrade
modules that are already installed unless a newer version is explicitly asked for. When you combine
this with caching, it means that your cached libraries will get more and more out of date as time
goes on. When caching is enabled we want to run `cpanm` **without** the `--skip-satisfied` argument.

Fortunately, the helpers now do just that if you pass `--always-upgrade-modules` to the `init`
script like this:

```
before_install:
  - eval $(curl https://travis-perl.github.io/init) --auto --always-upgrade-modules
```

If you're not using the `init --auto` form of the helpers, you can pass `--update-prereqs` to each
`cpan-install` call instead.

In my testing of one project, this shaved about a minute off each job's run for each version of Perl
when the cache is populated. I think this could be greatly improved by also caching the modules that
are installed to build the distro (at least for dzil-based distributions). That's a little trickier,
since from my delving into the helpers, there are installed in a random temp dir. Making that
cacheable presumably means not using a temp dir and instead putting the modules into a predictable
location. That could probably save another 30-60 seconds for dzil distros. It won't make much (if
any) difference for distros using `ExtUtils::MakeMaker` or `Module::Build`, however.

If you have any issues with this feature, please [report an issue in the travis-perl helpers
project][3]. Tag me in the issue text with @autarch and I'll try to take a look and see if I can
help.

[1]: https://github.com/travis-perl/helpers
[2]: https://metacpan.org/release/Dist-Zilla
[3]: https://github.com/travis-perl/helpers/issues
