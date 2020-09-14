---
title: I Am the Master of Wheels
author: Dave Rolsky
type: post
date: 2009-07-25T21:54:45+00:00
url: /2009/07/25/i-am-the-master-of-wheels/
categories:
  - Uncategorized

---
It occurred to me today that if you look at my history as a CPAN author, you&#8217;ll see that I&#8217;ve either written or heavily participated in every popular target of re-invention on CPAN!

I started off by writing an ORM, [Alzabo][1]. Back when I released it, this was one of the very first ORMs for Perl. Amusingly, I re-invented the whole ORM concept pretty much independently. I don&#8217;t think I even heard the term until after Alzabo was released.

([Class::DBI][2] was also released around the same time, and became much more popular.)

Of course, if you do enough database programming in an OO language, an ORM is an obvious concept to &#8220;invent&#8221;, and that probably explains why there&#8217;s so damn many of them. People &#8220;invent&#8221; them before they realize that there are dozens already out there.

I&#8217;ve also worked on a templating system, [Mason][3]. In fact, before that, I wrote a mini-templating system at Digital River, where I worked with Ken Williams. Fortunately, Ken pointed me at Mason before I could get too far into my own, which was a good thing.

Mason is _also_ a (primitive) webapp framework, so I&#8217;ve worked on one of those too, as well as providing an odd patch or two to Catalyst and various Catalyst plugins.

Then there&#8217;s the [Perl DateTime project][4], which was an explicit and clearly thought out wheel reinvention exercise. The existing wheels were all kind of broken, and you couldn&#8217;t easily put any two wheels on the same car, so we came up with a plan for a whole set of interchangeable wheels and assorted other parts.

Nowadays I spend a lot of time on [Moose][5], which is one of the most recent (and by far the best) in a long series of &#8220;make Perl 5 OO better&#8221; modules.

To top off my wheel-ish history, I have a [_new_ ORM, Fey::ORM][6], meaning I am the creator of both one of the oldest and one of the newest ORMs on CPAN.

Truly, I am the master of wheels, both re-invention and polishing those already in existence.

 [1]: http://search.cpan.org/dist/Alzabo
 [2]: http://search.cpan.org/dist/Class-DBI
 [3]: http://www.masonhq.com/
 [4]: http://datetime.perl.org
 [5]: http://moose.perl.org
 [6]: http://search.cpan.org/dist/Fey-ORM

## Comments

### Comment by hdp on 2009-07-26 19:13:20 -0500
Mason&#8217;s really showing its age in some places. Maybe it&#8217;s time for a new templating language, too!