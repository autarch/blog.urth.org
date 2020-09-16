---
title: She Said What?!
author: Dave Rolsky
type: post
date: 2009-08-10T15:51:18+00:00
url: /2009/08/10/i-created-a-new-website/
---
I created a new website as a fun little personal project, [She Said What?!][1]

It was a fun experiment both in minimal web design, and also in minimal code. I can update it from the command line just by typing:

<pre class="highlight:false">ssw 'A quote goes here|and commentary goes here'
</pre>

This adds a quote to the quote "database", which is just a directory of timestamped flat files on my desktop. Then it regenerates the site as static HTML and pushes it to the live server.

The code is in [my mercurial repository][2] for anyone who might care.

 [1]: http://shesaidwh.at/
 [2]: http://hg.urth.org/hg/she-said-what