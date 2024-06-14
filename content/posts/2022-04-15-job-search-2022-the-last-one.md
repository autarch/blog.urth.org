---
title: "Job Search 2022 Update: The Last One"
author: Dave Rolsky
type: post
date: 2022-04-15T16:39:33-05:00
url: /2022/04/15/job-search-2022-update-the-last-one
---

Assuming nothing unexpected and unhappy happens, this will be my final Job Search 2022 update. I
accepted the offer from MongoDB and I start in a few weeks! Thanks again to David Golden for
reaching out to me about MongoDB way back in early March.

Ultimately, my thinking came down to a decision between startups and public companies. I realized
that given my age and my early retirement goal, I can best achieve that goal by focusing on higher
total compensation that's more secure[^1], rather than going for another startup lottery ticket.

**I want to give a special shout out to Optic.** Of all the places I interviewed with, I liked their
hiring process the most[^2]. The way they structure their take home coding assignment is a bit
different from others, and I'll go into that in a later post. They are also paying me $300 for doing
it, and are the only company that has done this during my search. And as I noted in my last update,
their offer includes options expressed as a percentage of the company, which is another outlier. All
of this makes me think that working there would be great.

**[They are still hiring](https://useoptic.notion.site/Optic-is-hiring-9af73ddc8fd44776a6b4d7339aff6c68)
and if you want to get in on an early stage startup that's not looking to eat your entire life I
highly recommend applying.**

So that's this week's TLDR, but I'll still do the regular full update of all happenings in the past
week.

The list of companies that never responded is still the same:

- GitHub - applied on 2022-03-10
- Netflix - applied on 2022-03-11
- Oso - applied on 2022-03-10

I honestly am questioning my sanity a little here. I do have an automated email from Oso thanking me
for my application, but I don't see one from GitHub or Netflix. Did I not apply somehow? Do they
have a system that doesn't send automated "thanks for applying" emails? I checked my spam folder.
Nothing. Maybe I'll never know. Maybe I'll get a response three months from now and have a laugh.

So what else happened this past week?

Things had gone well with Array, but on reflection I realized I didn't understand their business
well enough. Specifically, I have ethical concerns about fintech in general and their credit tools
specifically. I don't think this sort of thing is _automatically_ bad, but I can imagine it being
used for evil. I realized there's no way I can figure this out short of working there for a few
years. So I withdrew my application.

ClickHouse asked me to do a take home assignment this week. But I got it when I was pretty sure I'd
be accepting a different offer on Friday, so I didn't start it. I withdrew my application today.

I had two interviews scheduled for Monday afternoon with Fastly, but when I went to join the first
one I realized the interviewer had not accepted the calendar invite. I think it's because he's
someone I've hung out a lot with at Perl conferences in the past and so it wasn't appropriate for
him to interview me. But the person doing scheduling hadn't noticed this. So I had one of two
interviews that day, and the other was rescheduled with someone else for Wednesday.

I emailed the recruiter saying I wanted to move things along quickly, and ultimately the final
interviews were scheduled for Friday the 15th. But at the same time, I'd started negotiating on
final offer details with MongoDB. MongoDB's recruiter called me back Friday morning and they met my
increased ask, so I accepted[^3].

So I cancelled the Fastly interviews, which they had scheduled for me pretty quickly to meet my
timeline. I do feel bad about that, but I would note that my application was submitted as an
internal referral on March 9, 37 days ago[^4]. I didn't have my first interview with the relevant
hiring manager until April 6, just nine days ago.

A couple folks I know through Perl who now work at Google reached out on Monday. One works in
developer relations and though that this would be a good fit for me. I asked whether it was possible
to move super fast through the hiring process, because I wasn't going to ask MongoDB and others to
wait for several more weeks on the _hope_ of an offer from Google. They thought it might be.

But it wasn't, so this ended up not going anywhere. I wish I'd reached out to them directly earlier.
From talking to them, it sounds like I'd have a better chance of getting hired for a developer
relations position than the software engineering position a recruiter submitted me for at the
beginning of March. It would've been kind of poetic if the very first place I interviewed, where I
had a terrible experience, turned out to be the _last_ place I interviewed and I ended up working
there.

During my very first call with the recruiter from LogDNA, I told him (and later the hiring manager)
about my plans to spend six months in Taiwan in 2023-2024. I tried to make sure I brought this up
early with every company in case it was a blocker. So ... it turned out to be a blocker. Needless to
say, this was a bit frustrating since I'd already spent several hours in interviews with them and
they'd made an offer. On the plus side, at least I didn't _also_ spend several hours on a take home
assignment too.

Oden decided not to move forward. I didn't get any feedback on why.

I hadn't heard anything from OneSignal this week, so there are no updates about them other than that
I withdrew my application.

## Parting Thoughts

One of the questions I like to ask companies, especially when talking to people at the
director/VP/C-suite level, is what challenges the company is facing now and expects to face in the
future. A number of places said that hiring was a challenge. This is no surprise in such a hot
market. But then why are some companies _still so slow in their hiring processes_?

That's my biggest complaint about my job search. Many companies are surprisingly slow, either to
just _respond_ to an application, or to move the process along as it goes. To be fair, I complained
about this on the hiring side at past employers as well.

I think more companies need to figure out how to make hiring their top priority for the people
involved. There's no reason not to try to schedule all the interviews in the space of a week. If
there's a take home assigment involved, you should give candidates a reasonable amount of time (one
week is a good baseline), but then schedule everything else quickly once that's done. This is
especially true with a candidate like me who is jobless. I had plenty of free time to interview, and
would've loved to go faster everywhere.

Otherwise I don't have _too_ many complaints about the various processes I went through, except for
a few live coding challenges. I'll get into that in a future retrospective post.

I'm quite happy to be done with the job search. It was exhausting! And I'm excited to start at
MongoDB soon. I think the work will be interesting, and everything I know about the company says it
will be a great place to work.

[^1]:
    [RSUs](https://www.investopedia.com/terms/r/restricted-stock-unit.asp) aren't _guaranteed_ to
    have any value in the future, but they're a more reliable value than equity in a private
    company.

[^2]:
    Though all of the companies that I got into the process with were pretty good, modulo some being
    too slow.

[^3]:
    I _hate_ negotiating. It always leaves me wondering if I should've asked for me. This is why I
    prefer public well-defined salary levels.

[^4]:
    `perl -MDateTime -E 'my $dur = DateTime->today->delta_days(DateTime->new(year => 2022, month => 3, day => 9)); say $dur->in_units(q{days})'`
