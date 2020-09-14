---
title: Revisiting my November, 2010 Todo List
author: Dave Rolsky
type: post
date: 2012-09-19T15:04:37+00:00
url: /2012/09/19/revisiting-my-november-2010-todo-list/
categories:
  - Uncategorized

---
Back in November of 2010, I wrote an entry on this blog titled [My Programming-Related Todo List][1]. The title is a bit misleading since it was really more of a todo &#42;wish&#42; list than a realistic list of things I could get done.

I figured I&#8217;d revisit it (and depress myself in the process) to see everything I hadn&#8217;t done.

## CPAN Search $NEXT

Well, I didn&#8217;t do it, but a bunch of [other people did][2], so at least I can take it off my list. Of course, the MetaCPAN still doesn&#8217;t do everything on my wishlist, but it&#8217;s a great start.

## Full CLDR in Perl

Zero progress made. Someone did release a module recently that provides a very primitive interface to the CLDR project&#8217;s data (which I can&#8217;t remember the name of). It doesn&#8217;t implement all the complex logic that is needed to handle CLDR&#8217;s data properly, but maybe the author will get to this at some point.

## DateTime V2.0

Well, I did fix a few bugs in DateTime v0.

## Make &#96;DateTime::TimeZone&#96; use Zefram&#8217;s binary Olson database reader

Zefram made a lot of progress on this and then went dark. I need to poke him. To the best of my knowledge this is basically done.

## DateTime for Perl 6

This will be out by Christmas.

## Mason 2.0

Jon Swartz released a [Mason 2.0][3] in early 2011, but it&#8217;s not exactly what I wanted for Mason 2.0 myself. I&#8217;ve toyed with the idea of writing my own templating system, but do we really need another templating system? Also, using Mason 1.x under Catalyst still works well for my needs.

## WYSIWYG Editor in Silki

I haven&#8217;t really done much with [Silki][4]. Writing it was a good experiment and learning experience, but does the world need another piece of wiki software?

## Extract the HTML to Wiki converter from Silki

This is still worth doing.

## Generic blog/forum/wiki spam filter system

I released a few modules in the [Antispam][5] namespace, but it&#8217;s not quite a &#8220;system&#8221;.

## Finish my donor/volunteer management CRM

This has been stalled for a long time. My main motivation for working on this was because I wasn&#8217;t terribly happy at my previous job, and I thought working for myself would be better. Since then I&#8217;ve moved to [MaxMind][6]. I actually like working there, so my motivation to work for myself is diminished.

## VegGuide Technical Revamp

This still needs to happen. I did, however, release a [REST API][7] and [REST API explorer][8] for VegGuide.

## Rewrite perltidy using &#96;PPI&#96;

Total fantasy.

## Enhance VCI to support commits and create Dist::Zilla::Plugin::VCI

I forgot about this one until now. It&#8217;s a good idea, I suppose, except that [VCI][9] development seems to have stalled.

## Find a way to eliminate the compilation hit from Moose

I did actually take a small stab at a Moose compiler. It was a failed experiment but at least I learned about a path that won&#8217;t work.

## Introduction to Object-Oriented Programming (using Moose)

Sure, write a book. Who was I kidding?

## Moose Class Day Two

This was also motivated by wanting to find a way to work for myself.

## YAPC 2012 in Minneapolis

This could have happened but then I decided to work on the [Twin Cities Veg Fest][10] instead. There&#8217;s no way I could&#8217;ve done both.

## Verdict

Well, like I said, it was really more of a wish list than a todo list. See you in two years?

 [1]: /2010/11/01/my-programming-related-todo-list/
 [2]: https://metacpan.org
 [3]: https://metacpan.org/module/Mason
 [4]: http://silkiwiki.org/
 [5]: https://metacpan.org/search?q=antispam
 [6]: http://www.maxmind.com
 [7]: http://www.vegguide.org/site/api-docs
 [8]: http://www.vegguide.org/api-explorer/
 [9]: https://metacpan.org/release/VCI
 [10]: http://www.tcvegfest.com/

## Comments

### Comment by joel-a-berger.myopenid.com on 2012-09-19 18:37:25 -0500
I really like the templating engine in Mojolicious, might you consider using it? Its nicely minimal while still having full access to Perl.

As to rewriting perltidy using PPI, this sounds like a great idea for GSoC or even the highschool version, the Google Code-In. Lots of work, but well defined and more-or-less straightforward.

### Comment by Dave Rolsky on 2012-09-20 00:18:31 -0500
@Joel: As I said, Mason 1 is fine for now. I don&#8217;t see what the Mojolicious template system would get me, other than another dependency.

### Comment by zzbbyy on 2012-09-20 07:11:52 -0500
A propos your AntiSpam work &#8211; here at work we have a few NaiveBayes based tools for it &#8211; they use AI::Categorizer as the basis and I learned to hate it. Anyone thinks about rewriting it to some sane API and Moose?

### Comment by i.d.norton on 2012-09-23 03:06:12 -0500
Finish my donor/volunteer management CRM

Take a look at Civil CRM. No, it&#8217;s not Perl but it does the job and these days I&#8217;m much more interested in that than if I can write it myself :-) 

<a href="http://www.civicrm.org/" rel="nofollow ugc">http://www.civicrm.org/</a>

The Enlightened Perl organisation started using it earlier this year alongside Drupal.