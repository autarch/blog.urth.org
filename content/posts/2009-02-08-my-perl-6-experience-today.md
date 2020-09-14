---
title: My Perl 6 Experience Today
author: Dave Rolsky
type: post
date: 2009-02-08T21:25:10+00:00
url: /2009/02/08/my-perl-6-experience-today/
categories:
  - Uncategorized

---
I decided to give Perl 6 a go today at the Frozen Perl Hackathon. It was a great opportunity because I had Patrick Michaud sitting across the table from me, and I was able pick his brain both about Perl and the Rakudo/Parrot issues I was seeing.

The last time I looked at Perl 6 was about 2.5 years ago, when Pugs was still active. I started working on some DateTime code, but didn&#8217;t get too far because of various missing features.

Perl 6 is a really cool language, at least the parts I&#8217;ve played with. However, I still had trouble figuring out how to do what I wanted for a couple reasons. First, there&#8217;s no up to date comprehensive user documentation. The synopses (basically the Perl 6 language spec) are readable, but not really user-level docs. Second, there&#8217;s not a huge body of existing libraries, apps, and one-liners like there is with Perl 5. Because Rakudo doesn&#8217;t yet support the full Perl 6 language, the Perl 6 code that does exist is often not coded in the most natural way.

I encountered a few barriers to getting going with Perl 6. First, there is the documentation issue. Rakudo doesn&#8217;t support all of Perl 6 yet. Because Rakudo does not yet support all of Perl 6, and because I am pretty much a Perl 6 noob, it&#8217;s very hard for me to distinguish between &#8220;not supported&#8221; and &#8220;incorrect code&#8221;. This is further compounded by the fact that Rakudo&#8217;s error reporting is very rough.

I think if I had more than a few hours to devote to this, I could probably pick it up pretty quickly. A few days hacking on Perl 6 with blead Rakudo woud give me a better idea of how to interpret Rakudo&#8217;s error messages, and a better sense of what parts of Perl 6 are actually supported.

For now I&#8217;m too busy to put the time in. I&#8217;ve got my existing Perl 5 projects, animal rights activism, and rocking Rock Band to do.

I&#8217;ll probably come back to Rakudo in a few months and try again, maybe at YAPC. I&#8217;ll be less busy then, and I expect that Rakudo will continue to advance quickly. I&#8217;m optimistic that we&#8217;ll see a Perl 6 alpha or beta in 2009, though I would be surprised to see a real 1.0 release. Of course, I&#8217;d be thrilled to be wrong!

## Comments

### Comment by Suomynona on 2009-02-08 23:57:11 -0600
I know this isn&#8217;t politically correct or even a popular sentiment, especially among the Perl elite, but I still think Perl 6 is a disaster of epic proportions. First off, it&#8217;s taken way too long. Secondly, I don&#8217;t even recognize Perl 6 code as being Perl. I can understand wiping the slate clean, but they through out the slate, too. It&#8217;s a different language entirely. Perl 5.10 is what Perl 6 should have been.

### Comment by Dave Rolsky on 2009-02-09 00:17:48 -0600
Well, this smacks of trolling, since you&#8217;re anonymous, but I still approved the comment (it&#8217;s not spam, after all).

I&#8217;m not sure what &#8220;too long&#8221; means. Yes, it&#8217;s taken a really long time, but so what? Perl 5 has continued to advance, both in the core and on CPAN. Yes, Perl 6 was &#8220;announced&#8221; a long time ago, and it&#8217;s still not done, but the alternative would be having some sort of (semi-)secret project, which would pretty much guarantee failure.

If you don&#8217;t like Perl 6, that&#8217;s fine, don&#8217;t use it. I imagine Perl 5 will be around for a long time to come. Once Perl 6 is out, I&#8217;m sure I&#8217;ll be using both for quite some time.

As for 5.10 being what 6 should be, that&#8217;s ridiculous. 5.10 has some notable features, but the decision to never break backwards compatibility severely limited what went into 5.10.

For Perl 5, I&#8217;m more excited about things like Moose, and in the future MooseX::Declare, than 5.10 itself. CPAN is where the real exciting steps forward are happening.

### Comment by Suomynona on 2009-02-09 01:30:02 -0600
Not trolling. Just my honest opinion. Like I said, I realize it&#8217;s not popular. Whenever I post things like this, I&#8217;m usually ridiculed for being anti-change or things like that, so that&#8217;s why I posted anonymously. I was a member of the perl6-language mailing list shortly after its inception, and I was as excited about Perl 6 as anyone at the time, but I soon became disenchanted with the direction.

There&#8217;s breaking backwards compatibility and then there&#8217;s breaking backwards compatibility. I&#8217;m perfectly fine with breaking backwards compatibility if say 95% of my code is still compatible, and I only have to update ~5%. Perl 5.10 perhaps didn&#8217;t go far enough, but Perl 6 just goes too far to retain the name Perl.

One revision I&#8217;d make to my first posting: Perl 5.10+Moose is what Perl 6 should have been, and, yes, I agree that CPAN is where the real crown jewels are at.

### Comment by Dave Rolsky on 2009-02-09 12:55:14 -0600
Where do you think Moose came from? It was heavily inspired by the work Stevan and Larry did on the Perl 6 OO system. I&#8217;m not sure Moose would have existed otherwise.

Perl 6 certainly can keep the name Perl. I think the key is to realize that Perl has become less of a language and more of &#8220;the Larry Wall family of dynamic languages&#8221;. There are two languages in that family, Perl 5, the one we know and love (and hate). Then there&#8217;s the still not quite born Perl 6.

It&#8217;d be cool if we could have all the goodies in Perl 6 and retain backwards compatibility, but I&#8217;d rather have the goodies.

Also, keep in mind that if someone were to write a Perl 5 on Parrot implementation, that would make mixing the two languages much easier. I&#8217;m sure patches are welcome (yes, I know this is a huge task).

### Comment by mateu on 2009-02-09 19:00:41 -0600
ego: I want to unwrap the shiny silcone Perl 6 package.

id: What is really in a number?

super-ego: A major number shift implies a major mental shift.

ego: It feels like just getting one major bump in perl is a bi-decadal event.

id: What is the width of time?

ego: fuck u id.

super-ego: If Perl 5.10+Moose is what defines perl 6 then we have it now.

id: And Perl6 is really perl version &infin; &#8211; 1