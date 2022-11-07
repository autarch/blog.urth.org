---
title: "Software Job Search 2022 Retrospective: Coding Challenges"
author: Dave Rolsky
type: post
date: 2022-04-19T10:57:22-05:00
url: /2022/04/19/software-job-search-2022-retrospective-coding-challenges
discuss:
  - site: "Hacker News"
    uri: "https://news.ycombinator.com/item?id=31085291"
---

I did a lot of coding and design challenges during my recent job search! A lot
a lot. And I have some thoughts about them.

{{< aside >}}

Want to read all about my job search? Here's a list of past posts:

- [Week 1]({{< relref "2022-03-11-job-search-2022-update-week-1.md" >}})
- [Week 1.1]({{< relref "2022-03-14-job-search-2022-update-week-1-1.md" >}})
- [Week 2]({{< relref "2022-03-19-job-search-2022-update-week-2.md" >}})
- [Week 3]({{< relref "2022-03-25-job-search-2022-update-week-3.md" >}})
- [Week 4]({{< relref "2022-04-02-job-search-2022-update-week-4.md" >}})
- [Week 5]({{< relref "2022-04-10-job-search-2022-update-week-5.md" >}})
- [The Last One]({{< relref "2022-04-15-job-search-2022-the-last-one.md" >}})

{{< /aside >}}

I mostly have thoughts about the _coding_ challenges. The design challenges
were pretty much what you'd expect. They started with "design a system that
has to do X". Once I had an initial design they'd ask some questions about how
to handle various types of changes in scale, requirements, etc.

I've given design challenges as an interviewer before. I think they're great
because it's a chance to have a conversation on a technical topic with someone
that is a _lot_ like what you'd do when working with them. More places should
do these!

How many of these types of challenges was I given? So many! Here's a list:

- Array - 1 take-home coding.
- ClickHouse - 1 take-home coding - but I didn't do this because it came just
  before I decided to accept the MongoDB offer.
- Google - 1 live coding - but I didn't continue after this, so there's
  probably more that they do.
