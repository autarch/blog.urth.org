---
title: Twenty Years of Monthly CPAN Releases
author: Dave Rolsky
type: post
date: 2020-12-05T10:21:22-06:00
url: /2020/12/05/twenty-years-of-cpan-releases
---

I did it!

For the last twenty years I've uploaded at least one new release to [CPAN](https://cpan.org) every
month. How do I know? Neil Bowers has been keeping track on his
[CPAN Regular Releasers](https://neilb.org/cpan-regulars/) page for quite some time. I've had the
montly release quite a long time there.

The second place for monthly release streaks is
[Chris Williams (BINGOS)](https://metacpan.org/author/BINGOS), at 177 months, which is 14 years and
9 months. Also of note is [Karen Etheridge (ETHER)](https://metacpan.org/author/ETHER), who has
maintained a _weekly_ streak for 457 weeks (8+ years)!

So how did I do it? I cheated, of course.

One of the distributions I created and maintain is
[DateTime-TimeZone](https://metacpan.org/release/DateTime-TimeZone). This distribution contains the
entire [IANA time zone database](https://www.iana.org/time-zones) as Perl data. So every time
there's a new database release I have to upload a new
[DateTime-TimeZone](https://metacpan.org/release/DateTime-TimeZone). This process is nearly entirely
automated, consisting of just 3 commands if tests pass. I don't have to code anything, I just update
the `Changes` file.

I also had some help. Karen Etheridge contacted me to let me know I was about to miss a month this
past June. That prompted me to do a release just in time. I also added a repeating to do item at the
end of each month to check if I had done a release that month.

## My First CPAN Releases

My first releases were actually under a different CPAN ID, "PGRIMES", not "DROLSKY". I got my start
with the online world by dialing in to BBS's way back in the 80s, using a 300 baud modem with my
Commodore 64. At that time, no one used their real names a BBS. Instead, they used pseudonyms (mine
was embarassingly childish and I'm not going to tell you what it was). I was so used to using
pseudonyms that I continued to do so early on with the Internet (my first email address was grimes @
waste.org). And I still do, to some degree. It's why my email is "autarch@urth.org", though
"dave@urth.org" works as well, and I use the latter in any professional context, like
[my resume](https://houseabsolute.com/resume/).

So my first release was a logging module called
[`Log::Handler`](https://metacpan.org/release/PGRIMES/Log-Handler-0.30). It's the predecessor to
[Log-Dispatch](https://metacpan.org/release/Log-Dispatch), with a significantly worse design. I
uploaded it to CPAN on December 31, 1998, according to [BackPAN](http://backpan.perl.org/). That's
me partying in the New Year like usual.

But I quickly realized that using a pseudonym for this was a **terrible** idea. I would want to
refer to my CPAN upload on my resume, and I wanted my name to be Googleable. So I switched over to
my [DROLSKY ID](https://metacpan.org/author/DROLSKY) in 1999. My first upload under that account was
a new [Thesaurus](https://metacpan.org/release/Thesaurus) release in September of 1999, followed
soon after by my first release of [Log-Dispatch](https://metacpan.org/release/Log-Dispatch) in
December of 1999.

My twenty year streak started with [Alzabo](https://metacpan.org/release/Alzabo) 0.20 in January
of 2001.

## Twenty More Years?

Probably not.

The IANA time zone database has been getting less active over time. It's only had four releases so
far this year, whereas some past years have had over 10.

At the same time, I'm doing a lot less Perl nowadays. I still use it at work for scripting and quick
tools, but the bulk of my team's code is written in Go (cue rant about how annoying Go is).

And my personal projects lately have mostly been in Rust. It's not because Rust is the absolute best
fit for what I've been doing (though it's good enough). Instead it's because I wanted to challenge
myself and learn something new. Rust is a ton of fun, and the community is great. I highly recommend
checking it out.

But Perl is still my first love, and I still have many friends in both the Perl and Raku
communities. That's why I joined the board of The Perl Foundation. I want to do what I can to help
the languages and communities stay healthy.

So I'll be seeing you at the 2021 Perl and Raku Conference (almost certainly virtually) and I hope
to see you in person at the 2022 conference.
