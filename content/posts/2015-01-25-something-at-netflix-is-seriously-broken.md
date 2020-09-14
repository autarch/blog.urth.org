---
title: Something at Netflix is Seriously Broken
author: Dave Rolsky
type: post
date: 2015-01-26T02:56:46+00:00
url: /2015/01/25/something-at-netflix-is-seriously-broken/
categories:
  - Uncategorized

---
Somehow people seem to keep breaking into my Netflix account. Calling Netflix achieves little. Their go to answer is to have me change my password and sign out all devices. In theory, this _should_ keep hackers out. I&#8217;ve done this a number of times to no avail. Last night I changed the email associated with the account, as well as the password, and they&#8217;re back in tonight.

**Edit: Someone on HackerNews asked how I know that the account was hacked. We only have two people in my household, my wife and I, and we each have a Netflix account on our profile. I have never shared the password with anyone. I see activity on my profile of things that neither my wife nor I watched. Netflix also now shows you the devices that have been used with your account. I see devices from unknown IPs around the world.**

Let me first dismiss some other possibilities before settling on Netflix itself having a problem.

Was my email account hacked? If the account (or the server hosting it) was hacked, the attacker would still need to change the password, which they haven&#8217;t done. So that&#8217;s ruled out.

Was my desktop computer from which I changed the password hacked? Possibly, but if so, these are the world&#8217;s most unambitious hackers. They haven&#8217;t bothered stealing any other account login info, including things like my Amazon info or credit cards stored in Chrome. If someone had hacked my desktop I&#8217;d have much bigger problems than someone using my Netflix account!

**Edit: How do I know for sure my desktop wasn&#8217;t hacked? I haven&#8217;t done a forensic investigation, but it seems unlikely. I&#8217;m running an up to date Ubuntu machine and I use Chrome as my browser. I also have a reasonably sane firewall in place, fail2ban, and other security thingamabobs. It&#8217;s not impossible to break into (nothing is) but it&#8217;s not a particularly soft target.**

How about the Xbox 360 we mostly use for watching Netflix? I don&#8217;t see how that&#8217;s possible without physical access to the machine. I doubt someone broke in just to hack our Xbox 360 and didn&#8217;t steal anything.

Did someone guess my Netflix password? Possible, but I use rather long passwords that would be pretty hard to brute force. If Netflix doesn&#8217;t have rate limiting in place, that&#8217;s a huge problem. That said, I don&#8217;t know how someone would know what email address is associated with my account. It&#8217;s not an address I&#8217;ve used for anything else, ever, and I changed it last night to a new, never-before-used address!

Did someone exploit a flaw in WPA2 to intercept wireless traffic from the Xbox 360, or otherwise intercept traffic between me and Netflix? If Netflix&#8217;s authentication system is entirely on SSL, I don&#8217;t see how this could possibly work.

So what possibilities does that leave? My guess is that there&#8217;s some fundamental brokenness in the authentication system that Netflix uses. Either that or put your conspiracy theory hat on and we can talk about inside men and women at Amazon and/or Netflix. Either way, I&#8217;m blaming this on Netflix, and I&#8217;m tempted to just cancel the account. Netflix could probably help improve security quite a bit by supporting 2-factor auth in order to authenticate a new device.

That all said, I&#8217;d love to hear a better theory, especially if it came with a solution.

## Comments

### Comment by MW on 2015-01-26 13:57:31 -0600
What are the symptoms of the attack? I mean like once they&#8217;ve compromised your account, what do they typically do?

### Comment by Dave Rolsky on 2015-01-26 14:10:34 -0600
I can see unknown devices who&#8217;ve watched things that I didn&#8217;t watch.

### Comment by Jeremy Leader on 2015-01-26 17:17:00 -0600
Under the &#8220;never attribute to malice what can adequately be explained by stupidity&#8221; principle, it might just be a bug in their reporting system.

### Comment by Dave Rolsky on 2015-01-26 17:21:05 -0600
Jeremy, that&#8217;s a good point. However, my Netflix plan only allows for 2 screens max at a time, and I&#8217;ve been blocked from viewing because of this, even when we don&#8217;t have 2 screens already going in the house. When I called Netflix they said it was because someone in Germany was using my account.

That doesn&#8217;t rule out bugs in their system, of course, but if that&#8217;s the case then it&#8217;s a pretty serious bug.

### Comment by tim on 2015-02-14 23:20:04 -0600
Same thing happened and is currently happening to me. Changed the password multiple times. Netflix customer support changed the email address that the account is associated with as well as the password. Still it&#8217;s only one random IP address that is accessing the account over and over no matter what changes are made&#8230; Netflix customer support finally said the best thing to do was to cancel netflix and sign back up again. WTF. They are binge watching Nikita, House of Cards and now they are on the Blacklist. We resorted to changing the settings to kids in order to keep them from using the account which seems to work except for the times we change it back to watch regular tv shows&#8230;.

so &#8230; I think that this is probably a serious security flaw on Netflix servers. They didn&#8217;t let on that this was an issue with other accounts.

### Comment by Dale Brothers on 2015-02-19 18:36:54 -0600
I&#8217;ve been hacked two times in four months. Always by EU xboxes that have set up their own profile. No sooner do I change my password, another unknown profile hacker logs in. I think I&#8217;m left with no choice but to cancel Netflix.

### Comment by Emily on 2015-02-22 10:55:08 -0600
This happened to me recently. Someone in Germany gained access to my account. They deleted my secondary profile, created two new profiles, and changed the primary email address and password for the account, locking me out. I was able to regain access by calling support, who told me that the activity was coming from Germany and that he could tell they were using heavy-duty software that the average person does not have, because their streaming activity was displaying as &#8220;hidden stream&#8221; instead of listing the exact programs they&#8217;re watching.

What I don&#8217;t get is why they would want to change the email address and password and profiles. That immediately tipped me off so that I called to regain access, and if I couldn&#8217;t have gotten it back I would have immediately stopped paying for the monthly charges. If they have the ability to hide their streaming activity, it would make more sense for them to watch secretly without changing anything so that I&#8217;d keep paying every month and keep the account alive. I can&#8217;t figure out what assets my account has once my email address and payment information are disconnected &#8211; why not just start a new account of their own with a new address? What&#8217;s the advantage of taking over mine?

### Comment by Dave Rolsky on 2015-02-22 11:01:04 -0600
Emily, that is quite odd behavior. I would note that one big advantage to hacking a US-based account is that you get access to everything available in the US. I suspect that much of the content seen by people in the US is not available in Europe.