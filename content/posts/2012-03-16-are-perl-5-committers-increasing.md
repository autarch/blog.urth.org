---
title: Are Perl 5 Committers Increasing?
author: Dave Rolsky
type: post
date: 2012-03-16T20:27:22+00:00
url: /2012/03/16/are-perl-5-committers-increasing/
categories:
  - Uncategorized

---
I feel that Perl 5 activity has increased over the past few years, but is that an illusion? I brought this topic up on the #p5p IRC channel and Nicholas Clark said, &#8220;everyone assumes growth. If you look at the &#8216;committers&#8217; graph on <https://www.ohloh.net/p/perl/analyses/latest> I don&#8217;t think there&#8217;s been any marked growth (or reduction) in the past 10 years. Just a lot of noise&#8221;.

So is he right? I wanted to figure it out.

The Ohloh chart is very noisy. It shows the number of committers _per month_, which seems to swing back and forth rather dramatically. I used the Ohloh API to download the raw data and run it through a spreadsheet.

Instead of looking at each month, I looked at the average number of committers _per year_. I started with 2001, since before that year the data is even more wildly variable. Also, I know that the farther we go back in the commit history, the more guesses were made during the import to git.

Here&#8217;s the graph I created in Gnumeric:

![45-perl-commiters-per-year.png][1] 

It _looks_ like there was a big dropoff in committers from 2001 to 2004, and we&#8217;ve seen an upwards trend since then. I&#8217;m not sure there&#8217;s enough data to draw any strong conclusions. My gut feeling that activity was up in the past few years was correct, but we don&#8217;t yet know whether that&#8217;s a fluke.

We still haven&#8217;t reached our historical highs, so I think Nick was right when you look at the overall history of Perl 5. Nevertheless, I&#8217;m hopeful that we&#8217;re in the midst of a positive trend.

 [1]: /files/import/45-perl-commiters-per-year.png

## Comments

### Comment by Christian Walde on 2012-03-17 10:21:58 -0500
Could you generate the graph with the impact of each committer weighted by the amount of their commits?

### Comment by Dave Rolsky on 2012-03-17 10:41:26 -0500
@Christian: Ohloh doesn&#8217;t provide that sort of data.

Someone would have to write some code to look at each git commit and record those stats. It sounds interesting, but I probably won&#8217;t do it myself.

### Comment by Caleb Cushing ( xenoterracide ) on 2012-03-18 15:26:21 -0500
I hope so, but perl really needs to do something interesting in core in the next year. The vastly improved unicode is great, and so is some of the performance improvements I&#8217;ve read about. But PHP has traits now&#8230; people need to figure out how to get things moving forward in core in ways that are more big and exciting, and potentially also reduce gobs of boilerplate. I don&#8217;t see a big splash announcement coming for 5.16, hopefully we can get one for 5.18. class, method, and role would all be things that I thing would move things forward. Maybe if we tried really hard we could slowly turn perl 5 into perl 6 (just sayin&#8217;)