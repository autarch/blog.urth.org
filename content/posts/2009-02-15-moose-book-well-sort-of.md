---
title: Moose Book? Well, Sort Of …
author: Dave Rolsky
type: post
date: 2009-02-15T12:20:38+00:00
url: /2009/02/15/moose-book-well-sort-of/
categories:
  - Uncategorized

---
Occasionally, someone will pop up and say that Moose really needs a book. &#8220;X looks good, but it needs a book before I can learn it&#8221; is a common meme among programmers.

This is crazy, of course. Demanding a book before you learn something means you&#8217;ll never learn a _lot_ of things. Book publishing is a risky proposition for many topics, and with the surfeit of good documentation on the net, it&#8217;s getting harder and harder to justify a book for any given topic. Even for books that aren&#8217;t failures, writing a book is not a good way for an author to make money.

I put a ridiculous amount of time into the [Mason book][1], and my estimate is that I made $20 per hour (maybe less). Of course, having a book looks great on my resume, but the direct payoff is low. At this point in my career, it&#8217;d be hard to justify the effort required to produce another niche book, even assuming there was a publisher.

But the real point of this entry is to highlight just how much free documentation Moose has. A commenter on a previous post mentioned that he or she had created [PDF output of the entire Moose manual][2]. There are two versions at the link with different formatting, the shorter of which is about 58 pages. This is _just_ the manual, not the cookbook. I imagine if the cookbook got the same treatment, we&#8217;d easily have 100+ pages of documentation. That doesn&#8217;t include the API docs, this is all stuff that might go in a book (concepts, recommendation, examples, recipes).

So please stop asking for a Moose book, and just read the one that already exists!

 [1]: http://www.masonbook.com
 [2]: http://babyl.dyndns.org/techblog/manuals/

## Comments

### Comment by chromatic on 2009-02-15 15:52:45 -0600
Please note that the ridiculously low hourly wage for authors is, in large part, due to the ridiculously broken compensation model of most publishers. A book that sells for $40 may earn the author $2 for each copy sold and the publisher $14.

Do publishers really contribute seven times as much value to the book as writers?

### Comment by Dave Rolsky on 2009-02-15 16:13:27 -0600
Publishers do contribute some value. A lot of it is having a process in place for getting a book from idea to market. That&#8217;s less valuable these days than it used to be, with print on-demand.

Anything a publisher can do, I can do on my own, but I&#8217;d have to front the costs (pay my own editor, pay for marketing, etc).

But is that worth 7x? Probably not. I suppose if someone were to offer me a deal where I got $10 per book sold, I&#8217;d consider writing another book ;)

### Comment by james on 2009-02-15 18:00:21 -0600
Perhaps you should get those PDFs up on some on-demand book publisher (even CafePress does that these days).

### Comment by Dave Rolsky on 2009-02-15 18:39:56 -0600
I think it&#8217;d be better to simply make generating nice PDFs part of the release process, so we could put them in the tarball and up on <a href="http://moose.perl.org" rel="nofollow ugc">http://moose.perl.org</a>

That way people can print them out if they want, but the online version stays up to date.

### Comment by chromatic on 2009-02-15 19:15:04 -0600
$10 per book is possible for a book with a cover price of $50. Any publisher who won&#8217;t pay you royalties of 20-25% of the cover price is cheating you.

The standard rate is 5% of the cover price.

### Comment by yanick.myopenid.com on 2009-02-15 19:55:59 -0600
Glad that you liked the pdf rendition of the manual. :-)

_Re: Manual + Cookbook._ As a first pass, I only included the Manual::*  
sections, but nothing precludes me of adding the cookbook pods in the next  
edition. Or anyone else, for what matters: the recipe is now <a href="http://github.com/yanick/pod-manual/blob/d6be8bddb9e1e085a569a97b01daee44015b9d7a/examples/moose.pl" rel="nofollow">available on Github</a>.

_Re: making manual creation a part of the distribution process._ Ah, you  
anticipated my true end-goal. :-) Pod::Manual is still a very young and rough  
module, but once it matures a little bit, I have evil plans involving hacking  
support for it into Module::Build and co so that a fresh pdf version of the  
docs will never further than a &#8216;./Build manual&#8217; away.

### Comment by jdavidb/skiphoppy on 2009-02-18 10:39:35 -0600
For the record, the primary reason for my very simple Moose question on stackoverflow was to increase visibility for Perl and Moose&#8230; ;)

### Comment by Wolfgang on 2009-08-08 03:56:26 -0500
I like the automation idea and I want a book(-let)!  
I&#8217;m even willing to work for it :-)

I checked the LaTeX/pdf version. It&#8217;s a very good starting point.

Dave, would you mind if I dropped the duplicate parts (AUTHOR, Copyright, &#8230;) and reduce this to just one occurrence ?

I also would like to introduce more links into the pdf and I simply love a good index.

The last two ideas would make it necessary to **change the sources** of the documentation, which I could prepare but Dave would have to **redistribute** the new versions afterwards.

Is that acceptable?

Wolfgang