---
title: You don’t need to scale
author: Dave Rolsky
type: post
date: 2008-10-09T15:41:11+00:00
url: /2008/10/09/you-dont-need-to-scale/
---

Programmers like to talk about scaling and performance. They talk about how they made things faster,
how some app somewhere is hosted on some large number of machines, how they can parallelize some
task, and so on. They particularly like to talk about techniques used by monster sites like Yahoo,
Twitter, Flickr, etc. Things like federation, sharding, and so on come up regularly, along with talk
of MogileFS, memcached, and job queues.

This is lot like gun collectors talking about the relative penetration and stopping power of their
guns. It's fun for them, and there's some dick-wagging involved, but it doesn't come into practice
all that much.

Most programmers are working on projects where scaling and speed just aren't all that important.
It's probably a webapp with a database backend, and they're never going to hit the point where any
"standard' component becomes an insoluble bottleneck. As long as the app responds "fast enough",
it's fine. You'll never need to handle thousands of request per minute.

The thing that developers usually like to finger as the scaling problem is the database, but fixing
this is simple.

If the database is too slow, you throw some more hardware at it. Do some profiling and pick a
combination of more CPU cores, more memory, and faster disks. Until you have to have more than 8
CPUs, 16GB RAM, and a RAID5 (6? 10?) array of 15,000 RPM disks, your only database scaling decision
will be "what new system should I move my DBMS to". If you have enough money, you can just buy that
thing up front.

Even before you get to the hardware limit, you can do intelligent things like profiling and caching
the results of just a few queries and often get a massive win.

If your app is using too much CPU on one machine, you just throw some more app servers at it and use
some sort of simple load balancing system. Only the most brain-short-sighted or clueless developers
build apps that can't scale beyond a single app server (I'm looking at you, you know who).

All three of these strategies are well-known and quite simple, and thus are no fun, because they
earn no bragging rights. However, most apps will never need more than this. A simple combination of
hardware upgrades, simple horizontal app server scaling, and profiling and caching is enough.

This comes back to people fretting about the cost of using things like [DateTime][1] or [Moose][2].

I'll be the first to admit that DateTime is the slowest date module on CPAN. It's also the most
useful and correct. Unless you're making thousands of objects with it in a single request, please
stop telling me it's slow. If you _are_ making thousands of objects, patches are welcome!

But really, outside your delusions of application grandeur, does it really matter? Are you really
going to be getting millions of requests per day? Or is it more like a few thousand?

There's a whole lot of sites and webapps that only need to support a couple hundred or thousand
users. You're probably working on one of them ;)

[1]: http://search.cpan.org/dist/DateTime
[2]: http://search.cpan.org/dist/Moose

## Comments

**askbjoernhansen.com, on 2009-02-10 02:09, said:**  
For many many (most!) applications I completely agree with you. The interesting bits of "scaling" in
those cases is building high availability into the system. The 20 (or 2000) internal users can't
work when the system is down? Probably worth building it out so that's very unlikely to happen.

On RAID5: See, it's not that simple! :-) If you use RAID5 on your database server you will almost
certainly be very unhappy with the performance pretty fast. (You want RAID10, always).

On getting a million requests a day: Over on our little local search sites -
<http://www.yellowbot.com/-> we easily get a handful of millions "dynamic" requests a day. A bit of
users, a bit of search engine crawling, a bit of API requets and it adds up pretty fast. (Of course
that's still likely just 50-100 requests a second depending on the traffic patterns).

However, the scaling/performance fun isn't even so much on the front end. It's the background
processing of all our data that's harder. There's too much to fit in the 32GB memory that was cheap
when we last bought servers. There are too many problems that are relatively harder to parallelize,
etc.

You also pretty quickly run into the price/performance wall. We have another set of systems where we
can fit the full data set into 32GB memory, but when we have a heavy round of data updates, they
just barely keep up with disk I/O. Yes, we could get faster disk systems; but 1) only for so long
and 2) at a price. Dividing up the data set (easy-ish in this case) pretty much Just Solves It.

(Yes, we are happily inflating all our date/time data to DateTime objects :-) )

**askbjoernhansen.com, on 2009-02-10 02:16, said:**  
Hmn, I just looked again and across our different sites it seems like it's more like 10 million
requests a day than 5. Anyway, my point of that was the same: It can be pretty fast ending up with a
decent number of requests. :-)
