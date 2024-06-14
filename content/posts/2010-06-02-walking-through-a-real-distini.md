---
title: Walking Through a Real dist.ini
author: Dave Rolsky
type: post
date: 2010-06-02T14:26:52+00:00
url: /2010/06/02/walking-through-a-real-distini/
---

In a comment on [my entry about Dist::Zilla pros and cons][1], Phred says:

> I'm not clear on the value Dist::Zilla provides other than some versioning auto-incrementing and
> syntactic sugar for testing.

This brings a up a good question. What the heck to does dzil do?

Let's walk through a `dist.ini` file from a real project. I'll use the `dist.ini` from my [Markdent
distribution][2]. This should answer the "what does it do" question quite well.

Here's the whole file:

```
name    = Markdent
author  = Dave Rolsky <autarch@urth.org>
license = Perl_5
copyright_holder = Dave Rolsky
copyright_year   = 2010

version = 0.13

[@Basic]
[InstallGuide]
[MetaJSON]

[MetaResources]
bugtracker.web    = http://rt.cpan.org/NoAuth/Bugs.html?Dist=Markdent
bugtracker.mailto = bug-markdent@rt.cpan.org
repository.url    = http://hg.urth.org/hg/Markdent
repository.web    = http://hg.urth.org/hg/Markdent
repository.type   = hg

[PodWeaver]

[KwaliteeTests]
[NoTabsTests]
[EOLTests]
[Signature]

[CheckChangeLog]

[Prereq]
Digest::SHA1                   = 0
HTML::Stream                   = 0
List::AllUtils                 = 0
Moose                          = 0.92
MooseX::Params::Validate       = 0.12
MooseX::Role::Parameterized    = 0
MooseX::SemiAffordanceAccessor = 0.05
MooseX::StrictConstructor      = 0.08
MooseX::Types                  = 0.20
namespace::autoclean           = 0.09
Tree::Simple                   = 0
Try::Tiny                      = 0

[Prereq / TestRequires]
File::Slurp                          = 0
Test::Deep                           = 0
Test::Differences                    = 0
Test::Exception                      = 0
Test::More                           = 0.88
Tree::Simple::Visitor::ToNestedArray = 0

[@Mercurial]
```

That's a mouthful. Let's step through it in tiny chunks ...

```
name    = Markdent
author  = Dave Rolsky <autarch@urth.org>
```

Setting these does several things. First, these values will end up in the generated `Makefile.PL`
for the distro. Second, these values are available for plugins which do POD munging, which we'll
look at shortly. In particular, the author will end up in the every module's POD.

```
license = Perl_5
```

The license setting is used for several things. First, the `License` plugin will use it to add a
`LICENSE` file to the distro. Second, it is also available to POD mungers.

```
copyright_holder = Dave Rolsky
copyright_year   = 2010
```

This is another bit for the POD mungers. Together with the license, we'll end up with this POD
section in each module:

```
=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Dave Rolsky.

This is free software; you can redistribute it and/or modify it under

the same terms as the Perl 5 programming language system itself.
```

The distribution version:

```
version = 0.13
```

Again, this ends up in both my `Makefile.PL` and my POD.

```
[@Basic]
```

This is a plugin _bundle_, which is a name for a pre-defined set of plugins. The `Basic` bundle
contains:

```
[GatherDir]
[PruneCruft]
[ManifestSkip]
[MetaYAML]
[License]
[Readme]
[ExtraTests]
[ExecDir]
[ShareDir]
[MakeMaker]
[Manifest]
[TestRelease]
[ConfirmRelease]
[UploadToCPAN]
```

Whoa, that's a lot. So what do these do?

```
[GatherDir]
```

This tells dzil that it should include all the files in the current directory (the root of my
distro) in the generated distro. I have to include this, or I won't end up with a distro at all!

```
[PruneCruft]
```

