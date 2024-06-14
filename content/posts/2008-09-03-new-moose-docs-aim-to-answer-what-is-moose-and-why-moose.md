---
title: New Moose Docs Aim to Answer “What is Moose?” and “Why Moose?”
author: Dave Rolsky
type: post
date: 2008-09-03T17:34:51+00:00
url: /2008/09/03/new-moose-docs-aim-to-answer-what-is-moose-and-why-moose/
---

Not so long ago I joined the Moose core team, and I recently shepherded a rather big Class::MOP
(0.65) and Moose (0.56) release.

Soon after there was an [interesting thread on the Perl AppEngine list asking Why Moose][1]. This is
a perfectly good question.

I realized that when you look at the Moose docs, it doesn't really explain how it is conceptually
different from any other Perl 5 OO helper module, nor does it really do much to show you exactly how
Moose saves you work.

In the latest release, 0.57, I've written some new documentation that aims to answer some of these
questions.

First up we have [Moose::Intro][2].

This document aims to explain what Moose is, why it's better than the existing body of Perl 5 OO,
and introduces each Moose concept with definitions and comparisons to existing practice. The
intended audience is folks familiar with Perl 5 OO who haven't been exposed to more advanced OO
concepts like meta-object protocols (ala Common Lisp Object System).

Second is [Moose::Unsweetened][3].

This takes a couple small class examples, and shows them first in Moose, and then in plain old
hand-written Perl 5. The idea here is to try to show exactly what Moose is doing for you behind the
scenes.

Hopefully these documents will be useful for newcomers to Moose. I'd love to here any feedback you
might have on these (or anything about Moose). Feel free to comment here, email us at
moose@perl.org, or stop by irc.perl.org#moose.

[1]: http://groups.google.com/group/perl-appengine/browse_thread/thread/26ddf4c0cf76b2ac
[2]: http://search.cpan.org/~drolsky/Moose-0.57/lib/Moose/Intro.pod
[3]: http://search.cpan.org/~drolsky/Moose-0.57/lib/Moose/Unsweetened.pod
