---
title: Rules of Optimization
author: Dave Rolsky
type: post
date: 2012-04-25T13:18:55+00:00
url: /2012/04/25/rules-of-optimization/
---

For that coworker who won't stop "optimizing" his or her code, I give you my rules of optimization:

1. Don't optimize
2. Don't optimize, I'm serious
3. Don't optimize without benchmarking first
4. Don't benchmark without profiling first
5. See rule #1

Edit: A co-worker suggested a step 4.5 of "Take a coffee break". I don't like coffee, but I like the
spirit of the suggestion.

## Comments

**Chas. Owens, on 2012-04-26 07:43, said:**  
Shouldn't profiling be before benchmarking? If a chunk of code isn't used a lot, speeding it up
generally won't make a bit of difference.

**Dave Rolsky, on 2012-04-26 09:36, said:**  
The rules are meant to be read completely before being applied, rather than being applied before
reading the next one.
