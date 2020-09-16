---
title: Revisiting my November, 2010 Todo List
author: Dave Rolsky
type: post
date: 2012-09-19T15:04:37+00:00
url: /2012/09/19/revisiting-my-november-2010-todo-list/
---
Back in November of 2010, I wrote an entry on this blog titled [My Programming-Related Todo List][1]. The title is a bit misleading since it was really more of a todo 'wish' list than a realistic list of things I could get done.

I figured I'd revisit it (and depress myself in the process) to see everything I hadn't done.

## CPAN Search $NEXT

Well, I didn't do it, but a bunch of [other people did][2], so at least I can take it off my list. Of course, the MetaCPAN still doesn't do everything on my wishlist, but it's a great start.

## Full CLDR in Perl

Zero progress made. Someone did release a module recently that provides a very primitive interface to the CLDR project's data (which I can't remember the name of). It doesn't implement all the complex logic that is needed to handle CLDR's data properly, but maybe the author will get to this at some point.

## DateTime V2.0

Well, I did fix a few bugs in DateTime v0.

## Make `DateTime::TimeZone` use Zefram's binary Olson database reader

Zefram made a lot of progress on this and then went dark. I need to poke him. To the best of my knowledge this is basically done.

## DateTime for Perl 6

This will be out by Christmas.

## Mason 2.0

Jon Swartz released a [Mason 2.0][3] in early 2011, but it's not exactly what I wanted for Mason 2.0 myself. I've toyed with the idea of writing my own templating system, but do we really need another templating system? Also, using Mason 1.x under Catalyst still works well for my needs.

## WYSIWYG Editor in Silki

I haven't really done much with [Silki][4]. Writing it was a good experiment and learning experience, but does the world need another piece of wiki software?

## Extract the HTML to Wiki converter from Silki

This is still worth doing.

## Generic blog/forum/wiki spam filter system

I released a few modules in the [Antispam][5] namespace, but it's not quite a "system".

## Finish my donor/volunteer management CRM

This has been stalled for a long time. My main motivation for working on this was because I wasn't terribly happy at my previous job, and I thought working for myself would be better. Since then I've moved to [MaxMind][6]. I actually like working there, so my motivation to work for myself is diminished.

## VegGuide Technical Revamp

This still needs to happen. I did, however, release a [REST API][7] and [REST API explorer][8] for VegGuide.

## Rewrite perltidy using `PPI`

Total fantasy.

## Enhance VCI to support commits and create Dist::Zilla::Plugin::VCI

I forgot about this one until now. It's a good idea, I suppose, except that [VCI][9] development seems to have stalled.

## Find a way to eliminate the compilation hit from Moose

I did actually take a small stab at a Moose compiler. It was a failed experiment but at least I learned about a path that won't work.

## Introduction to Object-Oriented Programming (using Moose)

Sure, write a book. Who was I kidding?

## Moose Class Day Two

This was also motivated by wanting to find a way to work for myself.

## YAPC 2012 in Minneapolis

This could have happened but then I decided to work on the [Twin Cities Veg Fest][10] instead. There's no way I could've done both.

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

**joel-a-berger.myopenid.com, on 2012-09-19 18:37, said:**  
I really like the templating engine in Mojolicious, might you consider using it? Its nicely minimal while still having full access to Perl.

As to rewriting perltidy using PPI, this sounds like a great idea for GSoC or even the highschool version, the Google Code-In. Lots of work, but well defined and more-or-less straightforward.

**Dave Rolsky, on 2012-09-20 00:18, said:**  
@Joel: As I said, Mason 1 is fine for now. I don't see what the Mojolicious template system would get me, other than another dependency.

**zzbbyy, on 2012-09-20 07:11, said:**  
A propos your AntiSpam work - here at work we have a few NaiveBayes based tools for it - they use AI::Categorizer as the basis and I learned to hate it. Anyone thinks about rewriting it to some sane API and Moose?

**i.d.norton, on 2012-09-23 03:06, said:**  
Finish my donor/volunteer management CRM

Take a look at Civil CRM. No, it's not Perl but it does the job and these days I'm much more interested in that than if I can write it myself :-) 

<a href="http://www.civicrm.org/" rel="nofollow ugc">http://www.civicrm.org/</a>

The Enlightened Perl organisation started using it earlier this year alongside Drupal.