---
title: Simple.com’s Password Strength Check
author: Dave Rolsky
type: post
date: 2013-01-15T19:39:47+00:00
url: /2013/01/15/simple-coms-password-strength-check/
categories:
  - Uncategorized

---
I&#8217;m creating a new account at [Simple.com][1] and it&#8217;s time for me to choose a password. I&#8217;m quite impressed with their password strength checker.

First of all, the get big points for recommending a pass-_phrase_, not a pass-_word_. In their words:

> **_Passphrase_?** Yes. Passphrases are easier to remember and more secure than traditional passwords. For example, try a group of words with spaces in between, or a sentence you know you&#8217;ll remember. `Correct horse battery staple` is a better passphrase than `r0b0tz26`.

Damn straight! I&#8217;m so sick of idiotic websites requiring me to use a capital letter and a number but disallowing spaces. So now I have a not terribly secure password I can never remember. Of course, I just let Chrome remember all my passwords anyway, but still, it&#8217;s lame.

I also greatly appreciated the [XKCD reference][2]. For bonus points, their Javascript for password strength explicitly disallows `correct horse battery staple` **and** `r0b0tz26`. I haven&#8217;t analyzed their entire strength determination algorithm but it seems to be pretty good, as phrases of many short words rank lower than phrases with fewer, longer words.

They also have some sort of blacklist. The phrase &#8220;yo dawg, i heard you like passphrases&#8221; gets a very low score. The blacklist could be a bit better as &#8220;to be or not to be&#8221; gets a &#8220;B&#8221;.

But overall, I&#8217;m impressed. It&#8217;s incredibly rare to see a site recommend a passphrase at all, much less really help guide you to something both secure and memorable.

Great job, Simple!

 [1]: http://simple.com
 [2]: http://xkcd.com/936/