---
title: Changes File How-(and How-Not-)To
author: Dave Rolsky
type: post
date: 2011-01-27T09:26:53+00:00
url: /2011/01/27/changes-file-how-and-how-not-to/
---
Every software release should come with a list of changes that are present in that release. What goes in this list depends on your audience. Let's consider a changes file for a module released on CPAN.

For a CPAN module, the audience is other developers. Some of the readers have used this module before, and want to know what's new. Other readers haven't used this module, and want to know if the changes in this release will change their minds.

Before we get to the how-to, let's take a particularly poor example, the [Changes file from the Dancer project][1].

(Note: I've got nothing against Dancer, and the devs I've talked to in the project all seem to be nice people, but their changes file really is egregiously bad.)

First problem, no release dates. Release dates are really important. They help people see what the development velocity for the project is. There is no excuse for not putting them in your changes file.

(And remember, it's a release _date_, not a release _timestamp_. No one cares that you released the module at 07:23:52 GMT.)

However, there is an even bigger problem, which is that the organization of the changes file is completely and utterly arbitrary. They've listed changes _by author_. This is meaningless to readers.

(I'm all for crediting each contributor, but that should go at the _end_ of each individual change description.)

The changes in a changes file should be grouped in some way that helps readers understand the nature of each change. Ideally, the most important stuff comes first, and least important comes last.

The Dancer changes file has as its second change "turned a tab into the right number of spaces". Who cares? Does this affect _anyone_ using the code? No.

Overall, the Dancer file has a number of changes listed which no one will care about, like fixing typos in pod. There's no reason to mention this sort of thing unless the typo in question was a factual error or broken code. If it was just a spelling error, no one really cares.

So there's no release dates, no useful ordering of changes, and some of the changes are completely unimportant, obscuring the useful information. I give this changes file an F.

For an example of a good changes file, look at [Moose][2].

We separate changes into broad categories that help our readers. The categories are "API CHANGES", "NEW FEATURES", "ENHANCEMENTS", "BUG FIXES", and occasionally "OTHER". These categories are always presented in that order.

The most imporant part of the ordering is that API changes (anything which breaks backwards compatibility) are _always_ listed first. The order of the next three is debatable, but that matters less. What's important is that we break them down into useful categories. If you're a Moose user who's been waiting for a specific bug fix, it's easy to figure out whether the new release fixes that bug.

Prior to 0.93_01, Moose's changes file wasn't so great. Changes were listed by the package they affected, which is pretty useless. Moose has a _lot_ of modules, and most of them aren't exposed to the end user. Knowing that a bug was fixed in `Moose::Meta::Role::Application::ToRole` doesn't really help anyone.

If you're a CPAN author, please think of your intended audience when you write your Changes file. Put the most important stuff first. If you want to break the file down into sections, do that based on something the reader cares about. And don't forget your release dates!

 [1]: https://metacpan.org/changes/release/SUKRIA/Dancer-1.3001
 [2]: https://metacpan.org/changes/release/DROLSKY/Moose-1.21

## Comments

**http://oid.fox.geek.nz/kent.fredric, on 2011-01-27 10:31, said:**  
Lastly, but certainly not leastly, don't be lazy and just copy the output from "git log" into your Changelog. If we wanted the git log, we'd check out the repository, and git log ourself. 

Changes should **SUMMARISE** changes.

Not like this: [PDL-2.4.7 Changes](http://cpansearch.perl.org/src/CHM/PDL-2.4.7/Changes)

I mean, between 2.4.7 and 2.4.7_008 there were [1300 lines of difference added to the Changes file!](https://gist.github.com/798736). No human wants to read that.

**Dave Rolsky, on 2011-01-27 10:35, said:**  
@kent: Abso-freaking-lutely. I didn't mention that sort of abomination because I was too busy picking on poor Dancer ;)

**outsider, on 2011-01-27 12:00, said:**  
maybe it is due to one of the following reason, which I am sure you have used before (I'm sure they accept patches)  
- Its a volunteer project and they are happy to just share their code  
- Their users have not complained, you don't use it but still seem to have a problem  
- Why did you not submit a ticket for that

**rjbs.manxome.org, on 2011-01-27 12:48, said:**  
...and put the latest release at the TOP of the file. Order the file in REVERSE chronological order. Nobody wants to wait for the whole file to load just so he can hit "end" and then "page up" to find the top of the most recent section.

**Dave Rolsky, on 2011-01-27 13:24, said:**  
@anon: Why didn't I file a ticket? I'm not sure this needs a ticket. It's not a bug. It's a criticism.

This really isn't specific to Dancer, that was just one example. There are many projects which have bad changes files.

Also, note that I said changes files are both for current users and prospective users. I'm sure I fall into the latter category for Dancer.

**arun prasaad, on 2011-01-27 14:49, said:**  
Are there any tools that can help with automatically building the change log?

**Ron Savage, on 2011-01-27 16:44, said:**  
Hi Arun

Module::Metadata::Changes helps manage a CHANGES file by inputting it and outputting a machine-readable Changelog.ini.

<http://search.cpan.org/~rsavage/Module-Metadata-Changes-1.08/>

**Alexander Hartmaier (abraxxa), on 2011-01-27 16:58, said:**  
I'd love to see a standardized Changes file (some dists even use a different filename) which is parsable so CPAN Clients could not only list the installed vs. newest version per dist but also the Changes inbetween the two.  
cpanp o, z 1, vi C, read, :q, exit, i 1, repeat from beginning is really annoying...

**Jeremy Leader, on 2011-01-27 17:45, said:**  
arun, you can google for "$your\_scm\_tool\_of\_choice to changelong". Keep in mind Dave's point that the output of such a tool should be used as input, from which you manually generate a more succinct summary intended for people outside the project.

scm change logs are aimed at other people working on the code. A project's changes file should be aimed at people using or thinking about using the code.

I suppose there may be machine-learning approaches that could automate the summarization of coder change notes into user change descriptions, but I haven't seen any.

**stevenharyanto.myopenid.com, on 2011-01-27 19:15, said:**  
My Changes are already pretty good, I'd say between B to B+ were Dave to score them. A lot of my projects are just small CPAN modules which doesn't need categorization. Of the rest which do, I usually write the entries like this:

* [new] ...

* [new] ...

* [enhanced] ...

* [removed] ...

* [removed] ...

Reading them again just now, turns out that's not as readable/pretty as Moose's. So from now on I'm going to do it like Moose's. Thanks.

**mateu.myopenid.com, on 2011-01-28 09:41, said:**  
I think the Moose Changes file is pretty well styled, but I'd make it better (opinionated obviously) by removing the line feeds except between releases, and drop the day of the week from the release date. In addition, I'd put FIXES at the top and API changes 2nd (or vice versa) but definitely move FIXES up in priority.

**Olivier Mengué (dolmen), on 2011-02-06 11:39, said:**  
@abraxxa: I agree with you. Changeslog should be parseable.

Why? Because it would be useful to parse them to publish them as other formats.  
As Dave wrote, "Some of the readers [...] want to know what's new.". What is the current Internet standard to publish "what's new"? RSS!

I've started a few month ago to publish a ChangeLog of one of my distributions also as RSS: the (Module::Build based) dist build process uses RegExp::Grammar to create a Changes.rss which is included in the published archive.  
<http://cpansearch.perl.org/src/DOLMEN/POE-Component-Schedule-0.95/Changes>  
<http://cpansearch.perl.org/src/DOLMEN/POE-Component-Schedule-0.95/Changes.rss>  
The problem now is to automatically publish this RSS with a dist-version independent URL. Search.cpan.org does not do it. Yet?

**Olivier Mengué (dolmen), on 2011-02-06 12:04, said:**  
@Dave: I would have filled a ticket.

The ticketing system is the best place to report any usability issues about the module, and a low quality ChangeLog is an important usability issue in my point of view.  
Any improvement idea should be submitted as a ticket, as "wishlist" at least.

I'm now used to see module authors ignore such tickets (see list below) but sometimes they get an answer and CPAN improves.  
<https://rt.cpan.org/Public/Bug/Display.html?id=46913>  
<https://rt.cpan.org/Public/Bug/Display.html?id=55522>  
<https://rt.cpan.org/Public/Bug/Display.html?id=62480>

**Dave Rolsky, on 2011-02-06 16:45, said:**  
@Olivier: Tickets are useful too, but this post was only incidentally about Dancer. Plus I've seen a lot of good discussion and momentum after this post. Dancer has improved their Changes file, Brian Cassidy wrote the CPAN::Changes module, and I suspect other module authors will read this too.