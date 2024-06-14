---
title: Distros Which Need Some Love
author: Dave Rolsky
type: post
date: 2011-08-23T22:36:24+00:00
url: /2011/08/23/distros-which-need-some-love/
---

I have way too many modules. Want to take one or two?

Here's some modules that I own (or co-own) that need some love:

- DateTime-Format-Mail - has some open bugs that could use some attention.
- DateTime-Format-MySQL - I may have a new maintainer lined up, but the more the merrier, I suspect.
- DateTime-Format-Strptime - I took co-maint on this to do a few quick fixes, but it could use more
  attention.
- DateTime-Locale - I have a vague plan to convert this to use libicu or something like that, but I
  am lacking tuits. The data is quite out of date at this point. If someone wanted to do just take
  the existing code and make it work with the newest CLDR data, that'd be fine, but you can't change
  the API unless it's necessary to support new data.
- HTML-WikiConverter-MultiMarkdown
- MooseX-Singleton - I don't bother using this any more. It's more trouble than it's worth.
- Params-Validate - could use an XS expert to fix some bugs I just can't figure out.
- ShipIt-Step-CheckVersionsMatch - I'm down with dzil.
- Anything else - if you're dying to work on something I've been neglecting, let me know.

All of these modules should be in [a git repo on my server][1].

[Contact me via email][2] if you're interested.

[1]: http://git.urth.org/
[2]: mailto:autarch@urth.org

## Comments

**Justin, on 2011-08-26 14:51, said:**  
What goes into owning a module?

I never have before, but I'm interested in helping out.
