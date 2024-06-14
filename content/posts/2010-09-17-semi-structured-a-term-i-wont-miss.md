---
title: Semi-Structured, A Term I Won’t Miss
author: Dave Rolsky
type: post
date: 2010-09-17T11:48:19+00:00
url: /2010/09/17/semi-structured-a-term-i-wont-miss/
---

The tech field is terribly faddish. Ideas come and go (and come back and go again) with great speed.
A few years back people couldn't stop babbling on about "semi-structrted" data. Thankfully, I
haven't heard that term in a few years, and I won't miss it.

The term always bothered me because there's no such thing as semi-structured data. There's data
that's structured in a nice simple way a computer can handle (like a Perl hash or a C struct), and
then there's data where the structure is so complex that it doesn't fit nicely into a simple
structure.

This blog post is a perfect example of the latter. It has a very well-defined structure, but that
structure is extremely complex. We have paragraphs, sentences, phrases, different parts of each
sentence, etc. The text also contains information on things like time (tense), perspective ("we",
"I", "you"), language, and so on.

Describing text as semi-structured always bothered me, because there's nothing "semi-" about it. The
real distinction is "things a computer can understand with or without AI", and "semi-" implies
_less_ complexity, rather than more.

So farewell (for now) to "semi-structured", you won't be missed.

## Comments

**Stuart, on 2010-09-20 14:28, said:**  
Funny, I was just reading about the release of Postgres 9 and ...

<http://www.postgresql.org/docs/9.0/static/hstore.html>
