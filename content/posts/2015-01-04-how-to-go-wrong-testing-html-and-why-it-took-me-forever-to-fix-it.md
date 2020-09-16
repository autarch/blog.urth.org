---
title: How to Go Wrong Testing HTML and Why It Took Me Forever to Fix It
author: Dave Rolsky
type: post
date: 2015-01-04T20:33:04+00:00
url: /2015/01/04/how-to-go-wrong-testing-html-and-why-it-took-me-forever-to-fix-it/
---
About a million years ago (ok, more like 6 months) a kind soul by the name of Polina Shubina [reported a small bug][1] in my `Markdent` module. She was even kind enough to submit a PR that fixed the issue, which was that the HTML generated for Markdown tables (via a Markdown extension) always used `</th>` to close table cells.

However, there was one problem, there was no test for the bug. I really hate merging a bug fix without a regression test. I know myself well enough to know that without a test the chances of me reintroducing the bug again later are pretty good.

Even more oddly, I thought for sure that this was already tested. `Markdent` is a tool for parsing Markdown, and includes some libraries for turning that Markdown into HTML. I knew that I tested the table parsing, and I didn't think I was quite dumb enough to hand-write some HTML where I used `</th>` to close all the table cells.

I was correct. This was tested, and the expected HTML in the test was correct too. So what was going on?

It turned out that this problem went way back to when I first wrote the module. Comparing two chunks of HTML and determining if they're the same isn't a trivial task. HTML is notoriously flexible, and a simple string comparison just won't cut it. Minor differences in whitespace between two pieces of HTML are (mostly) ignorable, tag attribute order is irrelevant, and so on.

I looked on CPAN for a good HTML diffing module and found squat. Then I remembered the HTML Tidy tool. I could run the two pieces of HTML I wanted to compare through Tidy and then compare the result. Tidy does a good job of forcing the HTML into a repeatable format.

Unfortunately, Tidy is a little **too** good. It turns out that Tidy did a really good job of fixing up broken tags! It turned my `</th>` into `</td>`, so my tests passed even when they shouldn't. Using Tidy to test my HTML output turned out to be a really bad idea, since I wasn't really testing the HTML my code generated.

This left me looking for an HTML diff tool again. I really couldn't find much in the way of CLI tools on the Interwebs. CPAN has two modules which sort of work. There's [`HTML::Diff`][2], which uses regexes to parse the HTML. I didn't even bother trying it, to be honest. (BTW, don't blame Neil Bowers for this code, he's just doing some light maintenance on it, he didn't create it).

Then there's [`Test::HTML::Differences`][3]. This uses [`HTML::Parser`][4], at least. Unfortunately, it tries a little too hard to normalize HTML, and it got seriously confused by much of the HTML in the mdtest Markdown test suite.

I also tried using the W3C validator to somehow compare errors between two docs. I ended up adding some validation tests to the `Markdent` test suite, which is useful, but it still didn't help me come up with a useful diff between two chunks of HTML.

I finally gave up and wrote my own tool, [HTML::Differences][5]. It turned out to be remarkably simple to get something that worked well enough to test `Markdent`, at least. I used `HTML::TokeParser` to turn the HTML into a list of events, and then normalized whitespace in text events (except when inside a `<pre>` tag).

Getting to this point took a while, especially since I was doing all of this in my free time. And that's the story of why it took me six months to fix an incredibly trivial bug, and how testing HTML is trickier than I understood when I first started testing it with `Markdent`.

 [1]: https://github.com/autarch/Markdent/pull/2
 [2]: https://metacpan.org/release/HTML-Diff
 [3]: https://metacpan.org/release/Test-HTML-Differences
 [4]: https://metacpan.org/pod/HTML::Parser
 [5]: https://metacpan.org/release/DROLSKY/HTML-Differences-0.01

## Comments

**Andy Lester, on 2015-01-05 08:25, said:**  
If you like Tidy, you can use HTML::Tidy to analyze the HTML and get the errors back, but without tidy fixing them.

**Nathan Glenn, on 2015-01-05 21:38, said:**  
This is one of those things that's been needing done for many years. Thank you!  
Another similarly broken-but-important module is Test::XML.