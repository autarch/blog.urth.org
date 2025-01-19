---
title: "Job Search 2022 Update: Week 5"
author: Dave Rolsky
type: post
date: 2022-04-10T19:16:28-05:00
url: /2022/04/10/job-search-2022-update-week-5
---

It's week 5 and my brain is tired. Fortunately, I think I'm near the end. My current plan is to
decide by Friday, April 15. I suspect that some of the companies I'm talking to won't be in a
position to make an offer then, but I already have some good offers, I want to finish this process,
and there's a limit to how long I can ask people to wait for me to decide.

Once again, I'll start with the the list of places that are just sitting on my application:

- GitHub - applied on 2022-03-10
- Netflix - applied on 2022-03-11
- Oso - applied on 2022-03-10

So it's basically been a month for all of these now.

This past week also had quite a few interviews, as well as some interesting developments that
started on Saturday, April 2. That day, someone shared [my blog post about my GitHub profile
generator]({{< relref
"2022-03-28-yet-another-github-profile-generator.md" >}}) on
[Hacker News](https://news.ycombinator.com/item?id=30886620)[^1].

A hiring manager at Meta (aka Facebook) saw this post, realized I was in the midst of my job search,
and reached out to me to see if I was interested in talking to them. I had kind of ruled Meta out
because I'm unsure whether Facebook is a net negative for the world[^2], as opposed to being
positive or neutral. But interest is always flattering, and they pay the megabucks, so I figured it
couldn't hurt to learn more. I spoke to this manager on Monday, which was helpful.

They ended up connecting me to someone in Production Engineering for another informational
interview. PE is Facebook's SRE, but a little different. Ultimately, I ended up deciding not to
apply for any position there, for a few reasons.

One reason is that I'd almost certainly have had to put in some study time for either a software dev
or PE job, and I don't have time to do that on my current schedule. Second, at least the PE jobs
involve a lot of C++, which I'd like to avoid.

But the third and most important reason is that after thinking about this a lot I'm _still_ unsure
about whether Facebook is a net negative for the world. I just can't see myself working somewhere
that I'm not sure is at least neutral.

On to the rest of the updates ...

I had a few more interviews with folks at Array. I think these went fairly well.

I met with the recruiter at ClickHouse and then had an interview with the hiring manager of the
position I applied for. I think it went well, although I'm not sure if the position is exactly what
I thought it was. I'll have to learn more about it if I move forward.

Cockroach Labs is no longer on the "hasn't responded" list. They responded with a rejection. It took
them three weeks, but that's better than not responding at all. Yes, I'm looking at you, GitHub,
Netflix, and Oso.

I had my first interview with a hiring manager at Fastly. This went well, and I have several more
interviews scheduled for Monday, 2022-04-11. I did emphasize that I'd like to move fast, and I
appreciate their responsiveness to that.

MongoDB made an offer! It's a good offer. But like with LogDNA, I told them that I wanted to decide
this coming week. I also have a call scheduled with the VP of the division (team? department?
sector?) I'd be on at MongoDB. I greatly appreciate the chance to talk to VPs and CEOs post-offer.
Every company should do this.

I haven't heard back from Oden. I will poke them this week if I don't hear something soon.

I had my virtual onsite with OneSignal. This was a mix of interviews and coding challenges. For the
coding challenge, I was warned that maybe I shouldn't do it in Rust, so I did it in Rust anyway. It
involved concurrency, which I've had to deal with in one of my personal Rust projects recently, so
this worked out okay. I ended up learning about some new aspects of [`tokio`](https://tokio.rs/),
which was fun. I probably could've done it in Go or Perl too, but I haven't done anything concurrent
in either recently, and I didn't want to spend the entire time reading docs.

I also had a technical challenge with Optic. They structure this in a really interesting way to make
it more of a work simulation. This challenge went well, and they made an offer! It's a good offer.
Of course, I told them that I wanted to decide this coming week.

I have to give a huge shout-out to Aidan, Optic's CEO, for one small but very important detail in
the offer. **The equity portion of the offer was described as a percentage of the company.** This is
the only number for equity that matters in most cases[^3]. Many companies just give you a number of
shares and the strike price. But without knowing what percentage of the company those options
represent, this is not very meaningful.

So things have been going well, and I'm very optimistic about finishing up this coming week. Stay
tuned for what might be my last update in a week or so. I also plan to write a few retrospective
posts on recruiters, coding challenges, and the ethical impact of my work after that.

[^1]: Why didn't I share this myself? I missed out on 83 points of karma! 83!

[^2]: I feel the same way about much of social media.

[^3]:
    Strike price can matter too, but only with a smaller exit (probably an acquisition) where the
    spread between strike price and share purchase price isn't that big. But if the stock is trading
    at $250/share, the difference between a $2 and $20 strike price is minimal.
