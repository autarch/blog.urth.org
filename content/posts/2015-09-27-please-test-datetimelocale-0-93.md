---
title: Please Test DateTime::Locale 0.93
author: Dave Rolsky
type: post
date: 2015-09-28T04:30:17+00:00
url: /2015/09/27/please-test-datetimelocale-0-93/
---

For a long time, the DateTime::Locale distribution has been rather stale. It is built from the [CLDR
project][1] data, which came in XML form. And not just any XML, but one of the most painful XML
formats I've ever experienced. It's a set of data files with complicated inheritance rules between
locales (both implicit and explicit). Any data file can contain references to any other file. There
are "alternate" and "variants" for various items. It's complicated.

To make it worse, the format kept changing between releases and breaking my hacktastic tools to read
the data. I gave up on dealing with it, thinking that I'd either need to implement a full CLDR XML
reader in Perl or link to the libicu C library. The latter might still be useful, but for now
there's an alternative. At YAPC this summer, I was talking about localization with [Nova Patch][2]
and they told me that there was now a JSON version of the CLDR data!

I took a look and realized this would make things much easier. The JSON data resolves all the crazy
aliases and inheritance into a very simple set of files. Each locale's file contains all of the data
you need in one spot. It took me just a few days of work to build a new set of tools to read the
files and generate a new DateTime::Locale distro.

I've also taken this opportunity to update the code in the distribution. I've deprecated some bits
of it and sped up the load time for the main module (as well as many locales) quite a bit. While the
Changes file has many changes, none of them will affect the vast majority of users. My goal for this
release is to make it 100% backwards compatible in terms of the interaction between DateTime and
DateTime::Locale. If your code does not use locale objects directly, then you shouldn't need to
change anything.

Of course, much of the locale data has changed, so if your code relies on a specific month or day
name in a given language, or a specific format string, that can change (and always could). But the
API that DateTime uses should continue to work.

There are a few test failures in the DateTime suite from the new version, but that's solely due to
the DateTime tests themselves making certain assumptions about how locales work. These failures
should not be relevant to the vast majority of code.

So with all that said, I'd greatly appreciate some testing. Please install the [new trial release
(0.93)][3] and test your code with it. Please report any bugs you find. I plan to release a
non-trial version (along with a new DateTime to go with it) in a few weeks if no major problems are
found.

[1]: http://cldr.unicode.org/
[2]: http://patch.codes/
[3]: https://metacpan.org/release/DROLSKY/DateTime-Locale-0.93-TRIAL
