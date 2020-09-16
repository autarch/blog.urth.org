---
title: TDD != Unit Testing
author: Dave Rolsky
type: post
date: 2009-02-09T11:28:19+00:00
url: /2009/02/09/tdd-unit-testing/
---
I've just recently noticed people conflating Test-Driven Development (TDD) with unit testing. Why? I'm guessing this happens because folks with the TDD bug evangelise their particular approach to testing, and they're the loudest. See this [silly blog post][1] and the comments (particularly Giles Bowkett). Also see [this blog post by Michael Feathers][2].

I first noticed this conflation in an IRC conversation where someone asked how to pitch unit testing to colleagues. He seemed to think this meant pitching TDD as well. The colleagues were balking as much at TDD as at unit testing, and I suggested separating the two in the pitch.

I caught the testing bug many years ago, and I try to make sure that all the new work I do is well-tested. I introduced unit testing at my previous two jobs, and it helped improve our software quite a bit. I've never really done TDD, and I don't plan to any time soon.

When I'm starting _new_ code, I like to noodle around and explore. Sometimes I sketch out APIs for the whole system, sometimes I just pick a particular chunk and go for it. Once I've have something solid, I start writing unit tests. This tends to go back and forth over the course of a project. I write a new class, write some tests, write some classes, write some tests, improve an existing class, write some tests.

Invariably, the tests are written to test the code I've just written. The only time I follow TDD is for bugs. When someone reports a bug I write a _failing_ test first, then fix the bug. This is a good discipline, since it ensures that I understand the bug, and that I'm actually fixing it when I make a change.

I don't have any problem with TDD if that's your thing. The important thing as that at the end of the day you have good tests with high coverage. You also need a test for every new bug. As long as those things happen, the order is irrelevant.

I think the conflation of unit testing and TDD is unfortunate. If you're like me, a noodler, you may reject TDD out of hand because your brain doesn't work that way. But if that causes you to also reject unit testing, it's a big loss.

 [1]: http://abstractstuff.livejournal.com/60388.html
 [2]: http://michaelfeathers.typepad.com/michael_feathers_blog/2008/06/the-flawed-theo.html

## Comments

**Mutant, on 2009-02-10 03:41, said:**  
Well put. I really don't like the whole "you must do TDD or your quality will be terrible!" meme. I test first when it suits, and code first when it suits. I always make sure I write \*testable\* code, but that doesn't mean the tests are written first. They are always written soon after though.