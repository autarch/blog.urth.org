---
title: No DateTime::Locale Release for CLDR 35.1.0
author: Dave Rolsky
type: post
date: 2019-04-25T21:48:37+00:00
url: /2019/04/25/no-datetimelocale-release-for-cldr-35-1-0/
---
The CLDR project released a point update to the CLDR dataset, 35.1.0, a week ago. I regenerated the `DateTime::Locale` distribution using that source data and none of the data that `DateTime::Locale` cares about has changed.

So if you're wondering why I haven't released a new `DateTime::Locale` now you know why.