This prunes the gathered files to remove generated files like a `Build` file, files that start with
a dot (.), etc.

```
[ManifestSkip]
```

This prunes the gathered files based on the contents of a `MANIFEST.SKIP` file.

```
[MetaYAML]
```

This generates a `META.yml` file for the distro (using version 1.4 of the CPAN Meta format).

```
[License]
```

This plugin generates a `LICENSE` file, based on the value I set for the license earlier.

```
[Readme]
```

This one generates a fairly minimal `README`. Arguably, it's so minimal it's useless. It could
probably be improved ;)

```
[ExtraTests]
```

This looks for tests under my working copy's `xt` directory. This directory can contain
subdirectories for three different types of "extra" tests, smoke tests, author tests, and release
tests. Each of these directories has its tests rewritten so that they only run under specific
circumstances (based on environment variables). The tests are rewritten into the `t` directory.

Typically, I only use `xt/release`. The tests in the release directory are run when
`$ENV{RELEASE_TESTING}` is true. The `dzil release` command makes sure this is true, so my release
tests are run before I do a release, but _not_ when the module is installed from CPAN. This is
perfect for things like POD tests.

```
[ExecDir]
```

This plugin arranges for a directory's contents to be installed as executables. Well, actually, it
just marks the files as executables, and another plugin does something useful with them. By default,
it looks for a directory named `bin`.

```
[ShareDir]
```

Just like `ExecDir` but for "share" files (non-executable content like templates, images, etc).

```
[MakeMaker]
```

This generates `Makefile.PL` for the distro. This plugin is pretty smart, and generates a file with
lots of conditionals so that it does the best job it can for the version of `ExtUtils::MakeMaker`
that is available on the installing user's machine. If you've ever written this sort of conditional
crap you know how annoying it is to maintain. Now I don't have to deal with this. As a bonus, future
versions of dzil will account for new versions of EUMM, and I'll get a better `Makefile.PL` for
free.

This plugin makes use of the information provided by the `ExecDir` and `ShareDir` plugins we saw
earlier. It arranges to have these files installed in the right place via `ExtUtils::MakeMaker` and
`File::ShareDir`.

There is also a `ModuleBuild` plugin, but dzil really makes the difference between the two minimal.
Unless I want to integrate a custom `Module::Build` subclass, as I did with [Silki][3], there isn't
much difference between EUMM and MB for a project which uses dzil.

```
[Manifest]
```

This plugin creates the `MANIFEST`.

```
[TestRelease]
```

This runs the tests when I run `dzil release`.

```
[ConfirmRelease]
```

This prompts me to ask if I'm really sure I want to upload a distro when I run `dzil release`.

```
[UploadToCPAN]
```

I bet you can figure out what this does.

```
[InstallGuide]
```

This generates a nice `INSTALL` file. This plugin is smart. It generates the right instructions
regardless of whether the distro is using EUMM or `Module::Build`.

```
[MetaJSON]
```

This generates a `META.json` file for the distro (using version 2.0 of the CPAN Meta format).

```
[MetaResources]
bugtracker.web    = http://rt.cpan.org/NoAuth/Bugs.html?Dist=Markdent
bugtracker.mailto = bug-markdent@rt.cpan.org
repository.url    = http://hg.urth.org/hg/Markdent
repository.web    = http://hg.urth.org/hg/Markdent
repository.type   = hg
```

This adds a "resources" section to my `META.*` files. There are some plugins on CPAN which will
automate this. For the repository settings, the plugin looks at your working copy to figure out your
VCS and remote VCS uris. I might switch over to these plugins in the future, although I think I'd
actually have to add Mercurial support first.

```
[PodWeaver]
```

I mentioned "POD mungers" several times. `Pod::Weaver` is a POD rewriting module which does all
sorts of fancy stuff, though I'm using just using a subset of its default behavior.

First, it looks in my module files for a comment in the form:

```
# ABSTRACT: Some text here
```

