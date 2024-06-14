---
title: How to Debug a Heisenfailure in Your Tests
author: Dave Rolsky
type: post
date: 2015-01-21T22:38:47+00:00
url: /2015/01/21/how-to-debug-a-heisenfailure-in-your-tests/
---

Assuming that the failure happens more than once every few thousand test runs, here's a handy shell
snippet:

    while prove -bv t/MaxMind/DB/Writer/Tree-freeze-thaw.t ; do reset; done

This will run the relevant test in a loop over and over, stopping at the first failure. The reset in
between each run makes it easy to hit Ctrl-Up in the terminal and go to the beginning of the test
run that failed, rather than having a monster scrollback buffer.
