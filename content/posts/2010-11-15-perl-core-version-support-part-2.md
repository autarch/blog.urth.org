---
title: Perl Core Version Support, Part 2
author: Dave Rolsky
type: post
date: 2010-11-15T11:21:54+00:00
url: /2010/11/15/perl-core-version-support-part-2/
categories:
  - Uncategorized

---
My last blog entry, [&#8220;What Versions of Core Perl Should Module Authors Support?&#8221;][1], generated a lot of discussion in the comments. There were a number of points raised that are worth addressing.

First, in a wild coincidence, RHEL 6 was released the day I wrote the blog entry. It includes Perl 5.10.1, which means that the last major Linux distro still shipping 5.8.x is now a little more up to date. That&#8217;s good, but unfortunately 5.10.1 is already fairly out of date, and seven years from now, it will be _ridiculously_ out of date.

One commenter, Stephen, said &#8220;but in my world, I get to deal with large enterprise customers that won&#8217;t let any non-vendor packages through the door &#8212; so we&#8217;re pretty much required to support, at a minimum, whatever openSUSE and RHEL decide to ship with.&#8221;

(As an aside, if they don&#8217;t let in non-vendor packages, why does it matter if the next version of Moose or DateTime doesn&#8217;t work that version of Perl? It&#8217;s not like there&#8217;s going to be a vendor package for new modules.)

I&#8217;m assuming that by &#8220;my world&#8221; he means the business where he works. Obviously, if you&#8217;re selling to enterprise customers you need to provide software that works on their platform of choice. It&#8217;s not feasible to say &#8220;upgrade your base OS&#8221;.

But how does that obligate me, as an author of _free software_, to support those platforms? Those people who want to use the same Perl for seven years are already paying Red Hat to support it. Of course, as [chromatic points out][2], they&#8217;re not paying any Perl core developers, so I&#8217;m not sure what their support is worth.

If people want the same level of support from me as they get from Red Hat, I can tell you where to send the checks. I _am_ willing to do support for my free software, though no one&#8217;s ever asked. If Stephen&#8217;s company _needs_ a new version of a module to be tested and supported on an ancient Perl, that seems like a good business case for paying the author of that module for support.

People take free software for granted. I spend a lot of time working on this stuff, and I release it because I want to. That doesn&#8217;t come with any sort of support obligation. As it happens, I do spend a lot of time on support (improving docs, fixing bugs, answering questions). But if you want a _guarantee_, then you need a contract, and you can have one, if you want to pay for it.

Adam Kennedy and Peter Rabbitson both asked what features are in a new Perl that would justify dropping support for 5.8.x. That&#8217;s a good question, but first let&#8217;s clarify what &#8220;dropping support&#8221; means.

There are several different levels of &#8220;dropping support&#8221;. Right now I have a whole bunch of Perls installed (5.8.5, 5.8.8, 5.10.1, 5.12.1, 5.12.2) and I test some of my modules with these Perls. I don&#8217;t do this _every_ release, but I do try to test Moose and Class::MOP with at least 5.8.5, 5.8.8, 5.10.1, and 5.12.2 every few releases. Same goes for Datetime, Params::Validate, and some others.

The most benign way to drop support is to simply stop testing on some older versions. I could still accept patches to make things work on 5.8.x, but I wouldn&#8217;t do any 5.8.x testing. I think that would probably be acceptable to a lot of people. Basically, it&#8217;s just saying &#8220;if you care about $VERSION, we&#8217;ll let you help support it&#8221;. This is worthwhile to me, since just remembering to test all those Perls is a hassle, and it slows down releases (especially when I have to install a bunch of updated prereqs on each Perl).

Once you start actively using new features from new Perls, things get more complicated. In some cases, there are modules on CPAN to bridge the gap. For example, the [MRO::Compat][3] module takes the mro feature added in 5.10.0 and backports it to earlier versions of Perl.

If such a thing exists, it&#8217;s hard to justify not using it. If it doesn&#8217;t exist and you can write it, the same goes. But some features just cannot be easily backported, like `//` or named regex captures.

So what&#8217;s new in Perl since the 5.8 series? Well, first, let&#8217;s remember that there&#8217;s more to Perl than Perl-level features. The XS API has changed a lot since Perl 5.8.x. Writing XS code that accomodates older Perls can be painful to impossible, depending on what you want to do. If you&#8217;re lucky it just means diving into the source of a newer Perl and figuring out what a new function does, then writing a compatibility shim for older Perls. That&#8217;s what [Devel::PPPort][4] is for, but it doesn&#8217;t cover everything.

The list of what&#8217;s new in each major Perl release is really quite long. As a random sample, 5.10.0 included `say()`, `given`/`when`, recursive regex patterns, named regex captures, the `_` prototype, `UNIVERSAL::DOES`, Unicode 5.0.0, and `//`.

With 5.12.0, we got the `package Foo 1.2` syntax, Unicode 5.2.0, lots of Unicode improvements, y2038-safety in core, pluggable keywords, `each` on arrays, and overloading for `qr`.

And with 5.14.0, we&#8217;ll get `$0` assignment fixes on Linux, optimizations for `shift()` without arguments, `given`/`when` will return a value, `my $new = $old =~ s/cat/dog/r` (yay!), `package Foo 1.2 { ... }`, and hooks into the core parser API.

It&#8217;s hard for me to say that any one of these features is absolutely vital for any module I maintain, but they do all add up to make Perl _easier and more fun_ to use.

Some of those features _will_ be vital for some authors. In particular, the pluggable keywords and parser API will make it much easier to write modules which manipulate core syntax, like [MooseX::Declare][5]. I suspect it may also make some impossible things possible.

That &#8220;more fun&#8221; part is pretty important. Remember, free software is free. I do this because I enjoy it. Keeping code working on old versions of Perl is not all that much fun. If it&#8217;s vitally important to your business, put your money where your mouth is.

 [1]: /2010/11/10/what-versions-of-core-perl-should-module-authors-support/
 [2]: http://www.modernperlbooks.com/mt/2010/11/sure-its-obsolete-but-at-least-its-enterprisey.html
 [3]: http://search.cpan.org/dist/MRO-Compat/
 [4]: http://search.cpan.org/dist/Devel-PPPort
 [5]: http://seearch.cpan.org/dist/MooseX-Declare

## Comments

### Comment by Zbigniew Lukasiak on 2010-11-16 14:45:23 -0600
A propos not paying the developers &#8211; apparently Perl is not alone here: <a href="http://www.reddit.com/r/programming/comments/e6d1w/none_of_the_major_unix_vendors_including_apple/" rel="nofollow ugc">http://www.reddit.com/r/programming/comments/e6d1w/none_of_the_major_unix_vendors_including_apple/</a>

### Comment by Dave Rolsky on 2010-11-16 14:59:53 -0600
@Zbigniew: I don&#8217;t think Red Hat really should (or should not) be paying core Perl developers. I do think the idea that they&#8217;ll support Perl past its end of life kind of ridiculous, since they don&#8217;t have any core Perl devs on staff, but that goes for lots of other tools that Red Hat includes as well.

### Comment by szabgab.com on 2010-11-16 15:19:21 -0600
I was quite surprised by the question of Adam Kennedy as I though most of us would want to work with the newest version of Perl and use the newest features. Especially on code we write in our free time.

On the other hand just the other day I wanted to use a module at a client. The module required Perl 5.10 and our servers are running CentOS that has an older version of Perl. I was very disappointed.

As this is a small company without strict corporate rules I considered installing my own version of perl 5.12 but I after building it and after installing some of the modules I needed I got stuck. I needed DBD::Pg and it wanted some external package &#8211; pg_config I think. That would have required the installation of some packages. At that point I gave up and decieded I will try to get by without that specific module.

Of course you and other authors are totally entitled to require whatever dependencies you want. I can&#8217;t come to complain ot demand anything as I am not paying you. Nor do I thnk this company will want to pay any module author but I think it would be nice if we could manage to start some money flowing that way.

I have not checked if an earlier version of the module had worked on older perls or not. I have not checked what are the actual reasons to require 5.10.

So I am just telling this storry.

### Comment by Leon Timmermans on 2010-11-16 18:48:22 -0600
I&#8217;m about to upload my fourth module that depends on 5.10. Two of them are XS modules that rely on functionality that was simply not available on 5.8. An other one relies on smartmatching rather deeply, and if it will ever support 5.8 it will be because I backported that somehow (I doubt I&#8217;ll have the round tuits for it, though I have considered it quite seriously). The last module fails on 5.8 for reasons I don&#8217;t fully understand, but it appears to bugs in 5.8 that will probably never be fixed.

I&#8217;m increasingly relying on 5.10 because it enables me to do useful and (IMHO) cool things that would otherwise be impossible. If that means 5.8 is out, too bad for them.