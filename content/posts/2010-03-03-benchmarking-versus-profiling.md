---
title: Benchmarking Versus Profiling
author: Dave Rolsky
type: post
date: 2010-03-03T14:59:47+00:00
url: /2010/03/03/benchmarking-versus-profiling/
---

First, here's the tl;dr summary ... Benchmarking is for losers, Profiling rulez!

I've noticed [a couple][1] [blog entries][2] in the Planet Perl Iron Man feed discussing which way
of stripping whitespace from both ends of a string is fastest.

Both of these entries discuss examples of _benchmarking_. Programmers love benchmarks. After all,
it's a great chance to whip out one's performance-penis and compare sizes, trying to come up with
the fastest algorithm.

Unfortunately, this is pointless posturing. Who cares that one version of a strip-whitespace
operation is three times faster than another? The important question is whether the speed _matters_.

Until you answer that question, all the benchmarking in the world won't help you, and that brings us
to profiling.

Profiling is a lot harder than benchmarking, which may be why people talk about it less often.
Profiling doesn't compare multiple versions of the same operation, it tells us where the slowest
parts of our code base are.

In order to make profiling useful, we need to write code that simulates typical end user use of the
code we're profiling. Then we run that code under a profiler, and we know what's worth optimizing.

Once we know _that_, then we can start speeding up our code. At this point, benchmarking might be
handy. If, for example, on some crazy bizarro world, our program spent a lot of its runtime trimming
whitespace from strings, we could benchmark different approaches, and use the fastest.

Of course, in the real world, this will _never_ be the slowest thing your program is doing. In most
cases, the slowest parts of the program are usually the parts with IO, such as reading files,
talking to a DBMS, or making network calls. If this isn't the case, we may be operating on a lot of
data in memory with some sort of non-trivial algorithm, and _that's_ the slowest part.

Either way, without profiling, benchmarking is just a pointless distraction.

Of course, I'd be remiss if I didn't point out that Perl has an absolutely fantastic profiler
available these days, [Devel::NYTProf][3]. It actually works (no segfaults!), and produces
fantastically useful reports, so use it.

[1]: http://blog.laufeyjarson.com/2010/03/stripping-whitespace-from-both-ends-of-a-string/
[2]: http://illusori.co.uk/perl/2010/03/03/white_space_trim.html
[3]: http://search.cpan.org/dist/Devel-NYTProf

## Comments

**It's contextual!, on 2010-03-04 20:15, said:**  
It isn't so black and white when you combine them. Sometimes while profiling you end up optimizing
something that will harm you in the long run. For instance, the mozilla project often compiles for
SIZE instead of SPEED because their binary is so large that the benefit of a smaller binary can far
outweigh the optimizations that might cause larger binary sizes. You could profile like mad and
cause the situation to worsen.

Anyways the point is, yes profiling is important but you must be aware of your context (this is not
exciting and makes for dull blog posts).

Context!

**Dave Rolsky, on 2010-03-04 22:06, said:**  
Maybe we can broaden our definition of profiling a bit so that it just means measuring various
statistics, not just speed.

**Sam Graham, on 2010-03-05 03:37, said:**  
Firstly, thanks for the link, secondly, I made just this point in the conclusion of my article:

Always be aware if you're making a trade-off of clarity for performance, and be sure it's worth the
trade-off. If you're looking at a two microsecond saving, you need to be calling it a lot to have
any real impact.

Profiling and benchmarking are flip sides of the same coin, profiling helps you to narrow down to
where optimization would be most useful, benchmarking allows you to easily isolate optimizations and
cross-compare them.

Neither gives the full picture.

**Dave Rolsky, on 2010-03-05 10:16, said:**  
@Sam Graham: My point was that you and Laufrey are wasting time benchmarking whitespace trimming,
since it is impossible to imagine a real program where that particular operation becomes the
bottleneck.

**Sam Graham, on 2010-03-05 13:12, said:**  
Sorry, I'm going to have to call that a failing of your imagination.

Sure, it's the sort of thing that people pretty commonly waste time fiddling with, and you raise a
good point that sometimes people benchmark when they should be profiling, but it's absurd to suggest
that people should always profile instead of benchmark, and that it's impossible that white-space
trimming could ever be a performance issue.

