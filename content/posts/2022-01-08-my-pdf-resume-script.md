---
title: My PDF Resume Script
author: Dave Rolsky
type: post
date: 2022-01-08T10:26:12-06:00
url: /2022/01/08/my-pdf-resume-script
---

I only want to have [one canonical resume](https://houseabsolute.com/resume/),
and I want to keep it on my personal website. That makes it trivial to update,
and anyone with the link can see the latest version at all times.

But unfortunately very few job application systems will accept a link to a
resume. Most want a document of some kind. I didn't want to maintain a second
copy as a Google Doc or something like that, so I wrote [a script to transform
the web version to a
PDF](https://gist.github.com/autarch/4b3d04bb08639eb0413c7bde8d9b65ce). Here's
a [copy of the PDF
version](https://drive.google.com/file/d/1gsV9Tx09iCquhqwLnd0XER4xRUnB7hDb/view?usp=sharing).

When I first looked into doing this I was afraid it would be a lot of
work. Fortunately, it turned out to be super easy[^1].  It's in Perl, of
course. This script is true glue code, and Perl made this work trivial.

All it does is grab the raw HTML from the page, munge it a bit, and then pass
it through [Pandoc](https://pandoc.org/). Pandoc is great. It uses LaTex as
the intermediate format to generate the PDF, so it ends up looking very
professional (IMO) with no work on my part!

I wrote the first version back in 2016 when I knew I was looking for a new
position. I've made a few tweaks to it over the years as the web version has
changed, but not many.

So in summary, yay Perl, yay Pandoc.

[^1]: Barely an inconvenience.
