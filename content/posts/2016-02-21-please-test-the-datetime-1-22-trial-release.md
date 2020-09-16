---
title: Please Test the DateTime 1.22 Trial Release
author: Dave Rolsky
type: post
date: 2016-02-21T19:59:42+00:00
url: /2016/02/21/please-test-the-datetime-1-22-trial-release/
---
[The 1.22 trial release][1] includes some small backwards incompatible changes in how `DateTime->from_epoch` handles floating point epoch values. Basically, these values are now rounded to the nearest microsecond (millionth of a second). This release also fixes a straight up bug with the handling of negative floating point epochs where such values were incremented by a full second.

I've tested many downstream DateTime dependencies in the DateTime::* namespace. The only thing that broke was DateTime::Format::Strptime, for which I will release a backwards compatible fix shortly.

If no one tells me that [DateTime 1.22][1] breaks their code I will release a non-trial version on or after Sunday the 28th.

 [1]: https://metacpan.org/release/DROLSKY/DateTime-1.22-TRIAL