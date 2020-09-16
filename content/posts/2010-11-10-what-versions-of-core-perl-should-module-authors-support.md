---
title: What Versions of Core Perl Should Module Authors Support?
author: Dave Rolsky
type: post
date: 2010-11-10T10:26:40+00:00
url: /2010/11/10/what-versions-of-core-perl-should-module-authors-support/
---
The new Perl 5 core release schedule raises some interesting questions for Perl module authors. In the past, major version releases of Perl were unpredictable. There were [approximately two years from 5.005 to 5.6.0][1], then another two years to 5.8.0. After that, it took a whopping five years til 5.10.0, and then about 2.5 years til 5.12.0.

However, that's all about to change. The Perl 5 core developers have moved to a timeboxed release plan, and there will be a new major version of Perl once per year. Surprisingly, this doesn't seem to mean that each release has fewer changes. Instead, the fact that you can do work on the Perl core and see it released on a predictable schedule seems to have invigorated Perl core development. Perl 5.14 will have a _lot_ of interesting new features.

In the past, I've supported 2-3 major releases of Perl for my modules. For a long time, that meant 5.6.x, 5.8.x, and 5.10.x. Since there was such a long gap from 5.8.0 to 5.10.0, I started dropping support for 5.6.x before 5.12.0 came out, and I didn't hear too much kicking and screaming.

But with once-per-year major version updates, supporting only 2-3 major Perl versions may be a problem. Perl's newly invigorated release schedule clashes with the support schedules of enterprise Linux distributions like RHEL in a big way. RHEL 5 was released in early 2007, and will be supported until 2014. RHEL 5.5 is still using Perl 5.8.8. RHEL 6, due out some time in 2011, will upgrade to Perl 5.10.1, meaning Red Hat is committing to supporting that Perl version until 2018, long after the Perl core developers have stopped supporting it.

What's a module author like myself to do?

The Moose core team discussed this recently, and we had some tentative conclusions.

First, dropping support for 5.8.x is a special case, because 5.8.x was the newest major version of Perl for a really long time (five years), longer than other major version of Perl. That means 5.8.x was the only Perl available in every major Linux distro (and probably BSD too) until very recently.

We probably want to wait until all the major distros have shipped with Perl > 5.8.x before we drop support for it. Debian and Ubuntu are already on 5.10, and RHEL 6 should be out soon. OpenSUSE lists 5.12.1 (wow, good job, OpenSUSE), it looks like FreeBSD has also moved to 5.10.1. We're making progress on the "drop 5.8.x" front. It seems reasonable to drop support for 5.8.x sometime in 2011 or 2012.

Since dropping 5.8.x support is a really big deal, we'll probably want to make a big deal out of it for Moose too, possibly doing at the same time as we bump Moose's major version number. We also want to have plenty of lead time, at least 6-12 months.

It seems unlikely that any future version of Perl 5 will ever get as solidly entrenched as 5.8.x. Given that Perl 5 is releasing a new major version each year, we can hope that end users will become more accustomed to upgrading their Perl 5 core installs on a regular basis. Realistically, I think distros and end users will probably end up skipping at least one major version between upgrades.

The Perl core team is only "committed" (I use this word loosely) to providing critical security patches for three years worth of Perl releases. In the future, that means 3 major versions of Perl at a time. That's probably a good guideline for module authors too.

Module authors, especially authors of widely used modules, should start thinking about this soon. Perl 5.14 should be out in early 2011, making it the second major version on the new release schedule. Once 5.16 comes out in 2012, I think we'll officially be in a new era of Perl 5. I hope that Moose and other major Perl modules will have a clearly defined policy for Perl version support before 5.16 comes out.

 [1]: http://search.cpan.org/perldoc?perlhist

## Comments

**Stephen, on 2010-11-10 12:26, said:**  
I think with the release of RHEL 6, 5.10.1 becomes the new baseline Perl.

**nxadm, on 2010-11-10 13:07, said:**  
Dave,

I would love to see a written "best practice" guiding new authors. Of course, this does not forbids anyone to support more Perl releases than advised.

