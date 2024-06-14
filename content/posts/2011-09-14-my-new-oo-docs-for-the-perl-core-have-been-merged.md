---
title: My New OO Docs for the Perl Core Have Been Merged
author: Dave Rolsky
type: post
date: 2011-09-14T18:59:19+00:00
url: /2011/09/14/my-new-oo-docs-for-the-perl-core-have-been-merged/
---

Back in March, I mentioned that I was [working on a new OO tutorial for the Perl 5 core][1]. I've
been working this intermittently over the last eight months or so, with lots of useful feedback from
the perl5-porters. Along the way, the project grew to include a rewrite of the perlobj document, the
reference document for Perl OO.

I'm happy to say that as of last week, all of my work has been merged into the blead branch of core,
and will be in the next release of Perl.

Here's what I did ...

We now have an entirely [new OO tutorial][2]. This tutorial has two parts. The first is an
introduction to OO _concepts_. Some people may come to Perl without a background in another OO
language, so defining basic concepts is important. This part defines these concepts in terms of how
Perl implements them, so even if the reader has some OO background, skimming this section will still
be useful.

The second half introduces three OO systems from CPAN and gives short examples of how to use each
one. In 2011, it just doesn't make any sense to tell people how to roll their own OO code in a
tutorial. The systems I wrote about are Moose, Class::Accessor, and Object::Tiny. I also mention
Role::Tiny, since roles are awesome, and you shouldn't have to use Moose to use roles.

When I merged this tutorial, I deleted all the old tutorials. Those were [perltoot (Tom's
object-oriented tutorial for perl)][3], [perltooc (Tom's OO Tutorial for Class Data in Perl)][4],
[perlboot (Beginner's Object-Oriented Tutorial)][5]. I also removed [perlbot (Bag o' Object Tricks
(the BOT))][6]. All of these were extremely outdated and contained a number of dubious
recommendations.

Don't take this as a criticism of Tom, Randal, or other people who worked hard on those docs. They
were great when they were written, but the state of the art in Perl OO has changed _a lot_ in the
past 10-15 years. If Perl 5 is still in use 10 years from now, someone will be deleting my tutorial
then!

I also revised [perlobj][7]. Some of the old content remains, but it has been rewritten, reordered,
and expanded. I hope that it is now a 100% complete reference to core Perl OO features.

If anyone reading this has any constructive feedback on these docs, I'd love to hear it. I really
want to get these new docs into excellent shape before Perl 5.16 ships in spring of 2012.

[1]: /2011/03/13/what-makes-for-a-perfect-oo-tutorial-example/
[2]: https://github.com/mirrors/perl/blob/blead/pod/perlootut.pod
[3]: http://perldoc.perl.org/perltoot.html
[4]: http://perldoc.perl.org/perltooc.html
[5]: http://perldoc.perl.org/perlboot.html
[6]: http://perldoc.perl.org/perlbot.html
[7]: https://github.com/mirrors/perl/blob/blead/pod/perlobj.pod

## Comments

**stevenharyanto.myopenid.com, on 2011-09-14 20:17, said:**  
Is Moo considered not worth mentioning? It has about the same number of CPAN distributions depending
on it as Object::Tiny, and it provides more features.

**Dave Rolsky, on 2011-09-14 20:35, said:**  
@Steven: I think Moo is still too experimental. IIRC, mst was actually the one who suggested
covering Class::Accessor and Object::Tiny in addition to Moose.

If Moo becomes a contender, it can always be given a mention later.

**Robert, on 2011-09-14 20:51, said:**  
Read it...it was good. Very cool

**Joel Berger, on 2011-09-14 23:45, said:**  
FWIW, I really like perltoot, I think it could be the most relevant old-school perl OO doc. I still
refer to it now and again. Remember Moose still builds a hashref-based object, same as in perltoot.
So possibly for no other reason than for helping to read old code, I wouls leave perltoot in. Again
what I say probably bears no weight, but what does it cost?

OTOH, thanks for writing some new docs, can't wait to read them over!

**Dave Rolsky, on 2011-09-15 00:09, said:**  
@Joel: I think that everything covered by perltoot is still covered in perlobj.

Yes, Moose builds a hashref based object, but the whole point of Moose is that you don't have to
worry about the details. Why, in 2011, would we inflict that level of detail on someone trying to
learn Perl OO for the first time?

**Alexander Hartmaier (abraxxa), on 2011-09-15 01:46, said:**  
I've just read it and found the OO module comparison very helpful, especially the examples showing
their syntaxes.  
Thanks, that's a great step forward for the Perl documentation!  
I've never understood why there are so many different docs on that topic.

**ranguard, on 2011-09-15 02:55, said:**  
Fantastic - thanks so much for this

**Nigel Metheringham, on 2011-09-15 04:18, said:**  
Hi,

Read the tutorial - good stuff.

Found a typo - have fixed and sent pull request on github, however if you want grab and merge that
more directly, its at  
<https://github.com/nigelm/perl/commit/dc8de09b826f16289322647b89659b0a997e292a>

**Dave Rolsky, on 2011-09-15 09:00, said:**  
@Nigel: We don't actually use github to manage Perl. See the perlhack for docs on how to submit
patches.

I just linked to github because they format the pod nicely.

**Peter Sergeant, on 2011-09-15 10:20, said:**  
I haven't checked, but have you left stubs in those places? I imagine there are many places that
refer people to 'perldoc perlboot' or 'perldoc perltoot', and it'd be a shame if they weren't
updated to point somewhere new...

**pdonelan.myopenid.com, on 2011-09-15 15:25, said:**  
So awesome that you took the time to do this.

**Mark Stosberg, on 2011-09-15 22:09, said:**  
Thanks!

**Satish, on 2011-09-23 13:43, said:**  
Hi,

Thanks for such a great work!!!!

**hanekomu, on 2011-10-04 06:33, said:**  
Very nice work! I also thought having so many OO docs was confusing.

I wonder about the inclusion of Role::Tiny, because that's part of Moo, which, as you say, is still
experimental.

How about including Role::Basic instead? There, the idea of a role really lives on its own. Just for
reference, I've used Role::Basic as the core of Brickyard, a role-based plugin system I wrote for a
fair-sized application at work (domain name registry).

Anyway, thank you!
