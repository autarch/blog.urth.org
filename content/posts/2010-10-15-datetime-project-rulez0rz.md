---
title: DateTime Project Rulez0rz
author: Dave Rolsky
type: post
date: 2010-10-15T10:21:01+00:00
url: /2010/10/15/datetime-project-rulez0rz/
categories:
  - Uncategorized

---
I wanted to turn all the dates in my Changes file into the YYYY-MM-DD format (in this case from things like &#8220;Aug 27, 2008&#8221;). Here&#8217;s my one-liner:

<pre class="highlight:false">perl -MDateTime::Format::Natural -pi -e \
    '$f = DateTime::Format::Natural->new;
     s/^([\d\.]+\s+)(\w+.+)$/$1 . $f->parse_datetime($2)->ymd/e' \
    Changes
</pre>

The DateTime project is pretty badass, if I do say so myself. Note that most of the credit here should go to Steven Schubiger for [DateTime::Format::Natural][1]

 [1]: http://search.cpan.org/dist/DateTime-Format-Natural

## Comments

### Comment by mirrorkitty.vegas on 2010-10-15 16:59:53 -0500
It is a pity you had to hose the original content of <a href="http://datetime.perl.org" rel="nofollow">datetime.perl.org</a> to prove it. It is now one of the few perl.org sites where the old look (and content) was better than the new.

### Comment by Dave Rolsky on 2010-10-15 17:26:26 -0500
@mirrorkitty: The content is exactly the same on the new wiki as it was on the old, minus the insane amounts of spam.

If you actually want to do anything on it besides leave snarky comments on my blog, you could look at patching Silki to allow themes and redo the datetime theme.