---
title: 'CPAN API Review: DateTime and DateTime::Duration'
author: Dave Rolsky
type: post
date: 2010-11-26T11:48:42+00:00
url: /2010/11/26/cpan-api-review-datetime-and-datetimeduration/
categories:
  - Uncategorized

---
I&#8217;ve been thinking of writing some CPAN API review blog posts. There&#8217;s a lot of bad APIs on CPAN. But before I pick on other people&#8217;s modules, I thought it would be good to start with something of my own.

The first release of [DateTime][1] was in early 2003. There&#8217;s 7+ years of mistakes to review, but I&#8217;ll just hit the highlights.

## Duration and subtraction APIs

In my experience, the single most confusing part of the distribution is [DateTime::Duration][2] API. The original API exposed too much of the internals (via the `delta_*` methods) and not enough of what people actually wanted. Since then, there&#8217;s been some band-aids, but the bleeding continues.

Ultimately, I&#8217;m not sure how fixable this is. One of the biggest API problems here is that users expect to be able to freely convert between any units in a duration. This isn&#8217;t possible, because there&#8217;s no fixed conversion between most units (how many days in 3 months?).

This confusion is compounded by the fact that there are several different methods for subtracting one DateTime from another, and the naming for these methods sucks. The `delta_md` method gives you months and days, `delta_ms` gives you minutes and seconds, and `subtract` gives you all units. For extra fail, there is a `delta_days` method in DateTime _and_ DateTime::Duration, and they&#8217;re totally unrelated.

Finally, all of this is exacerbated by the fact that there is no date-only class. For any math where you just need to deal with dates, having a date-only class would obviously make your life easier. There&#8217;d simply be less API to understand, and the date-only class would be more likely to do what you mean.

## Time Zones by Default

I think DateTime would be much better off if there was one class for floating datetimes, and another class for datetimes with time zones. Mixing the two together in one class makes the internals more complicated, and can lead to confusion when comparing two objects. If there were two classes, we could define explicit conversion methods, but otherwise make them unmixable.

Also, date math without time zones is a lot simpler to understand.

## ETOOMANYNAMES

When I first created DateTime, I imitated parts of [Time::Piece][3] API, and I&#8217;ve since regretted that. Namely, a lot of the methods have multiple names, so we have `day_of_month`, `day`, and `mday`, all of which return the same thing. This is just clutter. Even worse, it means that two pieces of code using DateTime may use different methods to do exactly the same thing.

## DefaultLocale()

This is a global, and globals are bad.

## Strftime

Nowadays, the CLDR patterns are much more useful than strftime. If I were starting over I&#8217;d put strftime and strptime together in an external DateTime::Format::Strxtime library.

## Summary

There&#8217;s probably other API problems, but I think these are some of the highlights. Feel free to complain in the comments, or more usefully, submit doc patches where appropriate.

 [1]: http://search.cpan.org/dist/DateTime
 [2]: http://search.cpan.org/~drolsky/DateTime-0.65/lib/DateTime/Duration.pm
 [3]: http://search.cpan.org/dist/Time-Piece

## Comments

### Comment by Lee on 2010-11-27 11:01:11 -0600
Nice. I really hope the Perl 6 implementers read this or consult with you when designing whatever DateTime classes are distributed with Perl 6.

### Comment by eric on 2010-11-29 08:31:58 -0600
Interesting topic. Looking forward to reading more reviews of modules.

### Comment by Arnaud ZIEBA on 2010-11-29 14:48:27 -0600
Thanks for this critical and humble review. Always interesting to have insight on the rationale of API design.

### Comment by Luke on 2010-12-08 16:53:43 -0600
It&#8217;s sooo slow, especially if you load the objects but don&#8217;t use them. (Imagine a legacy wiki app that is 6-7 years old and uses lots of DateTime) :)

Building something like DateTime::LazyInit into it would help with global warming.

### Comment by Dave Rolsky on 2010-12-08 17:05:31 -0600
@Luke: Saying &#8220;it&#8217;s slow&#8221; isn&#8217;t really helpful. I know it could be faster, but it&#8217;s fast enough for me and lots of other people to use regularly.

If there&#8217;s some specific problem you&#8217;re having you should write email to the <datetime@perl.org> list.

Also, speed has nothing to do with the API design, which is what this blog post is about.

### Comment by Luke on 2010-12-15 21:25:39 -0600
Ok, that&#8217;s good advice.

I&#8217;ve been using DateTime more frequently lately, and find that I often have trouble with timezones. I&#8217;ll forget to set\_time\_zone(), and just ass-u-me that it&#8217;s my local machine timezones.