**Devdas Bhagat, on 2010-11-10 13:31, said:**  
My rule of thumb is that enterprises will jump to alternate releases of distros/operating systems and 30 months between major releases is a good enterprise timeline.

So any distro will need about 5 years of support. RHEL6 was released today, and RHEL5 was released in 2007. So killing support for Perl 5.8.x in early 2012 would make sense.

**Ahmad M. Zawawi, on 2010-11-10 13:32, said:**  
I totally agree. A best practice support policy is a great idea to guide us. That was what I actually expected to read at the end when I started to read your interesting post. Keep them coming :)

**http://www.wgz.org/chromatic/, on 2010-11-10 16:31, said:**  
Why should Red Hat's customer-funded fetish for obsolete software dictate the level and duration of free support offered by volunteers?

App::perlbrew is a much better alternative to relying on ancient vendor Perls.

**Matthew Musgrove, on 2010-11-10 16:39, said:**  
RHEL 6.0 was released today and includes Perl 5.10.1.

<a href="http://www.redhat.com/about/news/prarchive/2010/new-standard.html" rel="nofollow ugc">http://www.redhat.com/about/news/prarchive/2010/new-standard.html</a>

<a href="http://www.redhat.com/rhel/server/details/" rel="nofollow ugc">http://www.redhat.com/rhel/server/details/</a>

**Stephen, on 2010-11-10 19:11, said:**  
Because that's what businesses will be building on. "Obsolete" is just another word for "stable".

If you don't care about business, then this whole discussion is moot. Just build the latest Perl and be done.

But in my world, I get to deal with large enterprise customers that won't let any non-vendor packages through the door - so we're pretty much required to support, at a minimum, whatever openSUSE and RHEL decide to ship with.

Hell, I still have to support RHEL \*4\*. Perl 5.8.5, anyone? (Thankfully that horror is ending soon.)

**stevenharyanto.myopenid.com, on 2010-11-10 19:16, said:**  
Luckily we mostly deploy our own servers, so at least we can choose OS and use Perl 5.10.1 from Debian stable. I understand the reluctance to drop support for 5.8.x, given the ubiquity of RHEL/CentOS. It is probably the single big reason why the world seems to be stuck at 5.8. But as chromatic said there's perlbrew now which makes it so much easier to install your own Perl. We use it on cPanel servers because we run some in-house Perl scripts to do remote backup, and we 'use 5.010' all the time because we have been spoilt rotten by 5.10 features :-)

**Dave Rolsky, on 2010-11-10 21:48, said:**  
@Stephen: My blog post was about what authors of free software should support. Red Hat isn't paying me to maintain any of my modules for the Perl they support.

I suppose if they offered I'd consider taking them up on it.

**Darren Duncan, on 2010-11-10 23:17, said:**  
In some ways I consider Perl 5.10.x to be a lame duck relatively speaking, and its like 5.12.x is what 5.10.x should have been. What I do and recommend is to lump 5.10.x together with 5.8.x. So, support 5.10.x iff you support 5.8.x, and when you drop 5.8.x, skip right to 5.12.x. Personally, I'll support minimum 5.8.x for awhile in my CPAN modules, but any applications I work on require 5.12.x. That said, I also look to what Moose does for guidance, since its a main dependency of my newest CPAN modules, and there's no point in my supporting anything that Moose doesn't support. - Darren Duncan

**nxadm, on 2010-11-11 04:44, said:**  
Solaris 10 is the newest Solaris release (until sometime end next year) and it ships Perl 5.8.4. Sun has pretty long support cycles and people seem only to upgrade for good reason (e.g. Solaris 9 never took off).

If you are serious about Perl support for your serverpark, you'll end up compiling and packaging it yourself (of get a third party pre-compiled package). But often the knowledge to compile and package software is not inhouse or, like chromatic said, you are simply not \*allowed\* to install anything besides vendor packages: it comes down to policy.

"Always in the default install" on \*n\*x is a bliss and a curse at the same time. It's true that it ties a big part of the install base to older releases, but I don't like the feel of the alternative.

**Stephen, on 2010-11-11 15:26, said:**  
_My blog post was about what authors of free software should support._

And I would hope authors would care about what platforms their end users are using - or are forced to use.

