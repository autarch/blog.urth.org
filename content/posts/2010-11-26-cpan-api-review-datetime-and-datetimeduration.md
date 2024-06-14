---
title: "CPAN API Review: DateTime and DateTime::Duration"
author: Dave Rolsky
type: post
date: 2010-11-26T11:48:42+00:00
url: /2010/11/26/cpan-api-review-datetime-and-datetimeduration/
---

I've been thinking of writing some CPAN API review blog posts. There's a lot of bad APIs on CPAN.
But before I pick on other people's modules, I thought it would be good to start with something of
my own.

The first release of [DateTime][1] was in early 2003. There's 7+ years of mistakes to review, but
I'll just hit the highlights.

## Duration and subtraction APIs

In my experience, the single most confusing part of the distribution is [DateTime::Duration][2] API.
The original API exposed too much of the internals (via the `delta_*` methods) and not enough of
what people actually wanted. Since then, there's been some band-aids, but the bleeding continues.

Ultimately, I'm not sure how fixable this is. One of the biggest API problems here is that users
expect to be able to freely convert between any units in a duration. This isn't possible, because
there's no fixed conversion between most units (how many days in 3 months?).

This confusion is compounded by the fact that there are several different methods for subtracting
one DateTime from another, and the naming for these methods sucks. The `delta_md` method gives you
months and days, `delta_ms` gives you minutes and seconds, and `subtract` gives you all units. For
extra fail, there is a `delta_days` method in DateTime _and_ DateTime::Duration, and they're totally
unrelated.

Finally, all of this is exacerbated by the fact that there is no date-only class. For any math where
you just need to deal with dates, having a date-only class would obviously make your life easier.
There'd simply be less API to understand, and the date-only class would be more likely to do what
you mean.

## Time Zones by Default

I think DateTime would be much better off if there was one class for floating datetimes, and another
class for datetimes with time zones. Mixing the two together in one class makes the internals more
complicated, and can lead to confusion when comparing two objects. If there were two classes, we
could define explicit conversion methods, but otherwise make them unmixable.

Also, date math without time zones is a lot simpler to understand.

## ETOOMANYNAMES

When I first created DateTime, I imitated parts of [Time::Piece][3] API, and I've since regretted
that. Namely, a lot of the methods have multiple names, so we have `day_of_month`, `day`, and
`mday`, all of which return the same thing. This is just clutter. Even worse, it means that two
pieces of code using DateTime may use different methods to do exactly the same thing.

## DefaultLocale()

This is a global, and globals are bad.

## Strftime

Nowadays, the CLDR patterns are much more useful than strftime. If I were starting over I'd put
strftime and strptime together in an external DateTime::Format::Strxtime library.

## Summary

There's probably other API problems, but I think these are some of the highlights. Feel free to
complain in the comments, or more usefully, submit doc patches where appropriate.

[1]: http://search.cpan.org/dist/DateTime
[2]: http://search.cpan.org/~drolsky/DateTime-0.65/lib/DateTime/Duration.pm
[3]: http://search.cpan.org/dist/Time-Piece

## Comments

**Lee, on 2010-11-27 11:01, said:**  
Nice. I really hope the Perl 6 implementers read this or consult with you when designing whatever
DateTime classes are distributed with Perl 6.

**eric, on 2010-11-29 08:31, said:**  
Interesting topic. Looking forward to reading more reviews of modules.

**Arnaud ZIEBA, on 2010-11-29 14:48, said:**  
Thanks for this critical and humble review. Always interesting to have insight on the rationale of
API design.

**Luke, on 2010-12-08 16:53, said:**  
It's sooo slow, especially if you load the objects but don't use them. (Imagine a legacy wiki app
that is 6-7 years old and uses lots of DateTime) :)

Building something like DateTime::LazyInit into it would help with global warming.

**Dave Rolsky, on 2010-12-08 17:05, said:**  
@Luke: Saying "it's slow" isn't really helpful. I know it could be faster, but it's fast enough for
me and lots of other people to use regularly.

If there's some specific problem you're having you should write email to the <datetime@perl.org>
list.

Also, speed has nothing to do with the API design, which is what this blog post is about.

**Luke, on 2010-12-15 21:25, said:**  
Ok, that's good advice.

I've been using DateTime more frequently lately, and find that I often have trouble with timezones.
I'll forget to set_time_zone(), and just ass-u-me that it's my local machine timezones.
