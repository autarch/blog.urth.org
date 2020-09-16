---
title: Text::TOC – Reality Versus Theory
author: Dave Rolsky
type: post
date: 2010-05-24T16:07:01+00:00
url: /2010/05/24/texttoc-reality-versus-theory/
---
I released the [first version of Text::TOC][1], so now we can revisit [my earlier design][2] in light of an actual implementation.

From a high level, what's released is pretty similar to what I _thought_ I would release. Here's what I said the high level process looked like:

>   * Process one or more documents for "interesting" nodes.
>   * Assemble all the nodes into a table of contents.
>   * Annotate the source documents with anchors as needed.
>   * Produce a complete table of contents in the specified output format.

This is more or less exactly what the released code does. However, I was also wrong in some cases. I said that "adding anchors and generating a table of contents will also be roles". In fact, this became one role, `Text::TOC::Role::OutputHandler`.

The output handler is responsible for iterating over the nodes that were deemed interesting. It adds anchors to the source document _via the nodes themselves_, which are assumed to somehow connect back to the source document. In the HTML case, I'm using HTML::DOM, so given any node in the document, I can alter the source document in place. At the same time, as it iterates over the nodes, the output handler generates a table of contents.

I still might go back and split these responsibilities up, but for now I wanted to get something released rather than futzing around to find the perfect architecture. Even if I do split them up, the OutputHandler abstraction is useful. In the future an OutputHandler could just delegate to an AnchorInserter and TOCBuilder.

I got some other parts right too. I said ...

> Different types of source documents will produce different types of nodes. For an HTML document, the node contents will probably be a DOM fragment representing the content of a given tag.

That is exactly how the released code works.

I also said that finding "interesting" nodes would be a role. It is, and in the HTML implementation there are sane defaults for single- and multi-document tables of contents.

I planned to have an API for managing the formatting of the TOC, but I punted on that for now. Your current choices are unordered or ordered lists. This is good enough for my needs, and therefore good enough for a first release.

Finally, the shortcut API I proposed was a bit off. I eventually realized that the key decision is whether we're making a single- versus multi-document table of contents. That decision determines what is the sane default for a node filter, and a sane link generation strategy. In the multi-doc case you'll always have to provide your own link generator, since I can't know your URI space.

I also punted entirely on embedding the table of contents in the output document. You can do that yourself for now. The code is on CPAN or in [my mercurial repo][3], so feel free to take a closer look. I hope this will be of use to others as well. I don't know if there will ever be interest in working with non-HTML documents, but even as it is I think it's more useful than the other HTML TOC tools that previously existed on CPAN.

 [1]: http://search.cpan.org/dist/Text-TOC
 [2]: /2010/05/19/tool-design-a-table-of-contents-tool/
 [3]: http://hg.urth.org/hg/Text-TOC