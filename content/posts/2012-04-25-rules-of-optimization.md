---
title: Rules of Optimization
author: Dave Rolsky
type: post
date: 2012-04-25T13:18:55+00:00
url: /2012/04/25/rules-of-optimization/
categories:
  - Uncategorized

---
For that coworker who won&#8217;t stop &#8220;optimizing&#8221; his or her code, I give you my rules of optimization:

  1. Don&#8217;t optimize
  2. Don&#8217;t optimize, I&#8217;m serious
  3. Don&#8217;t optimize without benchmarking first
  4. Don&#8217;t benchmark without profiling first
  5. See rule #1

Edit: A co-worker suggested a step 4.5 of &#8220;Take a coffee break&#8221;. I don&#8217;t like coffee, but I like the spirit of the suggestion.

## Comments

### Comment by Chas. Owens on 2012-04-26 07:43:23 -0500
Shouldn&#8217;t profiling be before benchmarking? If a chunk of code isn&#8217;t used a lot, speeding it up generally won&#8217;t make a bit of difference.

### Comment by Dave Rolsky on 2012-04-26 09:36:49 -0500
The rules are meant to be read completely before being applied, rather than being applied before reading the next one.