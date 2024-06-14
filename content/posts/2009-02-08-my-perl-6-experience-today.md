---
title: My Perl 6 Experience Today
author: Dave Rolsky
type: post
date: 2009-02-08T21:25:10+00:00
url: /2009/02/08/my-perl-6-experience-today/
---

I decided to give Perl 6 a go today at the Frozen Perl Hackathon. It was a great opportunity because
I had Patrick Michaud sitting across the table from me, and I was able pick his brain both about
Perl and the Rakudo/Parrot issues I was seeing.

The last time I looked at Perl 6 was about 2.5 years ago, when Pugs was still active. I started
working on some DateTime code, but didn't get too far because of various missing features.

Perl 6 is a really cool language, at least the parts I've played with. However, I still had trouble
figuring out how to do what I wanted for a couple reasons. First, there's no up to date
comprehensive user documentation. The synopses (basically the Perl 6 language spec) are readable,
but not really user-level docs. Second, there's not a huge body of existing libraries, apps, and
one-liners like there is with Perl 5. Because Rakudo doesn't yet support the full Perl 6 language,
the Perl 6 code that does exist is often not coded in the most natural way.

I encountered a few barriers to getting going with Perl 6. First, there is the documentation issue.
Rakudo doesn't support all of Perl 6 yet. Because Rakudo does not yet support all of Perl 6, and
because I am pretty much a Perl 6 noob, it's very hard for me to distinguish between "not supported"
and "incorrect code". This is further compounded by the fact that Rakudo's error reporting is very
rough.

I think if I had more than a few hours to devote to this, I could probably pick it up pretty
quickly. A few days hacking on Perl 6 with blead Rakudo woud give me a better idea of how to
interpret Rakudo's error messages, and a better sense of what parts of Perl 6 are actually
supported.

For now I'm too busy to put the time in. I've got my existing Perl 5 projects, animal rights
activism, and rocking Rock Band to do.

I'll probably come back to Rakudo in a few months and try again, maybe at YAPC. I'll be less busy
then, and I expect that Rakudo will continue to advance quickly. I'm optimistic that we'll see a
Perl 6 alpha or beta in 2009, though I would be surprised to see a real 1.0 release. Of course, I'd
be thrilled to be wrong!

## Comments

**Suomynona, on 2009-02-08 23:57, said:**  
I know this isn't politically correct or even a popular sentiment, especially among the Perl elite,
but I still think Perl 6 is a disaster of epic proportions. First off, it's taken way too long.
Secondly, I don't even recognize Perl 6 code as being Perl. I can understand wiping the slate clean,
but they through out the slate, too. It's a different language entirely. Perl 5.10 is what Perl 6
should have been.

**Dave Rolsky, on 2009-02-09 00:17, said:**  
Well, this smacks of trolling, since you're anonymous, but I still approved the comment (it's not
spam, after all).

I'm not sure what "too long" means. Yes, it's taken a really long time, but so what? Perl 5 has
continued to advance, both in the core and on CPAN. Yes, Perl 6 was "announced" a long time ago, and
it's still not done, but the alternative would be having some sort of (semi-)secret project, which
would pretty much guarantee failure.

If you don't like Perl 6, that's fine, don't use it. I imagine Perl 5 will be around for a long time
to come. Once Perl 6 is out, I'm sure I'll be using both for quite some time.

As for 5.10 being what 6 should be, that's ridiculous. 5.10 has some notable features, but the
decision to never break backwards compatibility severely limited what went into 5.10.

For Perl 5, I'm more excited about things like Moose, and in the future MooseX::Declare, than 5.10
itself. CPAN is where the real exciting steps forward are happening.

**Suomynona, on 2009-02-09 01:30, said:**  
Not trolling. Just my honest opinion. Like I said, I realize it's not popular. Whenever I post
things like this, I'm usually ridiculed for being anti-change or things like that, so that's why I
posted anonymously. I was a member of the perl6-language mailing list shortly after its inception,
and I was as excited about Perl 6 as anyone at the time, but I soon became disenchanted with the
direction.

There's breaking backwards compatibility and then there's breaking backwards compatibility. I'm
perfectly fine with breaking backwards compatibility if say 95% of my code is still compatible, and
I only have to update ~5%. Perl 5.10 perhaps didn't go far enough, but Perl 6 just goes too far to
retain the name Perl.

One revision I'd make to my first posting: Perl 5.10+Moose is what Perl 6 should have been, and,
yes, I agree that CPAN is where the real crown jewels are at.

**Dave Rolsky, on 2009-02-09 12:55, said:**  
Where do you think Moose came from? It was heavily inspired by the work Stevan and Larry did on the
Perl 6 OO system. I'm not sure Moose would have existed otherwise.

Perl 6 certainly can keep the name Perl. I think the key is to realize that Perl has become less of
a language and more of "the Larry Wall family of dynamic languages". There are two languages in that
family, Perl 5, the one we know and love (and hate). Then there's the still not quite born Perl 6.

It'd be cool if we could have all the goodies in Perl 6 and retain backwards compatibility, but I'd
rather have the goodies.

Also, keep in mind that if someone were to write a Perl 5 on Parrot implementation, that would make
mixing the two languages much easier. I'm sure patches are welcome (yes, I know this is a huge
task).

**mateu, on 2009-02-09 19:00, said:**  
ego: I want to unwrap the shiny silcone Perl 6 package.

id: What is really in a number?

super-ego: A major number shift implies a major mental shift.

ego: It feels like just getting one major bump in perl is a bi-decadal event.

id: What is the width of time?

ego: fuck u id.

super-ego: If Perl 5.10+Moose is what defines perl 6 then we have it now.

id: And Perl6 is really perl version &infin; - 1
