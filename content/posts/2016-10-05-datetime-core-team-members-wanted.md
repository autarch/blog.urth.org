---
title: DateTime Core Team Members Wanted
author: Dave Rolsky
type: post
date: 2016-10-05T20:58:36+00:00
url: /2016/10/05/datetime-core-team-members-wanted/
---
I've been thinking about DateTime recently and I've come to the conclusion that the Perl community would be much better off if there was a DateTime core team maintaining the core DateTime modules. DateTime.pm, the main module, is used by several thousand other CPAN distros, either directly or indirectly. Changes to DateTime.pm (or anything that it in turn relies on) have a huge impact on CPAN.

I've been maintaining DateTime.pm, DateTime::Locale, and DateTime::TimeZone as a mostly solo effort for a long time, but that's not a good thing. The main thing I'd like from other team members is a commitment to review PRs on a regular basis. I think that having some sort of code review on changes I propose would be very helpful. Of course, if you're willing to respond to bugs, write code, do releases, and so on, that's even better.

Please comment on this blog post if you're interested in this. Some things to think about include ...

  * What sort of work are you comfortable doing? The work includes code review, responding to bug reports, writing code to fix bugs and/or add features, testing on platforms not supported by Travis, and doing releases.
  * How would you like to communicate about these things? There is an existing datetime@perl.org list, but I generally prefer IRC or Slack for code discussion.
  * Would you prefer to use GH issues instead of RT? (I'm somewhat leaning towards yes, but I'm okay with leaving things in RT too)?

The same request for maintenance help really applies to anything else I maintain that is widely used, including Params::Validate (which I'm no longer planning to use in new code myself) and Log::Dispatch. I'd really love to have more help maintaining all of this stuff.

If you have something to say that you're not comfortable saying in a comment, feel free to [email me][1].

 [1]: mailto:autarch@urth.org

## Comments

**Doug Bell (preaction), on 2016-10-05 17:00, said:**  
I'm the maintainer of Log-Any now, so I'd love to see a Perl-Log Github organization that included both Log-Any and Log-Dispatch, and am willing to put time into Log-Dispatch.

I'm also willing to be a maintainer of DateTime. I can do help do PR reviews, triage, bugfixes, and releases. My preference would be IRC+email for communication and Github for project tracking.

**Daniel, on 2016-10-05 17:53, said:**  
I'd be interested in helping any way I can. Haven't done much in terms of open source contribution but I have a little bit of perl experience. 

I'd be happy to help with bug fixes and responding to issues, etc...

I like slack and would vote for GH.

Cheers.

**Alex Balhatchet (KAORU), on 2016-10-06 01:18, said:**  
I'm interested in this. Trying to handle daylight savings in PHP in my day job this year has given me a newfound appreciation for DateTime.pm!

I'd be up for doing all the things you listed: looking at bugs and PRs, writing code, testing and releasing.

IRC, Slack or Mailing List are all good for me with a slight preference for email for the sake of good unread statuses and threading. Also prefer GitHub issues over RT.

I'm a long time DateTime.pm user based in London, UK, with years of Perl experience and several CPAN modules. That said I would definitely need to learn a lot more about the internals and DateTimes in general to be able to contribute high quality code.

**Andrew, on 2016-10-06 02:45, said:**  
I'll throw my hat in. I haven't been too active in the perl world lately but I'm trying to stay in touch. I've got a few dists to my name and I've helped out with a few other big projects over the years. I wouldn't be a super active driving exciting new features kind of maintainer, but bugfixes, code review, releng, and helping folks out on IRC/SO are up my alley.

- IRC:hobbs, CPAN:ARODLAND

**Andrew, on 2016-10-06 03:03, said:**  
I like IRC and Slack; it's hard to get people to participate on mailing lists these days — including me, to be honest. Slack is kind of a nice middle ground since it's real-time but not as ephemeral as IRC.

I like GitHub for issue tracking etc. It's not a perfect system but it's less of a pain to work with than RT in my opinion, and with the addition of Projects and Reviews they seem committed to adding potentially valuable workflow stuff.

**JC Zeus, on 2016-10-06 03:49, said:**  
It's been some time I contributed to CPAN. Would do code reviews.

**Jeff Boes, on 2016-10-06 05:47, said:**  
I'm a long-time Perl programmer, but haven't contributed much at all to the open source community. I have time on my hands right now (laid off at the end of September, searching for another job).

**Dominic, on 2016-10-07 10:05, said:**  
I'd be happy to help

**Mohit Chawla, on 2016-10-07 11:58, said:**  
I would like to help in responding to bug reports, and if I can, contribute to the code base. I recently worked on a few perl.org projects as well.

**Mohammad S Anwar, on 2016-10-07 18:23, said:**  
I would be more than happy to contribute in any of the above listed roles. I have recently adopted PDF::Create, XML::XPath and many more. I am currently looking to get my hand dirty in relative bigger projects.

**Omid Houshyar, on 2016-10-07 21:13, said:**  
I'll be more than happy to help.

I prefer to use GitHub.

**Jay Hannah, on 2016-10-12 14:38, said:**  
Hey Dave, I'd be happy to do work PRs, fix bugs, write code, do releases, and so on. Maxed at ~10 hours/month, probably. I prefer Slack, github.

**Bill Ricker, on 2016-10-12 19:55, said:**  
I guess i should join the <datetime@perl.org>. I use DateTime a lot and dealt with the joy of DST change last decade. 

Definitely comfortable with code reviews. Running behind on bug fixes for my own module so while i'd like to i can't promise fixes or releases :-( . Documentation patches yes. Responding to bug reports, i've been doing that on the Ack mailing list and GH.

i usually have Pidgin running on desktop and Slack on Tablet so can add an IRC or a Slack tab one or both places, so either is ok with me. (For those who strongly prefer IRC, note that one can subscribe to Slack via their XMPP gateway with any client with that protocol, but not all features work perfectly. They do fix at least some XMPP bugs.) OTOH, timeshift dscussions via email are good too.

On different projects i use both GH issues and CPAN RT. CPAN RT feels clunky in comparison but it works. Each is tied to something it's good to tie to. For this it may be worth the effort of moving; it hasn't been for Config::Std , that is still on RT and likely to remain so.

(I'm PAUSE=BRICKER , N1VUX elsewhere )

**Jay Hannah, on 2016-10-13 11:01, said:**  
Hmm, did I join the wrong mailing list for these questions?

<a href="http://www.nntp.perl.org/group/perl.datetime/2016/10.html" rel="nofollow ugc">http://www.nntp.perl.org/group/perl.datetime/2016/10.html</a>