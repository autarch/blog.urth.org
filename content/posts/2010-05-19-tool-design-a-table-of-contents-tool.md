---
title: Tool Design – a Table of Contents Tool
author: Dave Rolsky
type: post
date: 2010-05-19T12:21:57+00:00
url: /2010/05/19/tool-design-a-table-of-contents-tool/
categories:
  - Uncategorized

---
A while ago, I wrote an entry on the idea of [breaking problems down][1] as a strategy for building good tools.

Today, I started writing a new module, `Text::TOC`. The goal is to create a tool for generating a table of contents from one or more documents. I&#8217;m going to write up my initial design thoughts as a &#8220;how-to&#8221; on problem break down.

First, a little background. I&#8217;ve already looked at some relevant modules on CPAN. Both [HTML::Toc][2] and [HTML::GenToc][3] have awkward and/or insufficiently powerful APIs. Their internals are also nothing to write home about, so I ruled out patching them. At a certain point, I just can&#8217;t stomach wading through a bad design, even if that might get me to my goal quicker.

I started this project wanting to generate a table of contents for an HTML document, but I quickly realized that with a little extra work, I could make a table of contents tool that worked for different document formats. A table of contents is a pretty generic concept, so there&#8217;s no reason not to generalize it.

The ultimate product will also include a shortcut module to facilitate extremely common cases for HTML documents.

Producing a set of low-level components, and then tying them together in convenience modules makes for very good tools. With this approach, if I can build one convenience module, I can build five. Just as importantly, it will also be possible to handle more complicated cases. I believe in following the Perl spirit of making simple tasks simple, and complicated tasks possible. Too many CPAN modules solve one specific problem case at the expense of locking the code into a single-use API.

### Roles Rock

I started by thinking about the process that goes into generating a table of contents:

  * Process one or more documents for &#8220;interesting&#8221; nodes.
  * Assemble all the nodes into a table of contents.
  * Annotate the source documents with anchors as needed.
  * Produce a complete table of contents in the specified output format.

This is all very generic. What kind of nodes? What makes a node interesting? What do anchors look like? What does the table of contents look like for a given format?

This project will make extensive use of roles in its API, and this list of steps gives me a good idea of what those roles will be. I&#8217;ll create a role for nodes. There will also roles for input and output handling. Anything that does input processing will also do input filtering to find &#8220;interesting&#8221; nodes. This filtering is also a role.

Finally, adding anchors and generating a table of contents will also be roles.

You&#8217;ll notice that I haven&#8217;t talked about anchor names. For now, I&#8217;m going to hardcode an algorithm to generate these based on combining the anchor&#8217;s display text with a unique id. There&#8217;s no need to solve every problem up front. Patches will be always be welcome.

### What is a Table of Contents?

For this project, I&#8217;m going to represent the table of contents as a list of nodes. Each node will consist of a type (&#8220;h2&#8221;, &#8220;h3&#8221;, &#8220;image&#8221;), a link, and the node&#8217;s contents.

Different types of source documents will produce different types of nodes. For an HTML document, the node contents will probably be a DOM fragment representing the content of a given tag.

This is a very minimal representation. I want to avoid encoding things like a &#8220;level&#8221; in the node list itself. Instead, I&#8217;ll defer decisions on how to handle this to the output generation stage. This will make it easier to produce different table styles. Of course, there will be a default which handles common node types (heading) in a sane way.

### Input Handling

Concrete input handlers will take a document in a given format and find the interesting nodes in that document. As I mentioned earlier, finding &#8220;interesting&#8221; nodes will be a role. However, since this is something that people will often want to tweak, I want to make sure that providing a custom filter is as easy as possible.

Instead of requiring that people instantiate a concrete class which implements the filtering role, I will define a type coercion from a code reference to an object. Callers of the module can provide a simple code reference as a filter:

<pre class="lang:perl">sub {
    my $node = shift;
       return 0 if $node->className() =~ /\bskip-toc\b/;
       return 1 if $node->tagName() =~ /H[2-5]/ || $node->tagName() eq 'IMG';
       return 0;
}
</pre>

