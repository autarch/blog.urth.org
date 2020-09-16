---
title: Changes File How-To Follow-Up
author: Dave Rolsky
type: post
date: 2011-01-28T13:58:45+00:00
url: /2011/01/28/changes-file-how-to-follow-up/
categories:
  - Uncategorized

---
My last post on [Changes files][1] purported to be both a how-to and how not-to, but I got a bit carried away with the how not-to part. Several comments since that post made excellent points, so here&#8217;s the summary.

Kent Fredric says &#8220;don&#8217;t be lazy and just copy the output from 'git log' into your Changelog.&#8221; Yes, a thousand times yes! Remember, the Changes file is for end users of your library, and we don&#8217;t care about all the little details. Just give us the summary. (Ok, that&#8217;s the last how not-to.)

RJBS says &#8220;put the latest release at the TOP of the file.&#8221; Yes, we&#8217;re talking to you, Damian. When I open up the Changes file I don&#8217;t want to read about the first release from three years ago.

On #moose IRC, Karen Etheridge also mentioned the importance of linking changes to tickets. The Dancer file I criticized was already doing that, and I meant to highlight that, but got caught up in ranting. All you need is the ticket id and the relevant system, something like &#8220;RT #12345&#8221; or &#8220;GH #456&#8221; at the end of a particular change.

Karen also suggested mentioning the commit id in the changes file. I&#8217;m not so sure about that. I&#8217;d rather see some sort of integration between the bug tracker and the source control system. I&#8217;ve used such systems at several jobs. I would write &#8220;RT 12345&#8221; in my commit message, and that commit message would be appended to the ticket as a comment.

 [1]: /2011/01/27/changes-file-how-and-how-not-to/

## Comments

### Comment by Karen Etheridge on 2011-01-28 14:13:55 -0600
To clarify, I don&#8217;t think the commit id should be in the changes file, but it definitely belongs in the bug tracking ticket. That way anyone coming long later reading about the bug can find the exact code that fixed the bug &#8211; it&#8217;s possible the fix wasn&#8217;t complete, or a similar bug happened somewhere else, so it&#8217;s of significance to be able to see what actually was done to fix the issue.
