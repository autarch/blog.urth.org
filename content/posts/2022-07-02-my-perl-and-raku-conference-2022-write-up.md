---
title: My Perl and Raku Conference 2022 Write-Up
author: Dave Rolsky
type: post
date: 2022-07-02T11:20:36-05:00
url: /2022/07/02/my-perl-and-raku-conference-2022-write-up
---

I went to [The Perl and Raku Conference
2022](https://perlconference.us/tprc-2022-hou/) in Houston from June
22-24. Here's my write-up.

Again, I'd like to thank [my employer, MongoDB](https://www.mongodb.com/), for
paying for my flight and hotel during the conference. [We're hiring for a
variety of engineering
positions](https://www.mongodb.com/careers/departments), with many remote
options. [Contact me](mailto:autarch@urth.org) if you have any questions about
the company or positions, and I'll see what I can do to find out more.

## The Venue and Location

The conference took place at a hotel near the big Houston airport (IAH) in a
neighborhood called Greenspoint. A local friend told me it's often called
"Gunspoint". My wife and I did not get murdered, so that was good.

One of the things I like to do at a conference is try all the interesting
vegan food in the city. I rented a car[^1] because I knew the venue was a bit
outside the core of the city, and Houston is _very_ sprawly. I ended up
driving more the week of the conference than I do in a month at home. Most of
the restaurants we went to were a 25+ minute drive.

The high temperature each day was around 97-100 degrees Fahrenheit with a fair
bit of humidity, so going outside was like getting punched in the face by the
sun.

The hotel itself was fine but they had the air conditioning dialed up
to 11. So in some conference rooms, I had to wear jeans and a long-sleeved
shirt to feel comfortable. Meanwhile, the best clothing for outdoors was
... there was no good clothing for going outdoors.

There was some sort of issue with the projection in many rooms that seemed to
make slides harder to read than usual. I think maybe the bulbs in the
projectors needed to be replaced? Or maybe we needed to dim the lighting in
the rooms?

## The Talks

Here are some write-ups of many (but not all) of the talks I attended.

### People Still Use Perl? - Twenty Years of Making a Living with a Dead Language - Ruth Holloway

[Watch it on YouTube](https://youtu.be/XnDkpqwzpp0).

This is a talk about Ruth's history with Perl. It's not super technical, but
it's pretty interesting. It's also really personal and emotional, which isn't
something you see a lot at programming conferences. I'm impressed that Ruth
was able to be so open about herself!

### NewFangled: Bringing NewRelic to Perl with Alien and FFI Technology - Graham Ollis

[Watch it on YouTube](https://youtu.be/6o_w-xxjbbg).

Graham has created several CPAN modules to make FFI in Perl easier than it is
with raw XS, including [FFI-Platypus](https://metacpan.org/dist/FFI-Platypus),
which lets you implement FFI entirely in Perl.

I got to this talk a little late but the parts I caught were interesting, and
mostly covered the API of this module and some other related ones like
[FFI-C](https://metacpan.org/dist/FFI-C).

This talk is probably _mostly_ interesting to people interested in Perl,
unless you're implementing FFI tools for another language, in which case
there's a lot to learn from here.

### Taming the Unicode Beast - Felipe Gasper

[Watch it on YouTube](https://youtu.be/yH5IyYyvWHU).

This is a good talk for anyone interested in handling Unicode properly. Felipe
did a good job of clarifying the difference between Unicode and UTF-8,
characters versus bytes, and all the usual confusing parts of Unicode.

He made a good argument that the tools built into the Perl core aren't good
enough for proper UTF-8 handling and that you should use [his Sys::Binmode
module](https://metacpan.org/pod/Sys::Binmode) to fix it. He also explained a
variety of potential UTF-8 gotchas in both Perl and XS code.

A lot of these issues stem from the fact that Perl does not distinguish
between a scalar containing characters and one containing bytes at a type
level. This should sound familiar since this is the issue that led to
Python 3. So I guess that's what we'll get in Perl 7?[^2]

I think this will be of interest to anyone interested in Unicode issues. And
if you're designing your own language, you should learn about this stuff!

### A Nailgun for Raku - Daniel Sockwell

[Watch it on YouTube](https://youtu.be/NT1uBYBubNU).

A lightning talk about improving the startup time for Raku scripts.

Fun fact, the solution that Daniel discusses was implemented for _Perl_ back
in the early 2000s. Check out [Matt Sergeant's
PPerl](https://metacpan.org/dist/PPerl).

Everything old is new again.

### Open Source, Self Hosted Password Management with Bitwarden + Vaultwarden - Daniel Sockwell

[Watch it on YouTube](https://youtu.be/hBRg-S4YyUk).

I hope you're all using a password manager. If not, you should be.

But did you know you can host your _own_ password manager sync server? But
I'll stick with 1Password because I'm lazy.

### Modern Approaches to Ancient Perls - Brian Kelly

[Watch it on YouTube](https://youtu.be/CwHRr_NTVjk).

I think I went to this partly because of the schadenfreude. I haven't done
much Perl professionally since 2017 or so, and I was always able to use a
modern Perl, so this hasn't been a problem for me.

But it was interesting to learn how to make older Perls less painful to use.

### Command-line Filters - Time to Shine - Bruce Gray

The recording for this one didn't come out, so I can't link to it. I've heard
a re-recording may happen so I will update this post if that happens and I
notice the update.

This talk covered how to use command-line filters. I already knew a fair bit
about this but I still learned some new things.

### Three Ways to Make Wrong Code Look Wrong (er) - Daniel Sockwell

[Watch it on YouTube](https://youtu.be/k-4agG8aJ1k).

I really liked this talk. It's about three different approaches to making
developer mistakes obvious. I preferred the version using the type system, and
this approach can be used by any language with a sufficiently not-terrible
type system (I'm looking at you, C).

### Why Do Programmers Love Rust? - Dave Rolsky

[Watch it on YouTube](https://youtu.be/vEuG2YoJZJw).

> A heartbreaking work of staggering genius. Nothing will ever be the same.
> <cite>Anonymous Attendee</cite>

> I was floored! Then I was ceilinged and walled too!
> <cite>Anonymous Attendee</cite>

> He is clearly making these quotes up.
> <cite>Anonymous Attendee</cite>

I think this talk went reasonably well. I started rushing a bit towards the
end because I was afraid I would run out of time, and then I ended a little
early. Doh! I did practice this at home to check the timing, but for some
reason, in the moment I felt like I was behind schedule. Next time I give this
I'll slow down a little (assuming I have a 50 minute slot).

Also, a few slides were hard to read. For the code examples, I realize now
that it'd be better to use a light theme and to make sure that comments aren't
very dim as they are in the theme I used. So I switched the slides to the
highlight.js VS theme, which looks much better.

For the screenshots of compiler errors, I'm not sure how to fix these. I
suspect the ideal approach is to not use screenshots but to instead recreate
the error in the browser in a large font. But that's a lot of work.

A little bit of this was due to the projector issues I mentioned above, but
mostly it's on me to make better slides in the future.

However, looking at the video it's all very readable so that's nice.

And wow, I move my hands a _lot_ when I'm giving a talk. Okay, time to stop
watching this video of myself.

### Meet the TPF Board

[Watch it on YouTube](https://youtu.be/GSyMlEaaJro).

This was a brief presentation about The Perl Foundation/Raku Foundation,
followed by Q&A. If you wonder what the foundation does, this may help answer
your questions.

### The Perl Navigator: Code Intelligence for any Editor - Brian Scannell

[Watch it on YouTube](https://youtu.be/ENN05EhBkgM).

Last time I looked for an LSP server for Perl I gave up. The ones I tried
didn't seem to work.

But then the day before the conference proper, some folks were talking about
Perl Navigator in the conference Slack, so I gave it a shot. And to my
surprise, it worked quite well out of the box! And Brian fixed the one notable
issue I had (not including `./lib` in the module search path) quickly.

So I highly recommend Perl Navigator if you want an LSP server. **And if you've
never used an LSP server, you want an LSP server**. Using `lsp-mode` in
Emacs has greatly improved my productivity. I don't know why I took so long to
start using it.

So this talk is both about LSP in general and the implementation for Perl
specifically. I think it will be of interest to anyone interested in LSP.

### Mastering English in Perl - Makoto Nozaki

[Watch it on YouTube](https://youtu.be/TLZwWNbl2wI).

By far the funniest and cutest talk at the conference. Watch it now!

### IPv4 subnetting for humans - Teddy Vandenberg

[Watch it on YouTube](https://youtu.be/OGVAlPBiNYM).

He says the math is simple but my brain still hurt. This will be useful for
people who are smarter than me.

### CLI Tools I Use - Dave Rolsky

[Watch it on YouTube](https://youtu.be/A5NZIw3jp2E)

It's me again. Just a quick talk on some CLI tools I use that might be of
interest. This talk has no Perl content and should be of interest to anyone
who uses the CLI.

This was inspired by Bruce Gray's talk earlier that day on command-line
filters

### SQL::Abstract - Caveat Emptor - Dimitrios Kechagias

[Watch it on YouTube](https://youtu.be/oHUIbWjphnU)

I was never a fan of [`SQL::Abstract`](https://metacpan.org/pod/SQL::Abstract)
because I find its API arbitrary and confusing. But apparently, it's also
really slow.

### Dispatches from Raku - Daniel Sockwell

[Watch it on YouTube](https://youtu.be/TNZQuzvroEY)

A quick summary of what's new in Raku over the past year or so.

### Advice for Presenters

Hey, you, Presenter! Have you tried reading your slides on a projector from
thirty feet away? No, you clearly haven't, because I can't read your slides
and I'm closer than that!

Here are some things to consider ...

More than 10 lines of code on a slide is probably too much. You can get away
with more lines if you use highlighting to just focus on a few lines, but be
very aware of the font size.

Grey on grey is not readable. Blue on grey is not readable. Grey on blue is
not readable. Many other color combinations are not readable!

Use high-contrast colors. Use higher contrast than you'd use for a web
page. Remember, your audience may not be sitting up close and your projector
probably will not render things as brightly as your laptop screen.

Less is more. Less text, less code, fewer boxes, fewer graphics. The more
stuff you put on a slide the smaller that stuff is and the harder it is to
read. Instead of one busy slide, make four, five, or ten simple slides!

## Non-Conference Stuff

We stayed for a few extra days on either side of the conference so my wife and
I could do some tourist stuff. On the Monday before the conference, we went to
the Johnson Space Center, which was fun. I enjoyed walking through the 747
that flew the space shuttle around.

The day after the conference, I met up with a former coworker from ActiveState
and his wife. We had lunch with them, then went to the art museum to see an
M.C. Escher exhibition. This was great! They had lots of original prints as
well as the wood he would carve to make them. They also had drafts and work
from his planning process. The amount of work involved in producing these is
amazing. My wife and I greatly enjoyed hanging out with them and seeing the
exhibition.

Of the food we tried, I think the best was [Trendy
Vegan](https://trendyhouston.com/), which serves vegan Chinese. The salt and
pepper tofu was fantastic. I also liked [Tainan
Bistro](https://www.tainanbistrohouston.com/), which serves Taiwanese
food. But I'm not sure how easy it would be to get vegan food there if you
don't speak Mandarin.

## The Hallway Track

This is the best part of the conference. I enjoyed seeing old friends and
making new ones. I was bummed that some folks couldn't make it for various
reasons, including visa and passport issues. I'm hopeful that they'll be able
to come next year.

I was quite happy that for the first time, someone with prior climbing
experience joined me for my Rock Climbing BOF! He knew how to belay so I could
do more than climb the autobelays. But it would have been nice to have more
folks join us. Hopefully next year I'll get a few more takers.

## Next Year's Conference

It will be in Toronto! The 2005 conference was in Toronto and I loved it. The
weather was great and the city is _very_ walkable, which is a huge plus for
me. I didn't like driving so much in Houston.

[^1]:
    I paid for this out of pocket, since it was purely for entertainment
    purposes.

[^2]: This is a joke.