**Dave Rolsky, on 2010-11-11 19:18, said:**  
@Stephen: If your employer is willing to pay good money to Red Hat to support Perl 5.8.8 until 2014, why aren't they willing to pay module authors for support?

As long as I'm doing this work for free, you probably won't get the same extended support guarantees that Red Hat offers.

**http://www.wgz.org/chromatic/, on 2010-11-11 19:41, said:**  
I have a little garden behind my house. I grew tomatoes and blackberries this year. I grew so many, I went around the neighborhood and offered the excess to my neighbors.

One man asked if I had any watermelon or corn. "Unfortunately," I told him, "I do not."

He made a face and called me a name and said I was a horrible person for not planting crops that he liked and slammed the door in my face.

I think I'll raise tomatoes and blackberries again next year.

**Adam Kennedy, on 2010-11-11 22:54, said:**  
Oracle ships Perl 5.8.3, but it's not really a proper distro and I don't think anyone would mind if you didn't support that.

Solaris ships Perl 5.8.4, and people might get a bit iffy if you don't support that.

RHEL5 has a massive install base you really can't ignore.

Even with RHEL6 out tons of companies are stuck on RHEL5 because they can't upgrade many of their servers until vendors that make other software for RHEL5 have certified their products on RHEL6.

With Moose having reached a position where lots of companies are using it, to pull the rug out from underneath before they can complete a migration program (of which Perl is just one factor) is going to be a serious imposition.

I can tell you though, that the longest that you'll need to support RHEL5 is until RedHat stops supporting it. When vendors stop supporting products, you can bet you ass most companies are scrambling to finish upgrade compliance.

Since it could take up to a year for some vendors to certify products on RHEL6, and another year to plan major upgrade programs, I'd say you need to support 5.8.8 at a minimum until at least Christmas 2012. And then re-evaluate then based on RedHat's distro penetration statistics.

But why, may I ask, would you need any Perl newer than 5.8.5 (where unicode got fully stable). What utterly essential feature do you need that would justify making Moose, several thousand other CPAN modules, and every program written using any of those several thousand modules unusable on one of the biggest Linux platforms in the world?

**Dave Rolsky, on 2010-11-11 23:03, said:**  
@Adam: Moose hasn't officially supported anything before 5.8.5 for a while, and by officially I mean "I don't think any core developer tests on anything earlier than 5.8.5".

However, my post was about more than just Moose. I maintain a lot of modules, as you know. I just used a discussion the Moose core devs had as a jumping off point for the blog entry.

As I've said in response to others, I don't really feel bound to honor Red Hat's support commitments, especially since they get paid for it and I don't. If Red Hat or some RH user wants to hire me to provide the same level of support for my Perl modules, that'd be great!

What features might justify dropping 5.8? I'm not really sure. I can, for example, easily imagine a module where named regex captures made it much easier to write.

Also, I'm not sure what you mean by "pull the rug out from underneath". It's not like dropping support for 5.8.x at a certain point wipes out all the old released versions, nor does it prevent someone from backporting newer releases if they really want to. Sure, it's a pain, but I imagine using a 5-7 year old distro is also a pain, and apparently that's a pain worth suffering.

**Peter Rabbitson, on 2010-11-12 11:46, said:**  
@autarch So to rephrase Adam: What utterly essential feature* do you need (or in fact does exist) post-perl-5.8.5 that would justify switching any of the many modules you maintain to a higher minimum version?

It is a real honest question

\* To frame the discussion properly: //= and given/when do not even \*approach* the status of features. The question focuses on real, hard/expensive to work around problems.

**Iñigo, on 2010-12-12 07:32, said:**  
IMHO (not an author):

Any software should support the lower version that does not break things.

Open-Source is not like only enterprise view.

Perl does not need to imitate java/python/ruby breakages, backward incompatible enterprise changes, etc.

Also, sometimes is possible to add logic, to run one code for one version and other code for others.

And also, some (O.S.) distributions could change long term support options... like shipping perl-release (does not change major versions during life cycle), perl-latest, and perl-specific\_version\_here... or perl-system\_wide and perl\_by_user... etc.. the tools and source is available, they only need some human power... and changes.

Greetings :)