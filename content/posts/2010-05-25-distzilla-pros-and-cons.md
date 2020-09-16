---
title: Dist::Zilla Pros and Cons
author: Dave Rolsky
type: post
date: 2010-05-25T20:49:14+00:00
url: /2010/05/25/distzilla-pros-and-cons/
---
_Edit October 25, 2018:_

I wasn't really correct about the immutable cons. While by default dzil acts as a giant pre-processor, there are ways to use it that minimize the differences between the code released on CPAN and the code in your repo. You can have a $VERSION in all your modules, you can have a Makefile.PL in your repo, you can have a LICENSE file. And you can do all this while still letting dzil manage these things for you. See my [plugin bundle][1] for an example of how to do this.

* * *

_Original post:_

I've been playing with [Dist::Zilla][2] lately, and while I like it, I've also realized there's some perhaps not-so-obvious cons to using it as well. There's also some obvious cons, and some obvious pros.

In talking about cons, there are really two categories. Some of the cons are essential to the design of dzil. others are non-essential, and can easily be fixed in the future, given a sufficient supply of round tuits. Obviously, the essential cons are most important.

Let's get the non-essential ones out of the way. The obvious one is that the docs are pretty minimal right now. I found that to really get what I wanted, I had to mix together cargo-culting and source diving. I still don't understand how the heck I can make use of [Pod::Weaver][3].

A closely related problem is that while there are lots of dzil plugins, they too are mostly poorly documented, and they're also insufficiently flexible. A good example, is the [Dist::Zilla::Plugin::PodSpellingTests][4] plugin. Spell checking your pod is great, and I'd love to automate it as much as I can. However, if you're doing spell checking you _must_ include a custom dictionary that includes things like your name.

This plugin adds a wordlist that the author created in the form of a CPAN module. That's not very useful when the wordlist module doesn't include a word you want to whitelist. There's no way to provide an alternate module. Of course, the real problem is that this is a terrible interface. I don't want to release a new distro every time I add a word to my wordlist. The right way to do this is to look for a .pod-spelling file in the distro root.

Ultimately, I skipped this plugin and created my POD spelling test "by hand".

Let's not pick on Marcel too much. My own [dzil Mercurial plugin][5] is pretty minimal too. It works for me, but may not satisfy anyone else.

Also, dzil is slow. It uses Moose for a CLI app, which is a known-slow combination. Someone should improve Moose startup speed ;)

But as I said, these are non-essential problems, and all entirely fixable.

So what can't be fixed?

Ultimately, using dzil to its utmost means creating a sharp divide between the source repository and released code. Dzil is in part a big ol' pre-processor. It does things like add a `$VERSION` to each module, add boilerplate to the POD, generate a LICENSE file, etc.

Of course, Perl module authors are already accustomed to this. I'm sure that most authors don't check their META.yml files into source control and edit them by hand. Instead, they're updated as part of the release process. Dzil just takes this several steps further.

However, some of these steps can be particularly problematic. If you allow dzil to add the `$VERSION` line, that means that when you use the distro's modules directly from the `lib` directory, they have no version. This can be a problem if you're trying to test some other module against the source repo, and that other module has a minimum version requirement.

Similarly, when you run tests with `prove`, you're testing something that isn't quite what gets released. Don't worry too much; when you `dzil release`, it runs the tests against the post-processed code, so you're not likely to incur bugs this way.

You _can_ choose to not use the `$VERSION`-inserting plugin, and maintain the `$VERSION` manually, and dzil still has lots of other useful features. Nonetheless, this sort of issue is likely to crop up with other plugins.

So what are the pros? Ultimately, it makes maintaining modules easier. The less non-essential work I have to do in order to make a new release, the better. Also, some of the plugins do things to ensure that my releases are not broken, like checking for an update to Changes that matches the current module version, or ensuring that I have pod syntax tests as part of the release.

For someone like me, who has dozens of modules on CPAN, these time savings really add up.

Overall, I'm pretty happy with dzil, and I consider the eliminated drudgery a win, despite the hassles. I'm hoping that this entry will give people a better idea of what they're getting into if they explore Dist::Zilla.

I also look forward to rjbs finally finishing the much-discussed configuration system overhaul so he can finally write some damn docs ;)

 [1]: https://metacpan.org/release/Dist-Zilla-PluginBundle-DROLSKY
 [2]: http://dzil.org
 [3]: http://search.cpan.org/dist/Pod-Weaver
 [4]: http://search.cpan.org/dist/Dist-Zilla-Plugin-PodSpellingTests
 [5]: http://search.cpan.org/dist/Dist-Zilla-Plugin-Mercurial

