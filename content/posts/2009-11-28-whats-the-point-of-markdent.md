---
title: What’s the Point of Markdent?
author: Dave Rolsky
type: post
date: 2009-11-28T10:40:03+00:00
url: /2009/11/28/whats-the-point-of-markdent/
---
[Markdent][1] is my new event-driven Markdown parser toolkit, but why should you care?

First, let's talk about Markdown. Markdown is yet another wiki-esque format for marking up plain text. What makes Markdown stand out is it's emphasis on usability and "natural" usage. It's syntax is based on things people have been doing to "mark up" plain text email for years.

For example, if you wanted to list some items in a plain text email, you'd wite something like:

<pre class="highlight:false nums:false">* List item 1
* List item 2
* List item 3
</pre>

Well, this is how it works in Markdown too. Want to emphasize some text? _Wrap it in asterisks_ or _underscores_.

So why do you need an event-driven parser toolkit for dealing with Markdown? CPAN already has several modules for dealing with Markdown, most notably [Text::Markdown][2].

The problem with Text::Markdown is that all you can do with it is generate HTML, but there's so much more you could do with a Markdown document.

If you're using Markdown for an application (like a wiki), you may need to generate slightly different HTML for different users. For example, maybe logged-in users see documents differently.

But what if you want to cache parsing in order to speed things up? If you're going straight from Markdown to HTML, you'd need to cache the resulting HTML for each type of user (or even for each individual user in the worst case).

With Markdent, you can cache an intermediate representation of the document as a stream of events. You can then replay this stream back to the HTML generator as needed.

### What's the Impact of Caching?

Here's a benchmark comparing three approaches.

  1. Use Markdent to parse the document and generate HTML from scratch each time.
  2. Use Text::Markdown
  3. Use Markdent to parse the document once, then use Storable to store the event stream. When generating HTML, thaw the event stream and replay it back to the HTML generator.

<table>
  <tr>
    <th>
    </th>
    
    <th>
      Rate
    </th>
    
    <th>
      parse from scratch
    </th>
    
    <th>
      Text::Markdown
    </th>
    
    <th>
      replay from captured events
    </th>
  </tr>
  
  <tr>
    <th>
      parse from scratch
    </th>
    
    <td>
      1.07/s
    </td>
    
    <td>
      -
    </td>
    
    <td>
      -67%
    </td>
    
    <td>
      -83%
    </td>
  </tr>
  
  <tr>
    <th>
      Text::Markdown
    </th>
    
    <td>
      3.22/s
    </td>
    
    <td>
      202%
    </td>
    
    <td>
      -
    </td>
    
    <td>
      -48%
    </td>
  </tr>
  
  <tr>
    <th>
      replay from captured events
    </th>
    
    <td>
      6.13/s
    </td>
    
    <td>
      475%
    </td>
    
    <td>
      91%
    </td>
    
    <td>
      -
    </td>
  </tr>
</table>

This benchmark is [included in the Markdent distro][3]. One feature to note about this benchmark is that it parses 23 documents from the [mdtest test suite][4]. Those documents are mostly pretty short.

If I benchmark just the largest document in mdtest, the numbers change a bit:

<table>
  <tr>
    <th>
    </th>
    
    <th>
      Rate
    </th>
    
    <th>
      parse from scratch
    </th>
    
    <th>
      Text::Markdown
    </th>
    
    <th>
      replay from captured events
    </th>
  </tr>
  
  <tr>
    <th>
      parse from scratch
    </th>
    
    <td>
      2.32/s
    </td>
    
    <td>
      -
    </td>
    
    <td>
      -58%
    </td>
    
    <td>
      -84%
    </td>
  </tr>
  
  <tr>
    <th>
      Text::Markdown
    </th>
    
    <td>
      5.52/s
    </td>
    
    <td>
      138%
    </td>
    
    <td>
      -
    </td>
    
    <td>
      -63%
    </td>
  </tr>
  
  <tr>
    <th>
      replay from captured events
    </th>
    
    <td>
      14.8/s
    </td>
    
    <td>
      538%
    </td>
    
    <td>
      168%
    </td>
    
    <td>
      -
    </td>
  </tr>
</table>

Markdent probably speeds up on large documents because each new parse requires constructing a number of objects. With 23 documents we construct those objects 23 times. When we parse one document the actual speed of parsing becomes more important, as does the speed of _not_ parsing.

### What Else?

But there's more to Markdent than caching. One feature that a lot of wikis have is "backlinks", which is a list of pages linking to the current page. With Markdent, you can write a handler that _only_ looks at links. You can use this to capture all the links and generate your backlink list.

