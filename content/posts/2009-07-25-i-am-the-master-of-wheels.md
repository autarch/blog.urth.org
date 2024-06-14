---
title: I Am the Master of Wheels
author: Dave Rolsky
type: post
date: 2009-07-25T21:54:45+00:00
url: /2009/07/25/i-am-the-master-of-wheels/
---

It occurred to me today that if you look at my history as a CPAN author, you'll see that I've either
written or heavily participated in every popular target of re-invention on CPAN!

I started off by writing an ORM, [Alzabo][1]. Back when I released it, this was one of the very
first ORMs for Perl. Amusingly, I re-invented the whole ORM concept pretty much independently. I
don't think I even heard the term until after Alzabo was released.

([Class::DBI][2] was also released around the same time, and became much more popular.)

Of course, if you do enough database programming in an OO language, an ORM is an obvious concept to
"invent", and that probably explains why there's so damn many of them. People "invent" them before
they realize that there are dozens already out there.

I've also worked on a templating system, [Mason][3]. In fact, before that, I wrote a mini-templating
system at Digital River, where I worked with Ken Williams. Fortunately, Ken pointed me at Mason
before I could get too far into my own, which was a good thing.

Mason is _also_ a (primitive) webapp framework, so I've worked on one of those too, as well as
providing an odd patch or two to Catalyst and various Catalyst plugins.

Then there's the [Perl DateTime project][4], which was an explicit and clearly thought out wheel
reinvention exercise. The existing wheels were all kind of broken, and you couldn't easily put any
two wheels on the same car, so we came up with a plan for a whole set of interchangeable wheels and
assorted other parts.

Nowadays I spend a lot of time on [Moose][5], which is one of the most recent (and by far the best)
in a long series of "make Perl 5 OO better" modules.

To top off my wheel-ish history, I have a [_new_ ORM, Fey::ORM][6], meaning I am the creator of both
one of the oldest and one of the newest ORMs on CPAN.

Truly, I am the master of wheels, both re-invention and polishing those already in existence.

[1]: http://search.cpan.org/dist/Alzabo
[2]: http://search.cpan.org/dist/Class-DBI
[3]: http://www.masonhq.com/
[4]: http://datetime.perl.org
[5]: http://moose.perl.org
[6]: http://search.cpan.org/dist/Fey-ORM

## Comments

**hdp, on 2009-07-26 19:13, said:**  
Mason's really showing its age in some places. Maybe it's time for a new templating language, too!