Secondly, and I'm sorry if it wasn't clear in the original article, the white-space trimming merely
provided me with a simple example for a series on benchmarking in general: I was planning to do a
series on profiling, but the white-space example was serendipitous, and benchmarking is more
entry-level as a topic than profiling.

Part two is up at <http://www.illusori.co.uk/perl/2010/03/05/advanced_benchmark_analysis_1.html>.

Part three, which I hope to post in the next few days, shows that in some situations, making the
wrong choice of white-space trim can actually have noticeable performance impact.

My intention is to then move on to profiling, and then do a "linking the pieces together" piece on
optimization overall.

Hopefully your concerns will be addressed by the articles to come.

Please don't pretend you know if I'm wasting my time though, however well-intentioned, I'm more than
capable of making my own decisions in that respect, and am in possession of more facts about the
circumstances I'm looking at than you are. :)

**Dave Rolsky, on 2010-03-05 13:38, said:**  
@Sam:  
If you happen to pick a pathologically slow whitespace trimming algorithm, then your app will
suffer, and you'll see the problem soon enough.

But unless your app is too slow, and unless you've determined that slowness comes from whitespace
trimming, I maintain that you're wasting your time.

**Sam Graham, on 2010-03-06 05:55, said:**  
I wanted to apologise for the tone of my previous post, I should know better than to post when I'm
in a hurry and didn't have time to properly check it, it sounded a lot less aggressive in my head.

I think we broadly agree, and indeed your first point in the comment above is exactly the point I'm
driving at.

_If_ you start with a fairly efficient white-space algorithm, you will in most cases for most
applications gain little from this: if you're spending 1% of your application time trimming
white-space it's going to be a largely fruitless endeavour if you gain a 50% performance increase.

However, if you take that efficient white-space algorithm and replace it with some of the examples
that people, in all honesty, suggested as possible methods to use, you can quite easily cause that
1% to bloat to 10% or more (much more sometimes) for certain types of input. Whether a 10%
performance increase is something to be bothered by is one of those things that entirely depends on
the nature of the application, in some situations you don't care if the software takes 3 times as
long to run as long as it works, in other situations the performance is critical and directly costs
time and money.

Yes, this would possibly raise flags if you were profiling the application, but having the knowledge
to avoid it in the first place is better, and one of the tools to achieve that is to benchmark the
isolated piece of code.

The way I often think of it (and this is a gross simplification of course) is that profiling is what
you do to see what you've done wrong, and benchmarking is what you do to compare your choices -
either to fix what you've done wrong, or to find out preemptively while you're _still writing the
code_ (good luck profiling an application that is only half-written and probably doesn't even
compile yet).

Perhaps it's more accurate to say that profiling lets you see the performance in the context of the
application, while benchmarking lets you isolate it from the context. Which you choose depends on
whether the context helps or hinders the analysis you need to perform, to solve the particular
problem you're trying to investigate.

The other issue you're not addressing is that sometimes only a part of the application is under your
control: if for example you are a module author whose module depends heavily on white-space
trimming, you might only count for 1% of the performance of the application, but the only bits that
you can change (or even know about) is the bits in your module.

You also don't know if someone else is going to use it in a situation where your module _is_ the
bottleneck - people do wild and wacky things out there, sometimes they're even doing it for
reasonable reasons.

Deciding when you should optimize something isn't a topic that has many black or white answers,
there's many shades of grey, rules of thumb and judgement calls to be made on a case-by-case basis.

I'll let you know when I get to that point in my series, I'll be glad for your opinions on the
topic.

**Dave Rolsky, on 2010-03-06 10:00, said:**  
@Sam: I still don't understand what would drive you to benchmark whitespace trimming versus
_anything else_ while you're in the process of writing your app. Do you benchmark every single line
of code as you write it against multiple alternatives?

No, of course you don't. Instead, you have to have some way to decide what's worth benchmarking.

As to not being able to profile a work in progress, I disagree. If you're writing tests you can
always profile your test suite as you go. That will at least give you some clues as to what might be
non-performant in real usage.
