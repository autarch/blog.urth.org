---
title: Cross-posting from Movable Type to use Perl
author: Dave Rolsky
type: post
date: 2008-09-06T10:57:33+00:00
url: /2008/09/06/cross-posting-from-movable-type-to-use-perl/
categories:
  - Uncategorized

---
If you&#8217;re seeing this on use Perl then the cross-poster is working. You can [get it from my svn][1]. You&#8217;ll also need to install WWW::UsePerl::Journal, which I monkey patch like crazy in the plugin. I have submitted patches to barbie, though, so hopefully that&#8217;ll go away in the future.

The plugin isn&#8217;t too smart, so if you save the same entry it&#8217;ll re-crosspost each time. Patches welcome, of course.

 [1]: https://svn.urth.org/svn/MT-Plugin-UsePerl-Journal/trunk/