---
title: Perl 5 Core Principles
author: Dave Rolsky
type: post
date: 2011-07-10T12:38:40+00:00
url: /2011/07/10/perl-5-core-principles/
---

Way back when, the Perl (1, 2, 3, 4, 5) core was defined as "whatever Larry Wall says it is". Since
the advent of the Perl 6 project, Larry has spent less and less time on Perl 5, and he hasn't been
an active participant on the perl5-porters list for years. Absent Larry, I think the Perl 5 core
would benefit from an explicit set of principles.

I don't get to decide what those principles are, but I have some suggestions.

## TIMTOWTDI BSCINABTE

_There is more than one way do it but sometimes consistency is not a bad thing either._

For a long time, TIMTOWTDI was the Perl motto. In the past few years, we've seen the community move
towards agreeing on community standards. This agreement is by no means universal, but it's better
than nothing.

This principle says that you can't argue against an addition to the core because it favors one way
of doing things over another. That's no longer a valid argument in Perl land. You can, of course,
argue that the way being favored is not the best way.

## Perl 5 DWIM, But Only When There's Broad Agreement on WIM

_(DWIM == Does What I Mean)_

The smartmatch operator provides a perfect negative example. Its behavior in 5.12 and 5.14 is
insanely complex (try reading the docs in perlsyn). There's no way to achieve agreement on something
this complicated. Ricardo Signes has [proposed a simple alternative][1]. It only has five cases.
It's not as smart, but that's good!

Another way to phrase this might be that "Perl 5 is clever, but not too damn clever."

## Features Are Extensions

All new features should be written as extensions. In other words, new features should live in
modules (though those modules may be XS). There's been a lot of work by Zefram (and others?) to make
it possible to extend Perl using Perl. That should become the standard mechanism for adding new
features.

## OO is Here, Deal With It

The Perl 5 core should embrace object-oriented programming. The more that object-orientation takes
over the core, the better. Wouldn't it be nice if things like `stat()`, `open()`, and `$0` all
returned/used objects?

## Just Cause OO is Here Doesn't Mean Functional and Imperative Aren't

Perl 5 is a multi-paradigm language, and that's great. We never want to change that. You should be
able to write functional, imperative, and OO Perl, switching between the paradigms as appropriate.

## Your Principle Here

These are my suggestions. What are yours? I think it would be fantastic if the community could agree
on a few key principles. In my ideal world, discussions about changes to the core would always refer
back to these principles, in the same way that we used to refer back to Larry.

[1]: http://www.xray.mpe.mpg.de/mailing-lists/perl5-porters/2011-07/msg00226.html

## Comments

**chorny, on 2011-07-10 14:51, said:**  
On my computer with Windows, loading example from Synopsis of MooseX::Declare takes 4.5 CPU seconds
and 18 MB of RAM, compared to almost empty program with Benchmark.pm loaded. Also it requires
installation, which makes it not suitable to recommend to beginners. Some programmers will find hard
to install it because their OS installation (not Windows) does not have compiler installed.
MooseX::Declare has 18 open bugs, some of them are serious. Syntax of MooseX::Declare is not
supported by any syntax highlighter know to me, including Padre and is not supported by PPI.
MooseX::Declare is not included into perl5i due to taking too much time to load.

So MooseX::Declare in it's current form (developed by almost 3 years) is not a good example of "new
features should live in modules", but it is the only module that provides better syntax for class
definition.

**Dave Rolsky, on 2011-07-10 18:18, said:**  
@chorny: Sorry, that wasn't really clear in my post. The idea is that new features should live in
modules \_that are shipped with the core\_. The core should also ship all the bits necessary to do
Devel::Declare-like things.

That would probably encourage optimization of both the new feature and the feature-enabling features
(parser plugins, optree plugins, etc).

**Dave Rolsky, on 2011-07-10 18:19, said:**  
@chorny: Also, your mention of PPI is very misleading. PPI doesn't parse MX::Declare because PPI
doesn't parse it. Putting MX::Declare syntax into the core won't do anything to fix that.

In fact, putting it in core would just mean that PPI would now be considered broken when using with
Perl 5.x.

**Mark Fowler, on 2011-07-10 22:55, said:**  
Open doesn't \*return\* an object, but it does (as of 5.14) create something that can always be used
as an object

**szabgab.com, on 2011-07-11 02:23, said:**  
@Mark Fowler, actually I don't understand why open() still does not return the file handle (object)?
With the little understanding I have it seems that one should be able to write my
$fh = open '<',
$filename; and the parser could easily see that the first argument to open() is one
of the symbols supported by the function. Though I think I am now distracting from the main point of
the blog.

**Zbigniew Lukasiak, on 2011-07-11 04:15, said:**  
Not to distract too much from the discussion - but just to add some order :)

Two first points are 'meta rules', rules about how to make new rules, the three others are ordinary
rules.

**https://me.yahoo.com/a/eWaljkEXsutgnNBICriFMtXpPuhy#76632, on 2011-07-11 08:05, said:**  
@Gabor, that argument may be a variable and so not set at compile time. Besides that, currently, the
return value from open can be a PID. If you return the file handle object there you will have to
find another place to pass the PID back.

**Justin, on 2011-07-27 11:54, said:**  
**Make the common things easy, and the hard things possible**

It's not exactly Larry Wall's formulation, but I heard it this way first. I think this covers the
need for better OO support, it's so common that it should be an easy thing to do.