It uses this to generate the "NAME" section in the POD.

It also inserts "VERSION", "AUTHOR", and "COPYRIGHT AND LICENSE" sections. `Pod::Weaver` also lets
you do even fancier stuff, like use POD dialects, add custom sections, etc. I'll be investigating
this further in the future. Really, this module deserves its own blog entry or three.

```
[KwaliteeTests]
[NoTabsTests]
[EOLTests]
```

These add some release tests for various sanity checks. I never need to customize these tests, so I
can let the plugins write them out for me.

```
[Signature]
```

This signs the distro using `Module::Signature`.

```
[CheckChangeLog]
```

This checks my `Changes` file to ensure that I have an entry for the version mentioned in my
`dist.ini`. It could be smarter and check for a _date_ as well. I'm sure patches are welcome ;)

```
[Prereq]
...
```

This should be obvious. It lists the prerequisites for my distro. There is also an `AutoPrereq`
module. I don't use this because it generates a lot of prereqs I think are cruft, like core modules,
or multiple modules in the same distro.

```
[Prereq / TestRequires]
...
```

Again, this is pretty obvious.

```
[@Mercurial]
```

Another plugin bundle. I [wrote some plugins][4] to automate some release tasks for a
Mercurial-using project.

When I run `dzil release`, it will check to make sure that my repository is in a clean state (no
changes that haven't yet been checked in). After the release is uploaded, it tags my working copy
and then pushes the changes back to the remote.

### Summary

At a high level, dzil does a couple different tasks.

It ensures that support files like the MANIFEST and LICENSE stay up to date. It also helps improve
compatibility by generating a "smart" `Makefile.PL`. Basically, it takes distribution metadata and
generates all the files support files I need. Of course, both EUMM and `Module::Build` already did
that, but dzil takes this several steps further.

The pod munging is similar. It includes standard POD boilerplate that _should_ be in all my modules,
but can be annoying to maintain.

It also helps me include various "sanity tests". Since the plugin writes them out anew each time I
build the distro, I don't have to worry about keeping them up to date with changes to the testing
modules, I just have to update the plugin.

Besides automating support, dzil also helps automate the actual release process. It adds some sanity
checks like checking the changelog and the working copy state, and after the release it automates
tagging and pushing.

Whereas I previously had to maintain various support files and update them as the toolchain changed,
I can now update my plugins and get the updated support files "for free" in every distro I maintain.
Overall, the number of steps that go into a release has been hugely reduced, and the possibility of
error is much lower. That means its easier to make a new release, and the release quality is higher.
Faster _and_ better!

At last count, I maintain (for some value of maintain) 66 distros, so anything I can do to reduce
busy work is very welcome!

[1]: /2010/05/25/distzilla-pros-and-cons/
[2]: http://search.cpan.org/dist/Markdent
[3]: http://search.cpan.org/dist/Silki
[4]: http://search.cpan.org/dist/Dist-Zilla-Plugin-Mercurial

## Comments

**Cosimo, on 2010-06-02 16:29, said:**  
This was what I needed. Ever since I read about Dist::Zilla I knew it could be very useful, but
somewhat never got a real complete example.

Thanks for this post, very helpful.

**Caleb Cushing ( xenoterracide ), on 2010-06-02 17:31, said:**  
shouldn't you Filter MetaYAML ? since you're using MetaJSON.

```
[@Filter]
bundle = @Basic
remove = MetaYAML
```

**Dave Rolsky, on 2010-06-02 17:34, said:**  
@Caleb: No, you can include both in a distro. That's probably the best path forward, since that way
anything not using CPAN::Meta for meta file handling can find an old-style (v1.4) YAML file, and
updated code with see the JSON file.

**Caleb Cushing ( xenoterracide ), on 2010-06-02 17:49, said:**  
also for Readme I Filter Readme and use

```
[ReadmeFromPod]
```

obviously that's just a preference.
