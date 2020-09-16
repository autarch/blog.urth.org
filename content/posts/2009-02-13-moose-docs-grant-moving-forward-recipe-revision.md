---
title: Moose Docs Grant Moving Forward – Recipe Revision
author: Dave Rolsky
type: post
date: 2009-02-13T09:46:42+00:00
url: /2009/02/13/moose-docs-grant-moving-forward-recipe-revision/
---
The [latest release of Moose, 0.69][1], marks another completed deliverable in the [Moose docs grant][2]. For this release, I finished revising every cookbook recipe in the distro.

My goals were to generally improve the text (Stevan is _wordy_ in hist first drafts ;), and also to make sure we are consistent in our terminology and style.

I also ended moving a fair bit of documentation from cookbook recipes over to the manual. Before the manual existed, some "general doc" pieces ended up in the cookbook for lack of a better home.

In particular, I ended up adding a fair bit of content to [the Best Practices manual][3] based on some writing that used to live in Moose::Cookbook::Style.

 [1]: http://search.cpan.org/~drolsky/Moose-0.69/
 [2]: http://news.perlfoundation.org/2008/11/2008q4_grant_proposal_moose_do.html
 [3]: http://search.cpan.org/~drolsky/Moose-0.69/lib/Moose/Manual/BestPractices.pod

## Comments

**matt, on 2009-02-13 11:09, said:**  
just popping in to say thanks for your work, its appreciated

**John, on 2009-02-13 11:14, said:**  
The new documentation is excellent. Fantastic job.

**james, on 2009-02-13 16:26, said:**  
More details on using Moose with Error objects (not Error, that seems to be incompatible with Moose) would be good.

**yanick.myopenid.com, on 2009-02-14 15:54, said:**  
Thanks for the lovely documentation. It's very much appreciated. :-)

I've passed the new Moose::Manual::* through my Pod::Manual machine and generated a pdf version of it (well, two actually: one using LaTeX, one using Prince). The pdfs are at <a href="http://babyl.dyndns.org/techblog/manuals/" rel="nofollow ugc">http://babyl.dyndns.org/techblog/manuals/</a> if you are interested.

**sawyer, on 2009-02-15 03:15, said:**  
I always loved the Moose documentation but now it's even better! Great job! I especially liked Moose::Unsweetened!