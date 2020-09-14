---
title: Semi-Structured, A Term I Won’t Miss
author: Dave Rolsky
type: post
date: 2010-09-17T11:48:19+00:00
url: /2010/09/17/semi-structured-a-term-i-wont-miss/
categories:
  - Uncategorized

---
The tech field is terribly faddish. Ideas come and go (and come back and go again) with great speed. A few years back people couldn&#8217;t stop babbling on about &#8220;semi-structrted&#8221; data. Thankfully, I haven&#8217;t heard that term in a few years, and I won&#8217;t miss it.

The term always bothered me because there&#8217;s no such thing as semi-structured data. There&#8217;s data that&#8217;s structured in a nice simple way a computer can handle (like a Perl hash or a C struct), and then there&#8217;s data where the structure is so complex that it doesn&#8217;t fit nicely into a simple structure.

This blog post is a perfect example of the latter. It has a very well-defined structure, but that structure is extremely complex. We have paragraphs, sentences, phrases, different parts of each sentence, etc. The text also contains information on things like time (tense), perspective (&#8220;we&#8221;, &#8220;I&#8221;, &#8220;you&#8221;), language, and so on.

Describing text as semi-structured always bothered me, because there&#8217;s nothing &#8220;semi-&#8221; about it. The real distinction is &#8220;things a computer can understand with or without AI&#8221;, and &#8220;semi-&#8221; implies _less_ complexity, rather than more.

So farewell (for now) to &#8220;semi-structured&#8221;, you won&#8217;t be missed.

## Comments

### Comment by Stuart on 2010-09-20 14:28:04 -0500
Funny, I was just reading about the release of Postgres 9 and &#8230;

<a href="http://www.postgresql.org/docs/9.0/static/hstore.html" rel="nofollow ugc">http://www.postgresql.org/docs/9.0/static/hstore.html</a>