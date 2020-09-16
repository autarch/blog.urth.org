---
title: Please Test the Tidyall Trial Release
author: Dave Rolsky
type: post
date: 2019-12-25T15:41:22+00:00
url: /2019/12/25/please-test-the-tidyall-trial-release/
---
Yesterday I released a [trial version of Code-Tidyall][1]. This version contains a change based on [a PR by Kenneth Ölwing][2] that (I hope) prevents tidyall from munging line endings when it processes a file.

The problem the PR fixes can occur when you have a file with Unix line endings and you run tidyall on Windows. Most tidyall plugins that do tidying (as opposed to linting) will open the file and rewrite it using Perl. Specifically, they were using `Path::Tiny`'s `slurp` and `spew` methods.

These methods open files using the default IO layers, which on Windows includes the `:crlf` layer. That layer will translate CRLF into LF on read and back again on write. But if the file was _already_ just using LF as the line ending, that means that it will get _converted_ to CRLF on write!

So the fix was to use `slurp_raw` and `spew_raw` everywhere. But that is a **big** change, and I could easily see it breaking some plugin or use case out there.

If you use tidyall please please test this trial release and file bugs for any breakage you find. Absent any breaking bugs, I will probably release this change in 3-4 weeks in a non-trial release.

And a big thank you to Kenneth for finding the problem and the solution!

 [1]: https://metacpan.org/release/DROLSKY/Code-TidyAll-0.76-TRIAL
 [2]: https://github.com/houseabsolute/perl-code-tidyall/pull/97