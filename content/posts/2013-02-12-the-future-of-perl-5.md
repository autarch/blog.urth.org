---
title: The Future of Perl (5)
author: Dave Rolsky
type: post
date: 2013-02-13T02:43:35+00:00
url: /2013/02/12/the-future-of-perl-5/
---

The recent discussion that started with [Ovid's Perl 7][1] blog post has me thinking about the
future of Perl, and Perl 5 in particular. We hear that Perl is dying on a regular basis, and while I
take that with a grain of salt, the fact that so many **non-Perl** people seem to believe this is
worrisome. If Perl is to have a future, it will need to attract new users.

Perl 5, as it stands, has a lot of problems. One of them is that people outside the community don't
want to learn a language that's soon going to be replaced by Perl 6. While Larry has said repeatedly
that Perl 5 and 6 are two _different_ languages in the same family, and that Perl 6 is not intended
to replace Perl 5, very few people outside the echo chamber have heard this message.

Another problem is that Perl 5 has a lot of baggage. It drags that baggage around in the name of
backwards compatibility. Perl 5's dogged commitment to backwards compatibility is, on the whole, a
good thing. However, when combined with Larry's proclamation that there will never be a successor to
_Perl 5_, we have a truly serious issue.

If it's true that Perl 5 and 6 are really two separate languages, then we need to be able to evolve
Perl 5 and 6 separately. But how can Perl 5 evolve when there's no way to develop a successor to
Perl 5? Perl 6 is not the successor, it's just a sibling.

Perl 5 is stuck with an increasingly crufty core implementation tied to an increasingly crufty set
of no-longer-correct decisions. Some of those decisions include smartmatch, [half-assed
overloading][2], no strict by default, indirect method call syntax, `->` instead of `.` for method
calls, half-assed exceptions, and many more.

It's unlikely that there will ever be a Perl **5** release which fixes all of these problems,
because there's no way to fix them without breaking back-compat. Without the option of bumping the
major version number, how can we signal that any new version is substantially different than the
last release?

Realistically, the only way to evolve Perl 5 is going to be to create a new core that implements a
Perl 5-like language. Stevan Little's [Moe][3] is one stab at a possible successor, though don't get
too excited, for now it's just an experiment.

The future of Perl 5 is, sadly, not going to be called Perl. So if you're interested in seeing a
future for Perl 5, the discussion about Perl 7 (and 6) is a distraction. Instead, figure out how to
create a new Perl 5-like language. Maybe you can [contribute to Moe][4]. Maybe you can start your
own Perl5++ prototype project. But you can't convince p5p to call perl 5.20 Perl 7, and you can't
rename Perl 6.

I'm sad that it's come to this. Perl 6 should have been renamed years ago to preserve the health of
the Perl 5 community. I've seen many people say that this is solely Larry's decision, but that's
just wrong. A lot of people have invested a lot of time and effort in Perl 5, and those people count
too. I don't think their interests have been taken into account.

Of course, I look forward to being proved entirely wrong when a production-ready Perl 6 is released
this Christmas and the entire Perl community moves as one to embrace it.

[1]: http://blogs.perl.org/users/ovid/2013/02/perl-7.html
[2]: /whats-wrong-with-perl-5s-overloading
[3]: http://moeorganization.github.com/moe-web/
[4]: https://github.com/MoeOrganization/moe

## Comments

**Michael Peters, on 2013-02-13 08:18, said:**  
I had making a comment that just says "I agree", but I'm not sure I have much more to add than that.
This is spot on exactly how I feel.

**Robert, on 2013-02-14 08:33, said:**  
Perl 5.X should just go into maintenance mode.

We should not give up the name Perl. That would be ludicrous. It has been suggested to use a year
naming scheme for the version and I think that is brilliant. The announcement could be made well in
advance and often that "Perl 2014.01 will break shit". Those who are already in the Perl community
will here it more than once that "Perl 2014.01 will break shit" and to stay on Perl5 if they don't
want to deal with that. All the breakage, darkpan, back compatibility arguments just go away because
"Perl 2014.01 will break shit".  Anyone just coming into Perl won't care because Perl 2014.01 will
be their first learning experience with Perl. You solve the social aspect, the naming aspect, the
future growth aspect, and the backwards compatibility aspect all in one sweep.

**Tom Nish, on 2013-02-14 20:39, said:**  
Why must Perl 5 be so backwards compatible?  Do we actually have reliable studies saying that there
are a significant number of users who haven't updated their code for 10 years _and_ insist that it
still work on the most recent version of Perl 5?  More importantly, do these people fund development
or at least make their opinions heard?  We should allow these dinosaurs either pay their distro
vendor for support (RHEL 5, which shipped with 5.8, will be supported until 2020!) or maintain their
own version somehow.
