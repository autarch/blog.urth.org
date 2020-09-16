---
title: Swimming in the River of CPAN
author: Dave Rolsky
type: post
date: 2017-12-25T21:00:23+00:00
url: /2017/12/25/swimming-in-the-river-of-cpan/
featured_image: /files/2017/12/cpan-river.png
---
If you've browsed MetaCPAN lately, maybe you've noticed the new "river" indicator that's next to distributions in listings and on individual distribution pages. See the image on the right for an example.

The River of CPAN analogy was first [described by Neil Bowers in 2015][1], though I believe it was created by a group of Perl folks at the 2015 QA Hackathon. The basic idea is that the more dependencies a distribution has, the farther upstream it is. The impact of pollution (API breakage, test failures on install) is dependent on how far upstream a distribution is. Break something that nothing else relies on and there's little harm done. Break something that thousands of distributions rely on and it's a huge mess.

This is a great addition to MetaCPAN and it will be helpful for authors in order to understand how much impact API changes might have.

However, there's one subtlety I wanted to tease out, which is the difference between direct and indirect dependencies. From what I can see, the river indicator is entirely dependent on total dependencies, both direct and indirect, but the differences between these two types of dependencies are important.

Let's take [my distribution Specio][2] as an example. It has a river indicator of four, indicating that it's quite high up the river. But when I hover my mouse over the river indicator, I see it has 11 direct dependents and 3,616 total dependents. In other words, it's not getting much use of its API (sad face), but something(s) that use it are getting a lot of use. If we look at [its reverse dependencies][3] (the distributions that require Specio), we can see what's going on. It's downstream dependents include Moose, DateTime, and Log-Dispatch, among others.

A quick aside ... the inclusion of Moose is a red herring. Moose does not use Specio except in some optional tests. I think the reverse dependency determination is being done by looking at its META.json file if it has one, where Moose lists Specio as a "develop" phase requirement. I think the river indicator may be filtering this out since there are [14 downstream deps listed][3] on the reverse deps page but the river indicator hover info only says 11.

But DateTime does use Specio. DateTime has 1,081 direct dependents and 3,370 indirect deps! That means that if I release a new Specio that fails to install (for example with broken tests), then there are at least 3,370 distributions that are now also uninstallable (if you're running tests). That would be pretty bad!

But what if I change Specio's API? Well, as long as the tests pass, that's unlikely to cause problems. There are only 14 distributions directly using Specio in any fashion. I maintain 11 of them as primary owner, and one of those is deprecated and has no deps anyway. So making a breaking change to the Specio API is unlikely to cause any trouble as long as I _also_ update my own modules that use Specio as needed.

Conversely, I will basically never be able to break the public DateTime API without causing massive chaos on CPAN. There's no way 1,000+ direct dependencies can be checked for breakage and updated in a sane fashion. For DateTime, preserving backwards compatibility is critical and it's hard to justify a breaking API change.

So if you have a far upstream distribution, dig a little deeper into how it got so high on the river. This will help you make the best decisions about how you can or cannot change that distribution in the future.

 [1]: http://neilb.org/2015/04/20/river-of-cpan.html
 [2]: https://metacpan.org/release/Specio
 [3]: https://metacpan.org/requires/distribution/Specio?sort=[[2,1]]