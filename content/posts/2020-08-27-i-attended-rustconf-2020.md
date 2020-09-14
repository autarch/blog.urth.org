---
title: I Attended RustConf 2020
author: Dave Rolsky
type: post
date: 2020-08-27T19:20:54+00:00
url: /2020/08/27/i-attended-rustconf-2020/
categories:
  - Uncategorized

---
Like so many conferences this year, RustConf 2020 was a purely virtual event. I&#8217;d already helped organize and attended The Perl Conference in the Cloud 2020 as a virtual conference earlier this year, so I knew it could work.

RustConf was very different from The Perl Conference. It was just one day and one track, lasting about five and a half hours with a break in the middle. The conference schedule was incredibly detailed. For example the opening keynote was from 9:35-10:27. And it really was exactly that long. I was totally amazed that the speakers could stick to such strict times until I realized that everything being presented was pre-recorded.

The talk quality was quite high. I believe that the conference organizers worked with each presenter to help them polish their presentation, which is really nice. This may be related to the format, since this wouldn&#8217;t be feasible with a much larger set of presentations. And obviously pre-recording helps here since the speakers could do multiple takes (and even do edits if they wanted).

The conference itself was streamed on YouTube, with Discord as a chat server. The organizers set up channels for each talk that were only usable during the talk and were made read-only before and after. This worked quite well. There were also some general channels like #hallway and #jobs and such.

Finally, there was a companion &#8220;app&#8221;, Meeting Pulse, with the detailed schedule, a place for attendee pictures, and some other features. I say &#8220;app&#8221; in quotes because it was just a webapp, though it worked fine on a phone. I ran it on my desktop in a second monitor, which was fine, except that it used insane amounts of CPU and GPU and occasionally lagged quite a bit. But this wasn&#8217;t a big problem.

I didn&#8217;t like every aspect of the scheduling. The first part ran from 11:30-13:00 with no breaks. For anyone organizing an online conference I&#8217;d suggest you institute a rule of a minimum of 10 minutes break after 60 minutes of content. This gives people a chance to go to the bathroom and get some food.

There was a two hour &#8220;lunch&#8221; break, which made sense in Pacific time as it was from 12:00-14:00 but it was from 14:00-16:00 for me, so it wasn&#8217;t so useful. I&#8217;m all for a mid-content break, but this was _really_ long, and I would&#8217;ve just preferred it to be shorter so we could finish earlier. A 30-60 minute break would&#8217;ve been better. But neither of these scheduling issues were a big deal, just small things I&#8217;d like to see changed if next year&#8217;s conference is virtual as well.

And now some brief writeups on each of the presentations &#8230;

## [Rust for Non-Systems Programmers &#8211; Rebecca Turner][1]

This wasn&#8217;t the first talk but I&#8217;m covering it first because it should have been earlier on the schedule. This is a great intro to Rust for those new to the language, covering many language constructs, error handling, writing simple CLI apps, using REST APIs, and more. I highly recommend this if you&#8217;re new to Rust and want to learn more. **If you&#8217;re totally new to Rust and want to get a quick overview of it then watch this talk!**

## [Opening Keynote &#8211; Rust People][2]

I&#8217;m not sure if all the presenters were part of the Core Team, or exactly how Rust is organized. Suffice it to say that all of the presenters are involved in Rust development and/or the community. The keynote mostly talked about Rust as a project and community, and was more on Rust&#8217;s values, especially community values. I think it was a good opening since Rust has really positive community values. I hope that made all the attendees feel welcome.

## [Error Handling Isn&#8217;t All About Errors &#8211; Jane Lusby][3]

This was my favorite talk overall, with great technical info, excellent slides, and a very polished presenter. Jane talked about the difference between errors, error context, and error reporters, which was really interesting. Rust makes this a bit more explicit than many other languages, especially if you use some of the really nice crates she covered. **I highly recommend watching this even if you have no interest in Rust**! I&#8217;ve been using [anyhow][4] and [thiserror][5] myself, but she introduced [eyre][6], a fork of anyhow that looks really nice. Plus it&#8217;s a funny joke on multiple levels.

