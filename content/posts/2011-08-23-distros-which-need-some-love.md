---
title: Distros Which Need Some Love
author: Dave Rolsky
type: post
date: 2011-08-23T22:36:24+00:00
url: /2011/08/23/distros-which-need-some-love/
categories:
  - Uncategorized

---
I have way too many modules. Want to take one or two?

Here&#8217;s some modules that I own (or co-own) that need some love:

  * DateTime-Format-Mail &#8211; has some open bugs that could use some attention.
  * DateTime-Format-MySQL &#8211; I may have a new maintainer lined up, but the more the merrier, I suspect.
  * DateTime-Format-Strptime &#8211; I took co-maint on this to do a few quick fixes, but it could use more attention.
  * DateTime-Locale &#8211; I have a vague plan to convert this to use libicu or something like that, but I am lacking tuits. The data is quite out of date at this point. If someone wanted to do just take the existing code and make it work with the newest CLDR data, that&#8217;d be fine, but you can&#8217;t change the API unless it&#8217;s necessary to support new data.
  * HTML-WikiConverter-MultiMarkdown
  * MooseX-Singleton &#8211; I don&#8217;t bother using this any more. It&#8217;s more trouble than it&#8217;s worth.
  * Params-Validate &#8211; could use an XS expert to fix some bugs I just can&#8217;t figure out.
  * ShipIt-Step-CheckVersionsMatch &#8211; I&#8217;m down with dzil.
  * Anything else &#8211; if you&#8217;re dying to work on something I&#8217;ve been neglecting, let me know.

All of these modules should be in [a git repo on my server][1].

[Contact me via email][2] if you&#8217;re interested.

 [1]: http://git.urth.org/
 [2]: mailto:autarch@urth.org

## Comments

### Comment by Justin on 2011-08-26 14:51:41 -0500
What goes into owning a module?

I never have before, but I&#8217;m interested in helping out.