---
title: Changes File How-(and How-Not-)To
author: Dave Rolsky
type: post
date: 2011-01-27T09:26:53+00:00
url: /2011/01/27/changes-file-how-and-how-not-to/
categories:
  - Uncategorized

---
Every software release should come with a list of changes that are present in that release. What goes in this list depends on your audience. Let&#8217;s consider a changes file for a module released on CPAN.

For a CPAN module, the audience is other developers. Some of the readers have used this module before, and want to know what&#8217;s new. Other readers haven&#8217;t used this module, and want to know if the changes in this release will change their minds.

Before we get to the how-to, let&#8217;s take a particularly poor example, the [Changes file from the Dancer project][1].

(Note: I&#8217;ve got nothing against Dancer, and the devs I&#8217;ve talked to in the project all seem to be nice people, but their changes file really is egregiously bad.)

First problem, no release dates. Release dates are really important. They help people see what the development velocity for the project is. There is no excuse for not putting them in your changes file.

(And remember, it&#8217;s a release _date_, not a release _timestamp_. No one cares that you released the module at 07:23:52 GMT.)

However, there is an even bigger problem, which is that the organization of the changes file is completely and utterly arbitrary. They&#8217;ve listed changes _by author_. This is meaningless to readers.

(I&#8217;m all for crediting each contributor, but that should go at the _end_ of each individual change description.)

The changes in a changes file should be grouped in some way that helps readers understand the nature of each change. Ideally, the most important stuff comes first, and least important comes last.

The Dancer changes file has as its second change &#8220;turned a tab into the right number of spaces&#8221;. Who cares? Does this affect _anyone_ using the code? No.

Overall, the Dancer file has a number of changes listed which no one will care about, like fixing typos in pod. There&#8217;s no reason to mention this sort of thing unless the typo in question was a factual error or broken code. If it was just a spelling error, no one really cares.

So there&#8217;s no release dates, no useful ordering of changes, and some of the changes are completely unimportant, obscuring the useful information. I give this changes file an F.

For an example of a good changes file, look at [Moose][2].

We separate changes into broad categories that help our readers. The categories are &#8220;API CHANGES&#8221;, &#8220;NEW FEATURES&#8221;, &#8220;ENHANCEMENTS&#8221;, &#8220;BUG FIXES&#8221;, and occasionally &#8220;OTHER&#8221;. These categories are always presented in that order.

The most imporant part of the ordering is that API changes (anything which breaks backwards compatibility) are _always_ listed first. The order of the next three is debatable, but that matters less. What&#8217;s important is that we break them down into useful categories. If you&#8217;re a Moose user who&#8217;s been waiting for a specific bug fix, it&#8217;s easy to figure out whether the new release fixes that bug.

Prior to 0.93_01, Moose&#8217;s changes file wasn&#8217;t so great. Changes were listed by the package they affected, which is pretty useless. Moose has a _lot_ of modules, and most of them aren&#8217;t exposed to the end user. Knowing that a bug was fixed in `Moose::Meta::Role::Application::ToRole` doesn&#8217;t really help anyone.

If you&#8217;re a CPAN author, please think of your intended audience when you write your Changes file. Put the most important stuff first. If you want to break the file down into sections, do that based on something the reader cares about. And don&#8217;t forget your release dates!

 [1]: https://metacpan.org/changes/release/SUKRIA/Dancer-1.3001
 [2]: https://metacpan.org/changes/release/DROLSKY/Moose-1.21

## Comments

### Comment by http://oid.fox.geek.nz/kent.fredric on 2011-01-27 10:31:35 -0600
Lastly, but certainly not leastly, don&#8217;t be lazy and just copy the output from &#8220;git log&#8221; into your Changelog. If we wanted the git log, we&#8217;d check out the repository, and git log ourself. 

Changes should **SUMMARISE** changes.

Not like this: <a href="http://cpansearch.perl.org/src/CHM/PDL-2.4.7/Changes" rel="nofollow">PDL-2.4.7 Changes</a>

I mean, between 2.4.7 and 2.4.7_008 there were <a href="https://gist.github.com/798736" rel="nofollow">1300 lines of difference added to the Changes file!</a>. No human wants to read that.

### Comment by Dave Rolsky on 2011-01-27 10:35:09 -0600
@kent: Abso-freaking-lutely. I didn&#8217;t mention that sort of abomination because I was too busy picking on poor Dancer ;)

### Comment by outsider on 2011-01-27 12:00:26 -0600
maybe it is due to one of the following reason, which I am sure you have used before (I&#8217;m sure they accept patches)  
&#8211; Its a volunteer project and they are happy to just share their code  
&#8211; Their users have not complained, you don&#8217;t use it but still seem to have a problem  
&#8211; Why did you not submit a ticket for that

### Comment by rjbs.manxome.org on 2011-01-27 12:48:48 -0600
&#8230;and put the latest release at the TOP of the file. Order the file in REVERSE chronological order. Nobody wants to wait for the whole file to load just so he can hit &#8220;end&#8221; and then &#8220;page up&#8221; to find the top of the most recent section.

### Comment by Dave Rolsky on 2011-01-27 13:24:52 -0600
@anon: Why didn&#8217;t I file a ticket? I&#8217;m not sure this needs a ticket. It&#8217;s not a bug. It&#8217;s a criticism.

This really isn&#8217;t specific to Dancer, that was just one example. There are many projects which have bad changes files.

Also, note that I said changes files are both for current users and prospective users. I&#8217;m sure I fall into the latter category for Dancer.

### Comment by arun prasaad on 2011-01-27 14:49:58 -0600
Are there any tools that can help with automatically building the change log?

### Comment by Ron Savage on 2011-01-27 16:44:40 -0600
Hi Arun

Module::Metadata::Changes helps manage a CHANGES file by inputting it and outputting a machine-readable Changelog.ini.

<a href="http://search.cpan.org/~rsavage/Module-Metadata-Changes-1.08/" rel="nofollow ugc">http://search.cpan.org/~rsavage/Module-Metadata-Changes-1.08/</a>

### Comment by Alexander Hartmaier (abraxxa) on 2011-01-27 16:58:26 -0600
I&#8217;d love to see a standardized Changes file (some dists even use a different filename) which is parsable so CPAN Clients could not only list the installed vs. newest version per dist but also the Changes inbetween the two.  
cpanp o, z 1, vi C, read, :q, exit, i 1, repeat from beginning is really annoying&#8230;

### Comment by Jeremy Leader on 2011-01-27 17:45:52 -0600
arun, you can google for &#8220;$your\_scm\_tool\_of\_choice to changelong&#8221;. Keep in mind Dave&#8217;s point that the output of such a tool should be used as input, from which you manually generate a more succinct summary intended for people outside the project.

scm change logs are aimed at other people working on the code. A project&#8217;s changes file should be aimed at people using or thinking about using the code.

I suppose there may be machine-learning approaches that could automate the summarization of coder change notes into user change descriptions, but I haven&#8217;t seen any.

### Comment by stevenharyanto.myopenid.com on 2011-01-27 19:15:54 -0600
My Changes are already pretty good, I&#8217;d say between B to B+ were Dave to score them. A lot of my projects are just small CPAN modules which doesn&#8217;t need categorization. Of the rest which do, I usually write the entries like this:

* [new] &#8230;

* [new] &#8230;

* [enhanced] &#8230;

* [removed] &#8230;

* [removed] &#8230;

Reading them again just now, turns out that&#8217;s not as readable/pretty as Moose&#8217;s. So from now on I&#8217;m going to do it like Moose&#8217;s. Thanks.

### Comment by mateu.myopenid.com on 2011-01-28 09:41:39 -0600
I think the Moose Changes file is pretty well styled, but I&#8217;d make it better (opinionated obviously) by removing the line feeds except between releases, and drop the day of the week from the release date. In addition, I&#8217;d put FIXES at the top and API changes 2nd (or vice versa) but definitely move FIXES up in priority.

### Comment by Olivier Mengué (dolmen) on 2011-02-06 11:39:42 -0600
@abraxxa: I agree with you. Changeslog should be parseable.

Why? Because it would be useful to parse them to publish them as other formats.  
As Dave wrote, &#8220;Some of the readers [&#8230;] want to know what&#8217;s new.&#8221;. What is the current Internet standard to publish &#8220;what&#8217;s new&#8221;? RSS!

I&#8217;ve started a few month ago to publish a ChangeLog of one of my distributions also as RSS: the (Module::Build based) dist build process uses RegExp::Grammar to create a Changes.rss which is included in the published archive.  
<a href="http://cpansearch.perl.org/src/DOLMEN/POE-Component-Schedule-0.95/Changes" rel="nofollow ugc">http://cpansearch.perl.org/src/DOLMEN/POE-Component-Schedule-0.95/Changes</a>  
<a href="http://cpansearch.perl.org/src/DOLMEN/POE-Component-Schedule-0.95/Changes.rss" rel="nofollow ugc">http://cpansearch.perl.org/src/DOLMEN/POE-Component-Schedule-0.95/Changes.rss</a>  
The problem now is to automatically publish this RSS with a dist-version independent URL. Search.cpan.org does not do it. Yet?

### Comment by Olivier Mengué (dolmen) on 2011-02-06 12:04:27 -0600
@Dave: I would have filled a ticket.

The ticketing system is the best place to report any usability issues about the module, and a low quality ChangeLog is an important usability issue in my point of view.  
Any improvement idea should be submitted as a ticket, as &#8220;wishlist&#8221; at least.

I&#8217;m now used to see module authors ignore such tickets (see list below) but sometimes they get an answer and CPAN improves.  
<a href="https://rt.cpan.org/Public/Bug/Display.html?id=46913" rel="nofollow ugc">https://rt.cpan.org/Public/Bug/Display.html?id=46913</a>  
<a href="https://rt.cpan.org/Public/Bug/Display.html?id=55522" rel="nofollow ugc">https://rt.cpan.org/Public/Bug/Display.html?id=55522</a>  
<a href="https://rt.cpan.org/Public/Bug/Display.html?id=62480" rel="nofollow ugc">https://rt.cpan.org/Public/Bug/Display.html?id=62480</a>

### Comment by Dave Rolsky on 2011-02-06 16:45:51 -0600
@Olivier: Tickets are useful too, but this post was only incidentally about Dancer. Plus I&#8217;ve seen a lot of good discussion and momentum after this post. Dancer has improved their Changes file, Brian Cassidy wrote the CPAN::Changes module, and I suspect other module authors will read this too.