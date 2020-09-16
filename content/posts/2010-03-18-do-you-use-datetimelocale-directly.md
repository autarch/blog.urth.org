---
title: Do You Use DateTime::Locale Directly?
author: Dave Rolsky
type: post
date: 2010-03-18T14:01:40+00:00
url: /2010/03/18/do-you-use-datetimelocale-directly/
---
I'm planning to end-of-life DateTime::Locale sometime in the future, in favor of a new distribution, Locale::CLDR.

This new distro will be designed so that it can provide all the info from the CLDR project (eventually), rather than just datetime-related pieces.

My plan is to have DateTime use Locale::CLDR directly, rather than continue maintaining DateTime::Locale.

To that end, I'm wonder how people are using DateTime::Locale. I'm _not_ interested in people only using it via DateTime.pm. That form of usage will continue to work transparently. You specify a locale for a DateTime.pm object and you get localized output.

All of the information available from DateTime::Locale will be available from Locale::CLDR, although the API will be a little different.

In particular, is anyone out there using custom in-house locales at all?

That would be the biggest potential breakage point, since upgrading DateTime.pm to a version that uses Locale::CLDR will end up making your custom locales invalid.

I'm planning to support some form of custom locales in Locale::CLDR as well, of course.

None of this will happen in the very near future. I still need to get DateTime::Format::Strptime not using DT::Locale first, which is its own painful project ;)

Please reply in the comments or [send me email][1].

 [1]: mailto:autarch@urth.org

## Comments

**Jesse, on 2010-03-28 17:12, said:**  
\*raises hand\* 

We do use it in released version of RT. I \_believe\_ that right now, we just rely on format_cldr. Would a compatibility layer for older apps be a possibility? If so, we should chatter about (possibly) me throwing a minion at it.