Internally, we&#8217;ll take the code reference and wrap it with an object which implements the filter role&#8217;s API.

### Output Handling

There are two distinct output tasks. First, we need to annotate an existing document with anchors, so that the we have something to which we can link the table of contents.

Second, we need to produce the table of contents itself.

It&#8217;s tempting to create a single interface that does both, because these tasks both depend on the output format. However, there&#8217;s a lot of variation in the way a table of contents can be represented, so I think these will be two separate interfaces.

Another important part of the output interface is the formatting of links in the table of contents, and this will have its own API.

This makes things a little more complicated, but the shortcut modules can gloss over the details in most cases.

### The Shortcut API

Now that I have a handle on the low-level components, I want to consider the shortcut API. The shortcut API needs to expose _some_ implementation detail, but not all of it. Understanding what&#8217;s most important for users helps me in turn understand exactly how to break down the low-level pieces.

I&#8217;m going to assume that _most_ users of this module will be inputting and outputting the same format, so we&#8217;ll have a single API setting for the format. I&#8217;ll simply encode this in the class name, since the choice of format decides many of the low-level classes.

The shortcut API should support generating a table of contents for either a single document or multiple documents. This affects the generation of links for the table. We also want to support embedding the table in the generated document, at least for the single document case.

Finally, we can offer a few different styles of output for the table of contents. Two obvious choices which come to mind are unordered versus ordered lists.

Given all that, our API might look something like this:

<pre class="lang:perl">my $generator = Text::TOC::HTML->new(
    filter         => 'single-document',
    link_generator => undef,
    style          => 'unordered-list',
);

$generator->add_file($path_to_html);
$generator->embed_table_of_contents();

for my $file ( $generator->files() ) {
    open my $fh, '>', $file;
    print {$fh} $generator->document_for_file($file);
}
</pre>

The &#8220;single-document&#8221; filter will find second- through fourth-level headings. My assumption is that a single document only has one <h1> tag, which is the document&#8217;s title. There&#8217;s no reason to put this in the table of contents.

If we were generating a table of contents for multiple documents, we _would_ want to include the first-level heading, necessitating a different filter.

Since we&#8217;re only linking within a single document, we don&#8217;t need to do anything intelligent with the links, we can just use the anchor name directly.

For a multi-document table, I&#8217;ll need a code reference that does something smart based on the file name. I&#8217;m not sure it&#8217;s worthwhile trying to provide a shortcut for this part of the API, since there may not be any common patterns here. Every application has it&#8217;s own URI patterns.

Instead, I&#8217;ll probably just take a code reference:

<pre class="lang:perl">my $link_gen = sub {
    my $file   = shift;
    my $anchor = shift;
    return 'file://' . $file->absolute() . '/#' . $anchor->name();
};

my $generator = Text::TOC::HTML->new(
    filter         => 'multi-document',
    link_generator => $link_gen,
    style          => 'unordered-list',
);

$generator->add_file($_) for @files;

for my $file ( $generator->files() ) {
    open my $fh, '>', $file;
    print {$fh} $generator->document_for_file($file);
}
</pre>

This shortcut API isn&#8217;t set in stone, but it&#8217;s a good start for something useful, and it gives me some good clues about the low-level API.

### Writing the Code

Writing this blog entry has been a good way to clarify how this tool should work. Stay tuned for a release of [Text::TOC][4] to a CPAN mirror near you.

We&#8217;ll see how much of the design survives the fires of implementation.

 [1]: /2009/11/27/want-good-tools-break-your-problems-down/
 [2]: http://search.cpan.org/dist/HTML-Toc
 [3]: http://search.cpan.org/dist/HTML-GenToc
 [4]: http://hg.urth.org/hg/Text-TOC

## Comments

### Comment by Zbigniew Lukasiak on 2010-05-23 04:30:31 -0500
I wish this kind of deliberation in the public was more common in the Perl community. It is not easy, and there is danger that someone will walk away with a &#8220;you just don&#8217;t get it&#8221;, but the more we do it the better we will be in it. I am trying to do the same with my modules.