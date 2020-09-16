---
title: Want Good Tools? Break Your Problems Down
author: Dave Rolsky
type: post
date: 2009-11-27T15:12:19+00:00
url: /2009/11/27/want-good-tools-break-your-problems-down/
---
I've been working a new a project recently, [Markdent][1], an event-driven Markdown parser toolkit.

Why? Because the existing Perl Markdown tools just aren't flexible enough. They bundle up Markdown parsing with HTML conversion all in one API, and I need to do more than convert to HTML.

This sort of inflexibility is quite common when I look at CPAN libraries. Looking back at the Perl DateTime Project, one of my big problems with all the other date/time modules on CPAN was their lack of flexibility. If I could have added good time zone handling to an existing project way back then, I probably would have, but I couldn't, and the [Perl DateTime Project][2] was born.

If there is one point I would hammer home to all module authors, it would be "solve small problems". I think that the failure to do this is what leads to the inflexibility and tight coupling I see in so many CPAN distributions.

For example, I imagine that in the date/time world some people thought "I need a bunch of date math functions" or "I need to parse lots of possible date/time strings". Those are good problems to solve, but by going straight there you lose any hope of a good API.

Similarly, with Markdown parsers, I imagine that someone though "I'd like to convert Markdown to HTML", so they wrote a module that does just that.

I can't really fault their goal-focused attitudes. Personally, I sometimes find myself getting lost in digressions. For example, I'm currently writing a webapp with the goal of exploring techniques I want to use in _another_ webapp!

But there's a lot to be said for not going straight to your goal. I'm a big fan of breaking a problem down into smaller pieces and solving each piece separately.

For example, when it comes to Markdown, there are several distinct steps on the way from Markdown to HTML. First, we need to be able to parse Markdown. Parsing Markdown is a step of its own. _Then_ we need to take the results of parsing and turn it into HTML.

If we think of the problem as consisting of these pieces, a clear and flexible design emerges. We need a tool for parsing Markdown (a parser). Separately, we need a tool for converting parse results to HTML (a converter or parse result handler).

Now we need a way to connect these pieces. In the case of Markdent, the connection is an event-driven API where each event is an object and the event receiver conforms to a known API.

It's easy to put these two things together and make a nice [simple Markdown-to-HTML converter][3].

But since I took the time to break the problem down, you can _also_ do other things with this tool. For example, I can do something else with our parse results, like capture all the links or cache the intermediate result of the parsing (an event stream).

And since the HTML generator is a small piece, I can also reuse that. Now that I've cached our event stream, I can pull it from the cache later and use it to generate HTML without re-parsing the document. In the case of Markdent, using a cached parse result to generate HTML was about six times faster in my benchmarks!

Because Markdent has small pieces, there are all sorts of interesting ways to reuse them. How about a Markdown-to-Textile converter? Or how about adding a [filter][4] which [doesn't allow any raw HTML][5]?

We've all heard that loose coupling makes good APIs. But just saying that doesn't really help you understand how to achieve loose coupling. Loose coupling comes from breaking a big problem down into small independent problems.

As you solve each problem, think about how those solutions will communicate. Design a simple API or communications protocol. You'll know the API is simple enough if you can imagine _easily_ swapping out each piece of the problem with another API-conformant piece. A loosely coupled API is one that makes replacing one end of the API easy.

And best of all, when you break problems down into loosely coupled pieces, you'll make it _much_ easier for others to contribute to and extend your tools. Moose is a great example of this. It's fancy sugar layer exists on top of loosely coupled units known as the metaclass protocol. By separating the sugar from the underlying pieces, we've enabled others to create a [huge number of Moose extensions][6].

The same goes for the Perl DateTime Project. I wrote the core pieces, but there have been [many, many great contributions][7]. This wealth of extensions wouldn't be possible without the loosely coupled core pieces and a [well-defined API][8] for communicating between components.

 [1]: http://search.cpan.org/dist/Markdent
 [2]: http://datetime.perl.org
 [3]: http://search.cpan.org/dist/Markdent/lib/Markdent/Simple.pm
 [4]: http://search.cpan.org/dist/Markdent/lib/Markdent/Role/FilterHandler.pm
 [5]: http://search.cpan.org/dist/Markdent/lib/Markdent/Handler/HTMLFilter.pm
 [6]: http://search.cpan.org/search?query=moosex&mode=dist
 [7]: http://search.cpan.org/search?query=datetime&mode=dist
 [8]: http://datetime.perl.org/?Developers

## Comments

**Zbigniew Lukasiak, on 2009-11-28 05:41, said:**  
On a bigger scale I like to view CPAN as this kind of 'small pieces loosely joined' attitude. Nothingmuch also had a few interesting points in this subject: <http://blog.woobling.org/2009/07/reducing-scope.html>

**xilun, on 2009-11-29 18:19, said:**  
Not only this is a good design, this is indeed a classic design, and even a must for people dealing with compilers (format conversion is similar to a simple compilation). I encourage people to read the dragon book.

**zby, on 2012-04-08 16:38, said:**  
Or even simpler would be a functional API - just one exported function markup\_to\_html.