## [How to Start a Solo Project that You’ll Stick With &#8211; Harry Bachrach][7]

This was more of a psychology talk than a technical one, but it was pretty interesting. That said, my way of dealing with my side projects is quite different from theirs. If you struggle with your own side projects, or are just generally interested in psychology, this is worth checking out.

## [Under a Microscope: Exploring Fast and Safe Rust for Biology &#8211; Samuel Lim][8]

I have less to say about this talk than the others. I just can&#8217;t get very excited about scienitific programming topics for some reason, but that&#8217;s no dig against the talk or the speaker. The most interesting parts for me was when he talked about using Rust as part of the toolchain for some very big data analysis.

## [Bending the Curve: A Personal Tutor at Your Fingertips &#8211; Esteban Kuber][9]

This was a really great talk about how the Rust compiler is designed to teach you how to code in Rust. The compiler&#8217;s error messages are one of my favorite things about Rust coding. The only other language I&#8217;ve seen that does this as well is [Raku][10], and they got there first. I did plug Raku a bit in chat. I suspect the two communities could get some good error message ideas from each other.

## [My First Rust Project: Creating a Roguelike with Amethyst &#8211; Micah Tigley][11]

Now we&#8217;re talking! I&#8217;ve actually considered trying to create a roguelike inspired by [Cataclysm: Dark Days Ahead][12] in Rust. I enjoyed learning about Micah&#8217;s use of [Amethyst][13]. She talked about various aspects of it, including it&#8217;s animation system and how that plugs into its overall event loop. If I do decide to work on a roguelike I&#8217;ll be checking out Amethyst.

## [Controlling Telescope Hardware with Rust &#8211; Ashley Hauck][14]

This was more about the hardware and image processing than the science. There were some interesting points about working with low-level interfaces (serial ports), image processing (math I didn&#8217;t understand), and using threads to separate controlling hardware from the UI to ensure responsiveness. If you&#8217;re a hardware hacker I recommend this talk, but there&#8217;s enough general content for anyone interested in Rust.

## [Macros for a More Productive Rust &#8211; jam1garner][15]

This was a deep technical dive into how macros in Rust work. The short summary is that they&#8217;re **extremely** powerful. I couldn&#8217;t help but think of Raku and it&#8217;s goal of making slangs possible. I learned a lot about the Rust macro system, and the talk ended with some programming madness that I think even Damian Conway might envy. **I think I learned the most new technical stuff in this talk, with Jane&#8217;s as a close second.**

## [Closing Keynote &#8211; Siân Griffin][16]

I don&#8217;t want to say too much about this talk, because that would ruin the fun of it. Suffice it to say that it was both incredibly entertaining and informative, while making a strong case for the benefits of a language that prioritizes safety and correctness along with performance. **If you only watch one talk from the conference it should be this one.**

Thank you to the RustConf organizers and presenters for your hard work! This was clearly a labor of love, much like the Perl Conference. It&#8217;s amazing how much work people will put in for a language and community they believe in.

 [1]: https://youtu.be/BBvcK_nXUEg
 [2]: https://youtu.be/IwPRu5FhfIQ
 [3]: https://youtu.be/rAF8mLI0naQ
 [4]: https://crates.io/crates/anyhow
 [5]: https://crates.io/crates/thiserror
 [6]: https://crates.io/crates/eyre
 [7]: https://youtu.be/yv6L_xmjw5I
 [8]: https://youtu.be/2b8InauuRqw
 [9]: https://youtu.be/Z6X7Ada0ugE
 [10]: https://raku.org/
 [11]: https://youtu.be/GFi_EdS_s_c
 [12]: https://cataclysmdda.org/
 [13]: https://amethyst.rs/
 [14]: https://youtu.be/xlVnp7VOxRE
 [15]: https://youtu.be/dZiWkbnaQe8
 [16]: https://youtu.be/RNsEsZbXE-4