- LogDNA - 1 live system design.
- MongoDB - 3 live coding, 1 live system design.
- Oden - 1 live coding (which I can't remember very well), 1 live system design
- OneSignal - 2 live coding - I withdrew my application before getting a final
  response from them, but I think I'd already done their full interview
  process.
- Optic - 1 take-home coding.

But what about the coding challenges? Let's start at the very beginning, and
ask what the purpose of this type of challenge is. I think there are a few
things companies would _like_ to learn from these challenges:

- Can the candidate understand requirements and build software that fulfills
  those requirements?
- Can the candidate write code that isn't a complete mess? For example, do
  they break their code up into reasonably sized
  functions/methods/classes/packages?
- Does the candidate understand various technical concepts at the level you'd
  expect given their experience? This includes topics like concurrency,
  serialization, REST APIs, etc.

## Live Coding

**I very strongly question whether you can learn any of these things from a
live coding challenge.** There are several reasons for this.

These sorts of exercises are ridiculously artificial, with very little
resemblance to real-world work. They take place in a high-pressure situation
in a very limited time. Many of them also further hamper the candidate with
additional constraints.

It's very common to do these in CoderPad (or an equivalent). **CoderPad is hot
steaming garbage and can go fork itself.** It's like a half-assed version of
an IDE from 20+ years ago. It has very little customization, no code
completion, and is very different from most developers' preferred
environments. Even I, a dinosaur who will have Emacs pried out of my cold dead
hands, have finally started used using [LSP
mode](https://emacs-lsp.github.io/lsp-mode/) to turn Emacs into a proper IDE.

Why do companies use this tool? I don't know. Looking at the feature list, it
doesn't seem like it does anything all that amazing. Pretty much every company
was using Zoom for interviews, which let syou share your screen. CoderPad
_does_ let the interviewer type as well, but there are solutions to that, like
the [VS Code Live Share
extension](https://code.visualstudio.com/learn/collaboration/live-share) or
the Chrome Remote Desktop extension.

At the very least, I'd like to see more companies offer candidates a choice of
environments. Of all the companies I interviewed with, only OneSignal _didn't
only_ use CoderPad (or Google's internal thing). For one of the challenges we
used CoderPad, and then for the other I shared my screen. This was slightly
awkward since I was using Zoom's in-browser version, but its screen sharing is
broken if you try to share your whole screen[^1], but I needed to share
multiple apps (Emacs and a terminal), so I had to quickly install the Zoom
Linux app and hope it didn't hard-lock my computer, as it loves to do.

The challenges I did live included topics like data (de)serialization,
concurrency, and algorithms and data structures. For the algorithms and data
structures ones, I was told not to look things up online, making the
experience even more divorced from normal day-to-day software development. For
the others, I was able to look up things like library APIs, and they tended to
be more interactive.

The worst of these was with Google, where the interviewer was mostly mute as I
stumbled through the problem. The other algorithms interview I had was with
MongoDB and the interviewer was more of a partner in the coding process.

If I had to evaluate my own performance, I'd say that on my two
algorithms/data structures challenges, I did either very poorly (Google) or
somewhat poorly (MongoDB). For the others, I did either very well (finishing
the problem in half the allotted time) or fairly well (finishing easily in the
allotted time, but with more looking things up online or getting some help
from the interviewer).

But when I think about _why_ I did well on some of these and poorly on others,
I think it comes down almost entirely to prior experience. There were several
different data (de)serialization problems across different companies. I have a
_lot_ of experience with this. I've helped design [a somewhat complex binary
on-disk data format](https://maxmind.github.io/MaxMind-DB/) for which I wrote
[the writer](https://metacpan.org/dist/MaxMind-DB-Writer)
[and](https://maxmind.github.io/libmaxminddb/)
[multiple](https://metacpan.org/dist/MaxMind-DB-Reader)
[readers](https://metacpan.org/dist/MaxMind-DB-Reader-XS). I also wrote a
[pretty cool (IMHO) JSON
tidier](https://github.com/ActiveState/json-ordered-tidy/), and I've dug a bit
into the guts of [serde](https://serde.rs/),
[easyjson](https://github.com/mailru/easyjson/pull/339), and lots of Perl code
for handling config files and other formats.

Unsurprisingly, when presented with a similar problem I can solve it _very_
quickly. But that's not because I'm an awesome programmer[^2], it's just
because I'm repeating a task I've already done many times.

Similarly, the concurrency-related tasks weren't too hard, in part because for
[my music player
frontend](https://github.com/autarch/Crumb/tree/master/web-frontend) I've had
to work with async APIs and tasks a lot recently. So solving similar problems
feels easy.

But if my past work history had been different, would I have done nearly as
well? Almost certainly not.

On the flip side, the two algorithms questions were toy problems that bore no
resemblance to any work I've ever done[^3]. If I had to do something
similar for work, I'd google the answer, cut, paste, and tweak some code, and
probably have something reasonable working soon enough. But without that
"crutch"[^4] to lean on, I didn't do very well.

Given all that, I'm very skeptical that the interviewers got good
answers to the questions I think they should be asking. Instead, I think they
mostly learned if I'd done a similar thing in the past or not. That is
somewhat useful information. I guess. Maybe. But I think it's a pretty poor
indicator of my future job performance.

## Take-Homes

It's obvious to me that take-homes do a much better job of answering the
questions I posed above. The candidate can do them in a reasonable time frame,
with less pressure, and in a familiar coding environment.

However, take-homes have a few big disadvantages for both the candidate and
employer.

The big one is that they take longer in several ways. They use more of the
candidate's time, which is annoying for the candidate. For the take-homes I
was given, I was told they should take 2-4 hours, as opposed to all of the
live coding exercises, which were scheduled for 45 minutes or an hour.

And because it's more time-consuming for candidates, it means that they may
just not bother. We saw non-trivial attrition during this step of our hiring
process at both MaxMind and ActiveState. We'd give them the take-home
challenge and they'd disappear. I certainly don't blame them!

It also tends to slow down the hiring process. The employer has to give the
candidate a reasonable amount of time to do this. Most places gave me 3-7 days
as a default, with a provision saying "let us know if you need more
time". That's a 3- to 7-day stall in the hiring process. During that time the
candidate might finish a bunch of live coding interviews with other companies
and get an offer!

The other issue I saw with take-homes is that they're harder to scope
well. Notably, I think Array's exercise was a bit under-specified and could
have used more clarification of what was in scope and out of scope. I think I
spent more time on it than was needed because of this.

### Optic's Challenge and Why It Was the Best

As I mentioned in a previous post, I really liked how Optic structured their
challenge. They're a remote company trying to work largely asynchronously, and
the challenge reflects this. It started with an invite to a fresh Git repo
that included the instructions as well as some existing code. The work
involved extending an existing service in the repo with some functionality,
though you could do this by writing a new service for just the new bits of the
API. They also invited me to a Slack channel just for this challenge.

They encouraged me to treat this like I would if I was actually working
there. So rather than just taking the instructions and working in isolation, I
started by asking for a quick Zoom call with one of their devs[^5] to clarify
a few points. Then later in the process, I filed some GitHub issues to ask
more questions about details of the project and scope. The same dev responded
on GitHub and we discussed the pros and cons of each implementation.

Another thing I liked was that they not only asked for code, they also
asked for some documentation around design choices, trade-offs I'd made, and
future directions for improvements. This is exactly the type of thing you'd do
at work, right? The main difference is that you'd probably do some of that
documentation _first_ as part of the feature scoping. Then the final
deliverable could include some documentation/stories/tasks/tickets/whatever
for next steps on the project.

And finally, they paid me $300 for doing this. FWIW, I understand why this can
be a bit tricky at some places, so I think a good alternative would be to
offer to make a donation to a 501(c)(3)[^6] charity on the candidate's behalf.

## What About Existing Projects?

_None_ of the companies that gave me any of these challenges offered to let me
submit an existing project as a replacement. This surprised me. I didn't ask
any places about this. In retrospect, I wish I had, just out of curiosity as
to why.

My _guess_ is that they would say that they want to give all candidates the
same process in the interest of equity. But I'm _extremely_ skeptical that
in practice this improves diversity in hiring.

If you're coming into tech from an underrepresented background, are you more
or less likely to have the free time and energy to spend three hours per
company on take-homes? Are you more or less likely to get nervous and freeze
up during a live coding exercise?

If anyone has more data about this [I'd be very curious to learn
more](mailto:autarch@urth.org).

## Takeaways

Ironically, when I was given the choice by OneSignal[^7], I chose live coding
over a take-home. I was gambling that it would go well and I wanted to save
some time. For me, live coding was better because it's quick and I was fairly
confident I could quickly handle most types of problems that I would get in
these sessions.

I think more companies should offer this choice. This lets the candidate pick
the option that they think will best showcase their skills.

But I think it's probably _worse_ for the company doing the hiring.

Is there any better way to evaluate someone's abilities besides a take-home or
looking at existing public projects? I can't think of one. In my time in
software engineering, I've seen a lot of people hired as developers who were
fundamentally incapable of good work for a variety of reasons. Getting answers
to the questions I posed above is critical for hiring.

So we're left in this state where it's hard to hire software engineers, but we
feel like we have to put them through the wringer in the interview process
anyway. What a silly, silly field I'm in!

[^1]: I'm going to blame this on Wayland.
[^2]: Though I am ;)
[^3]:
    I'd honestly be surprised if _any_ software developer I met had done
    something similar outside of leetcode-type exercises, though I'm sure
    someone somewhere has.

[^4]:
    Of course, this isn't a crutch. No sane employer will ever complain that
    you found an answer quickly online as opposed to spending longer solving
    it from first principles in isolation!

[^5]:
    Yes, I know I said they work asynchronously, but they also made it clear
    that a kickoff Zoom call was an option.

[^6]: Or your country's equivalent.
[^7]: The only company that offered this choice, IIRC.
