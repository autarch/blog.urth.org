---
title: Renaming Type
author: Dave Rolsky
type: post
date: 2012-10-14T20:33:20+00:00
url: /2012/10/14/renaming-type/
---

A while back, I posted an [announcement][1] of my [Type distro][2].

The name Type was always somewhat of a placeholder, and I recently found out that the Type namespace
is owned by someone else. It looks like the owner deleted this distro long ago, so I could try to
get the namespace transferred, but I think this really just highlights the problems with such a
generic name.

If anyone has suggestions for a new name, I'd be happy to hear it. The distro as it stands has
package names such as Type::Constraint, Type::Coercion, and Type::Library. It also has some long
names like Type::Constraint::Role::Interface.

Given those two facts, I'm looking for a new single word namespace to use. I really want something
where I can just replace "Type" with "Word". That rules out something like "Constraint" (which is
too generic anyway).

So far my leading contender is Blazon, which thesaurus.com claims is a synonym for type. Generally
speaking, I think it's best when a single-level module name is more of a project name than a
descriptor of the module (says the author of DateTime).

But if anyone has any better suggestions I'd love to hear them.

[1]: /2012/05/14/new-type-constraint-module-for-perl/
[2]: https://metacpan.org/release/DROLSKY/Type-0.05-TRIAL

## Comments

**bbb.stocken, on 2012-10-15 00:15, said:**  
I don't think **blazon** is the best choice. If you look for synonyms of **blazon**, **type** don't
show up.

My own suggestion would be **variety**, even if that sound a little too bland to me.

**mpeters.myopenid.com, on 2012-10-15 09:19, said:**  
You could make it phonetic spelling of type: Maybe "Tipe" or "Taip" or "Tiep"

**https://me.yahoo.com/a/L7Szlac_ypI90V_CHKjhTZZkHL4-#da7e5, on 2012-10-15 09:39, said:**  
Well, "blazon" means the description of a coat of arms in words, so I imagine whoever decided it was
a synonym for "type" was using "type" in the typographical (fonts) sense.

A better synonym might be "Taxon" or "Genus" or something like that. Or "Ilk," which is short,
albeit difficult to read in typefaces where the capital I is not very different from lowercase l.

**hercynium, on 2012-10-23 13:08, said:**  
I started thinking about this (mainly because I like words and naming things) and came up with a few
ideas, some of which make some sense, some of which I just stumbled over:

Pen - I was thinking about "things that constrain"  
Kaolin - A type of clay used in everything from pottery to toothpaste. I thought, constraining and
coercing data to conform to types is kind of like molding clay. Could be shortened to "Kao".  
Shi (氏) - According to Wikipedia, a Chinese term for a clan name, often denoting lineage or status,
and/or identifying to which group a person belongs.  
Dub - As in, "I dub thee ArrayOfPrimeIntegers"  
Spruce - I thought, "Assigning types in perl is like dressing up a pig - you can call her Betsy but
she's still just pork underneath!"... which led me to words for getting dressed-up, which eventually
led to this.

And with that I'm just getting silly. :)