How about a full text search engine? Maybe you'd like to give a little more weight to titles than other text. You can write a handler which collects title text and body text separately, then feed that into your full text search tool.

There's a theme here, which is that Markdent makes document _analysis_ much easier.

That's not all you can do. What about a Markdown-to-Textile converter? How about a Markdown-to-Markdown converter for canonicalization?

Because Markdent is modular and pluggable, if you can think of it, you can probably do it.

I haven't even touched on extending the parser itself. That's still a much rougher area, but it's not that hard. The Markdent distro includes an implementation of a [dialect called "Theory"][5], based on some Markdown extension proposals by David Wheeler.

This dialect is implemented by subclassing the Standard dialect parser classes, and providing some additional event classes to represent table elements.

I hope that other people will pick up on Markdent and write their own dialects and handlers. Imagine a rich ecosystem of tools for Markdown comparable to what's available for XML or HTML. This would make an already useful markup language even more useful.

 [1]: http://search.cpan.org/dist/Markdent
 [2]: http://search.cpan.org/dist/Text-Markdown
 [3]: http://cpansearch.perl.org/src/DROLSKY/Markdent-0.07/bench/capture-vs-parse
 [4]: http://git.michelf.com/mdtest/
 [5]: http://search.cpan.org/dist/Markdent/lib/Markdent/Dialect/Theory.pod

## Comments

**Aristotle Pagaltzis, on 2009-11-29 00:35, said:**  
> With Markdent, you can write a handler that _only_ looks at links.

Would that handler automatically recognise HTML links also, or only Markdown links?

**Dave Rolsky, on 2009-11-29 09:13, said:**  
Aristotle, you could recognize all links pretty easily. For HTML links you'd write something like ...

    if ( $event->isa('Markdent::Event::StartHTMLTag')
         && exists $event->attributes()->{href} ) {
        $self->_add_link( $event->attributes()->{href} );
    }

**Aristotle Pagaltzis, on 2009-11-29 12:42, said:**  
Right. IMO that’s thinking about Markdown at the wrong level (as most people do)… Gruber made it a point not to invent syntax for all possible HTML tags, and to just let it be written as HTML tags. Essentially, Markdown should be thought of as shorthand HTML, wherein you can structurally imply tags using formatting. In that view, to think of `*this*` as different from `<em>this</em>` is mistaken as they are interchangeable equivalents.

IMO the proper decoupled approach to Markdown is for the Markdown parser to offer the same API as an HTML parser of some flavour (be it event-driven, a DOM, or whatever).

What the existing Perl Markdown processors don’t do to my liking, and so I agree that they are not sufficiently decoupled, is that they first convert the whole thing to HTML using successive substitutions, and then you get to feed it to an HTML parser of your choice. It’s slow, it’s cumbersome, and there is merely a high likelihood but no guarantee that the Markdown processor output is going to make sense as HTML, much less be well-formed XHTML.

I suppose it wouldn’t be hard to write such an API as an adapter over Markdent, though.

**Dave Rolsky, on 2009-11-29 12:46, said:**  
Yes, writing a handler that did this in Markent would be pretty easy.

I know what you mean about Gruber's intention, but if I started with that approach I'd be throwing out a lot of information. For example, id-based links vs inline links would end up appearing the same. With Markdent, you can (modulo whitespace and a few niggles) reconstruct the original document, because it preserves all possible information.

Also, I imagine that a \_lot\_ of uses of Markdown are in environments where you absolutely do not want to support inline HTML, so being able to distinguish inline HTML from Markdown is useful.

**Aristotle Pagaltzis, on 2009-11-29 13:44, said:**  
What possible problem can `<em>` cause that `*` can’t? The right way to achieve such restrictions is to whitelist acceptable tags (and attributes) after the conversion. It should not matter what syntax they were written in. This is in keeping with the spirit of Markdown as an HTML shorthand.

**Shlomi Fish, on 2009-12-01 15:15, said:**  
Sounds really cool. Thanks for your work on that. I might take a look.

Lately, I've started using <a href="http://www.methods.co.nz/asciidoc/" rel="nofollow">AsciiDoc</a> which is similar-in-spirit to Markdown, but probably more powerful and can also generate DocBook/XML, for some documents, and it's been a mostly pleasant experience. AsciiDoc only has a Python implementation so far, and I don't know how well it can be used as an events-streamer.

**Dan Dascalescu, MojoMojo contributor, on 2009-12-02 00:08, said:**  
This sounds almost like built **for** <a href="http://mojomojo.org" rel="nofollow">MojoMojo</a>!