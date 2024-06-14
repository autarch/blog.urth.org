---
title: DateTime::Locale Update
author: Dave Rolsky
type: post
date: 2010-03-28T19:41:44+00:00
url: /2010/03/28/datetimelocale-update/
---

In my [last entry][1], I proposed doing away with DateTime::Locale entirely.

I've since realized that I will want to keep it around as a place to integrate both CLDR and glibc
locale data in one unified interface. I'm still going to work on my new Locale::CLDR module, but the
DateTime::Locale API will probably stick around more or less as-is.

The one thing I will want to get rid of is the custom locale registration system. However, custom
locales would still be usable. They would be loadable by id, or you could pass an
already-instantiated custom locale object to a DateTime object.

[1]: /2010/03/18/do-you-use-datetimelocale-directly/