## Comments

**rjbs.manxome.org, on 2010-05-25 21:25, said:**  
For what it's worth, I pretty much agree with every thing you said here.

**Yanick Champoux, on 2010-05-29 11:02, said:**  
Lately I had the same kind of ruminations. For me, the biggie is really the creation of a divide between the casual contributor and the dzilla-enabled.

One solution, I guess, is for non-dzilla-enabled contributors[1] to patch against a [gitpan](http://www.github.com/gitpan) release branch. Or, even better, have a build branch generated automatically by [Dist::Zilla::Plugin::Git::CommitBuild](http://search.cpan.org/~jquelin/Dist-Zilla-Plugin-Git-1.101330/lib/Dist/Zilla/Plugin/Git/CommitBuild.pm). It's not a perfect solution, because the port of a patch from the build branch to the code branch is often not trivial enough to be done by a `git cherry-pick`, but it's generally not that hard either, and seems to be the most reasonable compromise.

[1] And some dzilla-enabled contributors as well, as I realized when I hacked on - of all modules - `Dist::Zilla::Plugin::Git::CommitBuild`. Although I already had `Dist::Zilla` installed, it took me the better part of half an hour to install `Dist::Zilla::PluginBundle::JQUELIN`, and when I finally did, I discovered that one of the used plugins don't work with the latest version of `dzilla`. At that point, I remember doing a few head/desk interfacing. :-)

**Dave Rolsky, on 2010-05-29 11:27, said:**  
@Yanick: I think some of those problems are simply the result of the fact that dzil is still relatively immature, and plugins even more so.

That means that dzil is breaking backwards compat often, which in turns means that the latest CPAN release of an extension cannot install.

Once dzil stabilizes, I think this will be less of an issue.

As far as contributors, I agree that this is an issue, but it's not unique to dzil. It comes up every time module authors start using new infrastructure. A good example would be Module::Install. We use MI and some MI plugins with Moose. You need to install those if you want to run "make tests" from the Moose repo.

This is less of an issue, because a lot of people doing Perl dev now have Module::Install already installed. So as more people start using dzil (and as dzil stabilizes), this will become less of an issue.

Basically, living on the bleading edge always causes problems for contributors.

**Yanick Champoux, on 2010-05-31 11:54, said:**  
_I think some of those problems are simply the result of the fact that dzil is still relatively immature, and plugins even more so._

Very true. dzil is still extremely young, and thanks to rjbs++ seemingly endless coding frenzy, it's molting at dizzying speed, showing even brightest colors each time the new skin appears under the old. 

_As far as contributors, I agree that this is an issue, but it's not unique to dzil. [..] This is less of an issue, because a lot of people doing Perl dev now have Module::Install already installed. So as more people start using dzil (and as dzil stabilizes), this will become less of an issue._ 

_Basically, living on the bleading edge always causes problems for contributors._

Exactly. And don't get me wrong: I love livin' on the edge. I'm merely also aware that until dzil conquers the world, I also have to think of the children^D^D^D^D^D^D^D^D contributors and strike a balance between living in the future and managing the present. Preferably a balance that maximize both sides of the coin. :-)

**Phred, on 2010-06-02 14:09, said:**  
Dist::Zilla looks interesting, but when you start to play with it the immediate observation is there is no clear description of the scope of what it does. I was initially under the impression that it handled module creation as well as build and testing. I'm still using h2xs -X for starting modules. Yep, I know about Module::Starter, it has more bells and whistles than I need.

I'm not clear on the value Dist::Zilla provides other than some versioning auto-incrementing and syntactic sugar for testing. It seemed to be about as much end user work to distribute a module with and without D:Z but maybe I'm not familiar with the power user features yet.

**Phred, on 2010-06-02 16:14, said:**  
I disagree that the docs are too minimal. I think they are too verbose. There's so much documentation there you have to wade through it all to find what D:Z does and how to invoke basic usage. It needs a SYNOPSIS section with working code examples.

**Dave Rolsky, on 2010-06-02 16:18, said:**  
@Phred: There's a lot of POD, but not that much documentation.

And there's no manual-style docs. It's all (very minimal) API, per-module docs. What's really needed are docs about the system as a whole.
