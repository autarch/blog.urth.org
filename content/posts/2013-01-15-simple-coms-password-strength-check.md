---
title: Simple.com’s Password Strength Check
author: Dave Rolsky
type: post
date: 2013-01-15T19:39:47+00:00
url: /2013/01/15/simple-coms-password-strength-check/
---
I'm creating a new account at [Simple.com][1] and it's time for me to choose a password. I'm quite impressed with their password strength checker.

First of all, the get big points for recommending a pass-_phrase_, not a pass-_word_. In their words:

> **_Passphrase_?** Yes. Passphrases are easier to remember and more secure than traditional passwords. For example, try a group of words with spaces in between, or a sentence you know you'll remember. `Correct horse battery staple` is a better passphrase than `r0b0tz26`.

Damn straight! I'm so sick of idiotic websites requiring me to use a capital letter and a number but disallowing spaces. So now I have a not terribly secure password I can never remember. Of course, I just let Chrome remember all my passwords anyway, but still, it's lame.

I also greatly appreciated the [XKCD reference][2]. For bonus points, their Javascript for password strength explicitly disallows `correct horse battery staple` **and** `r0b0tz26`. I haven't analyzed their entire strength determination algorithm but it seems to be pretty good, as phrases of many short words rank lower than phrases with fewer, longer words.

They also have some sort of blacklist. The phrase "yo dawg, i heard you like passphrases" gets a very low score. The blacklist could be a bit better as "to be or not to be" gets a "B".

But overall, I'm impressed. It's incredibly rare to see a site recommend a passphrase at all, much less really help guide you to something both secure and memorable.

Great job, Simple!

 [1]: http://simple.com
 [2]: http://xkcd.com/936/