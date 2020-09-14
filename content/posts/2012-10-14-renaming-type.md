---
title: Renaming Type
author: Dave Rolsky
type: post
date: 2012-10-14T20:33:20+00:00
url: /2012/10/14/renaming-type/
categories:
  - Uncategorized

---
A while back, I posted an [announcement][1] of my [Type distro][2].

The name Type was always somewhat of a placeholder, and I recently found out that the Type namespace is owned by someone else. It looks like the owner deleted this distro long ago, so I could try to get the namespace transferred, but I think this really just highlights the problems with such a generic name.

If anyone has suggestions for a new name, I&#8217;d be happy to hear it. The distro as it stands has package names such as Type::Constraint, Type::Coercion, and Type::Library. It also has some long names like Type::Constraint::Role::Interface.

Given those two facts, I&#8217;m looking for a new single word namespace to use. I really want something where I can just replace &#8220;Type&#8221; with &#8220;Word&#8221;. That rules out something like &#8220;Constraint&#8221; (which is too generic anyway).

So far my leading contender is Blazon, which thesaurus.com claims is a synonym for type. Generally speaking, I think it&#8217;s best when a single-level module name is more of a project name than a descriptor of the module (says the author of DateTime).

But if anyone has any better suggestions I&#8217;d love to hear them.

 [1]: /2012/05/14/new-type-constraint-module-for-perl/
 [2]: https://metacpan.org/release/DROLSKY/Type-0.05-TRIAL

## Comments

### Comment by bbb.stocken on 2012-10-15 00:15:30 -0500
I don&#8217;t think **blazon** is the best choice. If you look for synonyms of **blazon**, **type** don&#8217;t show up.

My own suggestion would be **variety**, even if that sound a little too bland to me.

### Comment by mpeters.myopenid.com on 2012-10-15 09:19:37 -0500
You could make it phonetic spelling of type: Maybe &#8220;Tipe&#8221; or &#8220;Taip&#8221; or &#8220;Tiep&#8221;

### Comment by https://me.yahoo.com/a/L7Szlac_ypI90V_CHKjhTZZkHL4-#da7e5 on 2012-10-15 09:39:01 -0500
Well, &#8220;blazon&#8221; means the description of a coat of arms in words, so I imagine whoever decided it was a synonym for &#8220;type&#8221; was using &#8220;type&#8221; in the typographical (fonts) sense.

A better synonym might be &#8220;Taxon&#8221; or &#8220;Genus&#8221; or something like that. Or &#8220;Ilk,&#8221; which is short, albeit difficult to read in typefaces where the capital I is not very different from lowercase l.

### Comment by hercynium on 2012-10-23 13:08:49 -0500
I started thinking about this (mainly because I like words and naming things) and came up with a few ideas, some of which make some sense, some of which I just stumbled over:

Pen &#8211; I was thinking about &#8220;things that constrain&#8221;  
Kaolin &#8211; A type of clay used in everything from pottery to toothpaste. I thought, constraining and coercing data to conform to types is kind of like molding clay. Could be shortened to &#8220;Kao&#8221;.  
Shi (氏) &#8211; According to Wikipedia, a Chinese term for a clan name, often denoting lineage or status, and/or identifying to which group a person belongs.  
Dub &#8211; As in, &#8220;I dub thee ArrayOfPrimeIntegers&#8221;  
Spruce &#8211; I thought, &#8220;Assigning types in perl is like dressing up a pig &#8211; you can call her Betsy but she&#8217;s still just pork underneath!&#8221;&#8230; which led me to words for getting dressed-up, which eventually led to this.

And with that I&#8217;m just getting silly. :)