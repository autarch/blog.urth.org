---
title: Going Full Gmail
author: Dave Rolsky
type: post
date: 2017-07-04T19:08:26+00:00
url: /2017/07/04/going-full-gmail/
categories:
  - Uncategorized

---
So I finally gave in and moved my email to Gmail. Specifically, I&#8217;ve moved the urth.org email handling to Gmail via G Suite with my own domain.

The first email reader I used was Pine, which I used for ages. Later I got real modern and switched to Alpine. I would shell into urth.org and run alpine to read my mail. This worked fine except for all the ways it didn&#8217;t. I had scripts I could pipe to that would open links from email on my desktop, as well as attachments.

But more and more email has become hard to read in a text-based system. In particular, things like hotel and airline reservation confirmations are gibberish in a text reader. The last straw was a couple weeks ago when I misread my wife&#8217;s plane departure time. Fortunately, my misread caused her to be early rather than late, but this was a clear sign from the email gods that it was time to modernize.

I struggled with Mailpile for a few days first. It seems like a really nice piece of software, and it has a lot of great features. Unfortunately, getting it to just read all my existing mail was really difficult and I gave up, since I&#8217;m really not sure of its long-term future, and hacking on an email app is not how I want to spend my time.

Of course, Gmail is **also** terrible at importing email. I mean really really terrible. First I tried the data migrator that is part of G Suite. It claims it can import from an IMAP server. Problem #1, it needs SSL. Solution #1, I already have dovecot set up with SSL. Problem #2, it will only connect if SSLv3 is enabled. WTF, Google?! I&#8217;d report the SSLv3 thing but it&#8217;s Google, who the hell would I report it to? Dear web crawler, please read the previous paragraph and use your AI to tell the right person.

Problem #3, once I enable SSLv3 it just fails mysteriously. It probably has something to do with my weird folder structure as a result of using procmail for so many years.

Next approach, copy all my mbox files locally, fire up Thunderbird, and use the ImportExportTools extension to import each mbox file. Problem #4, it can&#8217;t handle very large (1+GB) mbox files. It just truncates them. Solution #2, use [a gross awk solution][1] that seems to make some mistakes, but is good enough. Then connect Thunderbird to gmail and copy emails from the Local Folders to Gmail. It&#8217;s _super_ slow but it does work. Of course, if one of the emails has attachments larger than 25MB Thunderbird dies mid-import without telling me which message failed. Solution #3, create a Thunderbird filter to find all messages with large attachments and delete the attachments before doing the import.

I still have a good 6+ GB of old email to import, so I&#8217;m also going to experiment with [import-mailbox-to-gmail][2], which will probably suck in some other way, but claims to log errors so maybe I can just throw it at the remaining 6GB and sort out the errors later. You&#8217;d think Google would want to make it easy to switch to their services but I think they&#8217;re mostly catering to Enterprise Outlook users.

I&#8217;m also trying to move all my Google stuff (drive, photos, etc.) to my new account, which of course Google _also_ does not make easy. Am I really the first person trying to move from a gmail presence to a custom domain hosted in G Suites? Really? Why are you so half-assed, Google?

On the plus side, once I&#8217;m done, I&#8217;ll have a halfway decent email reader to use.

 [1]: https://stackoverflow.com/questions/28110536/how-to-split-an-mbox-file-into-n-mb-big-chunks-using-the-terminal
 [2]: https://github.com/google/import-mailbox-to-gmail

## Comments

### Comment by mark on 2017-07-07 18:58:49 -0500
This is somewhat interesting because I have considered to abandon all Google-related products since quite some time. I dislike their growing de-facto monopoly in general.

### Comment by Dave Rolsky on 2017-07-11 23:49:39 -0500
I see where you&#8217;re coming from. But for me the principle was not significant compared to the practical ongoing (time and energy) cost of maintaining my own mail server, using a not-so-great mail reader, etc.