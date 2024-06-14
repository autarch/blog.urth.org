---
title: Giving Good Talk
author: Dave Rolsky
type: post
date: 2009-02-09T10:44:47+00:00
url: /2009/02/09/giving-good-talk/
---

I was at [Frozen Perl][1] this last weekend, and listening to some of the speakers inspired me to
write about giving a good tech talk. I also speak at a lot of conferences, and these are tips I (try
to) follow for my own talks. If you've seen me speak and think I did a good job, then these tips may
be valuable to you. If you think I did a bad job, you can stop reading now.

I'm writing about a specific type of talk here. Most tech talks fall into the category of "here's a
thing you should know about". That thing might be a project or tool (Moose, Perl 6, Catalyst), or
maybe a technique or concept (how to reduce memory usage, unit testing). Typically these talks run
between 20 and 50 minutes. If you are doing a tutorial, this advice is not for you, because a
tutorial is a different beast.

My number one piece of advice is to **give an overview**! Speakers often fall into the trap of
telling people way too much. Short talks (as opposed to classes or tutorials) are a really shitty
way to _teach_ something, but they're a great way to _introduce_ something. Your goal is to provide
attendees with information that lets them decide whether they want to learn more.

A few more pieces of unsolicited advice:

- Introduce the project or concept. "Unit testing is about writing automated tests for each piece of
  your system, in isolation." It's funny how some folks forget that their audience may know nothing
  about the topic.
- As a corrolary, make sure you define (potentially) new concepts clearly - "By automated, I mean
  the tests themselves are programs, and can be run with a single command. You could run them from
  cron and report any failures via email."
- Tell people what problems this thing solves. "Unit testing makes it easier to refactor existing
  code with confidence."
- Also tell them what problems it _doesn't_ solve. "Unit testing alone will not ensure that your
  code meets user requirements."
- Show some _some_ details, and allude to the rest. "Here is an example of Test::More from CPAN. You
  can see the use of the ok() and is() functions. (explain those two). There are many more functions
  in Test::More, and many more useful test modules on CPAN such as Test::Exception and
  Test::Output."
- **Do not go into detail on every little option and feature.** This seems to be an easy trap to
  fall into. Don't do it. It's incredibly boring, and you'll never finish explaining everything in
  the time you have available.
- Time yourself! So many speakers get through half their slides, or get through all of them in half
  their time and then look dumbfounded. You don't need a stopwatch, just look at the clock. If
  you've presented a couple times, you may notice that you tend to have an average time per slide.
  I've noticed that my own time is approximately 1 minute per slide.

Have your own advice? Write a comment or your own blog entry.

[1]: http://www.frozen-perl.org/

## Comments

**Nery, on 2009-02-16 00:00, said:**  
Thanks for the information.

I think that you're very accurate when you say that a Talk is a very good way to introduce
something.

Cheers

**Adam Kennedy, on 2009-07-25 12:03, said:**

> I've noticed that my own time is approximately 1 minute per slide.

13 seconds for me :)
