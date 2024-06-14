---
title: Perltidy Versus Black
author: Dave Rolsky
type: post
date: 2020-10-03T15:31:00-05:00
url: /2020/10/03/perltidy-versus-black
---

I've recently been puttering about attempting to write a
[Postgres SQL & PL/pgSQL tidier in Rust called pg-pretty](https://github.com/houseabsolute/pg-pretty).
If you've always wanted such a thing, don't get too excited. It isn't even close to usable yet.

But this post is about [Perltidy](https://metacpan.org/pod/distribution/Perl-Tidy/bin/perltidy) and
[Black](https://black.readthedocs.io/en/stable/). These are both source code tidiers (aka formatter
aka pretty printers). Black is for Python.

These two tidiers reflect their respective languages. Perltidy is all about TIMTOWTDI[^1] and Black
is very much a TOOWTDI[^2] project.

I've been thinking about these two approaches as I work on pg-pretty. It sure would be cool to offer
a tool that let you format SQL _your_ way. But there are a _lot_ of ways to format SQL! The number
of options I could imagine is pretty huge. And every option increases the complexity of the source
code quite a bit. Since many options can interact with each other, the complexity is even more than
just the sum of the options. That's certainly the case with Perltidy, where certain options behave
differently depending on how other options are set.

Black, OTOH, has no options for formatting. This certainly makes it simpler!

And we can see this by looking at the size of the code bases. I did rough counts using `wc -l`,
which includes docs and comments. I only counted application code, not tests. Perltidy, including
its CLI program `perltidy`, comes out to 44,700 lines or so. Black, using the same `wc -l` approach,
is just under 6,800 lines.

I honestly cannot imagine writing a Pg formatter in the Perltidy style! I don't care _that_ much
about the details of how it looks. I just want to think as little as possible when reading code that
others write!

[^1]: There's more than one way to do it.

[^2]: There's only one way to do it.
