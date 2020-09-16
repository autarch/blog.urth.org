---
title: What Perl 6 (and 5) Have Done Right
author: Dave Rolsky
type: post
date: 2011-04-18T12:46:05+00:00
url: /2011/04/18/what-perl-6-and-5-have-done-right/
---
_(I'm still [looking for a new position][1]. Please [check out my resume][2] and [contact me][3] if you're looking for a great Perl developer.)_

I was talking this weekend with [Matt Mackall][4] about Python 3 and Perl 6. Matt is the creator of [Mercurial][5], so he is deeply invested in Python.

He was asking about the relationship between Perl 5 and Perl 6, and we were comparing it with the relationship of Python 2 and 3. His main problem with Python 3, as I understand it, is the backwards-incompatible change in string handling from 2 to 3. In Python 3, all strings are Unicode by default. Byte arrays are now their own thing, no longer interchangeable with strings.

Meanwhile, Mercurial is still supporting distributions that are running Python 2.4, which is over 6 years old at this point. To make matters worse, Mercurial really doesn't benefit from the Unicode-is-everywhere changes in Python 3, so there's little incentive to migrate.

I suspect that eventually Mercurial will be stuck with some sort of compatibility layer that checks what Python it is running on, and loads the appropriate versions of libraries (or monkey patches them, or whatever Python people do ;).

This discussion helped me realize that regardless of any problems Perl 6 has, we've done one thing really right in the overall Perl community. There's no intention to have Perl 6 **replace** Perl 5. Perl 6 has been designed to co-exist with Perl 5. The Perl 6 binary will presumably be called `perl6` (or maybe `rakudo`), not just `perl`.

Meanwhile, Perl 5 has maintained it's strong commitment to backwards compatibility while still pulling in cool bits from Perl 6. This commitment can be frustrating in many ways, but its also has benefits. The Perl 5 commitment to prototyping new features on CPAN has made for a much cleaner upgrade path. Finally, the fact that syntax breakage is almost always opt-in (with `use feature` or `use 5.x`), means that we can safely upgrade one module at a time to new syntax.

Of course, Python has `from __future__ import`, but Python 3 doesn't use that to enable Unicode everywhere. Even worse, there doesn't seem to be a `from __past__ import "old string semantics"`, so upgrading to Python 3 requires an entire application (and its dependencies) to upgrade all at once.

Whatever you think of Perl 6, I think the Perl community can be thankful that Larry had the foresight to realize that Perl 6 cannot replace Perl 5. Decoupling Perl 6 from Perl 5 has let the two projects grow at their own pace. If Perl 6 had been officially anointed as the coming replacement for Perl 5, I doubt we would ever have seen the Modern Perl "movement" emerge, nor would we have seen the revitalized Perl 5 core development of the past few years.

When Perl 6.0 is released, in whatever form that takes, our Perl 5 programs will continue working for as long as we want. That's a very good thing.

 [1]: /2011/03/30/looking-for-a-new-position/
 [2]: http://houseabsolute.com/resume.html
 [3]: mailto:dave@houseabsolute.com
 [4]: http://www.selenic.com/blog/
 [5]: http://mercurial.selenic.com/wiki/

## Comments

**shawn.c.carroll, on 2011-04-18 13:39, said:**  
You know what, this is the first time I've read about Perl6 not meaning to Replace Perl5. Not to say that is the truth, I'm much happier in this case.

**ddt, on 2011-04-18 13:44, said:**  
And yet Python 3 is happening while things get more and more silent around Perl 6...  
I would take "hard to get people to migrate" over "does not even exist yet" any day.

**Dave Rolsky, on 2011-04-18 14:34, said:**  
@Shawn: I think that's always been the intention, but it may not have been communicated well.

@ddt: Whatever happens with Perl 6 eventually, I think Perl 5 has gotten a lot out of the Perl 6 effort. Moose is just one of many CPAN modules and core features that was inspired by work on Perl 6.

**andre, on 2011-04-18 14:40, said:**  
I think most users have replaced Perl5 by Python or Ruby already, not Perl6, as Perl5 is not even able to introduce the simplest OOP features into the core. This is the price we have to pay for "strong commitment to backwards compatibility", "there are too many ways to do it" and "keep essential features out of core"

How many modules do exceptions right, e.g.?  
<http://deps.cpantesters.org/depended-on-by.pl?module=Try%3A%3ATiny>

**Dave Rolsky, on 2011-04-18 15:31, said:**  
@andre: That's a pretty bold and unsubstantiated statement. Ruby and Python are growing, and I'm sure some Perl 5 folks have left to use those languages, but it's a big jump from "some" to "most".

That said, I agree, arguably the Perl 5 core has been too conservative. Not having even a minimal OO system or decent exceptions in core is a drag. OTOH, would Moose exist if we Perl 5 had "good enough" OO in core? I think having a good enough system as a default might deter people from building something really great.

**Robert, on 2011-04-18 16:09, said:**  
Conservative is right! I consider the way Tcl core is enhanced to be much more conservative, yet even Tcl is getting OO in the core now.

I agree, Perl6 isn't to replace Perl5, and P5 has reaped rewards back from P6.

Python3...well, that is going to be the Python going forward so \*at some point\* everyone will jump on that train.

**andre, on 2011-04-18 16:43, said:**  
@Dave: "That's a pretty bold and unsubstantiated statement"

it is true for web dev I think, for example, just look at Github activity for Ruby web projects and compare them to Perl, that is a pretty strong indicator and tells you much more than vague indicators such as the tiobe index

however, I am not an expert for other areas beyond web dev, so my statement might be indeed less substantiated there

if Perl5 developers want to keep backwards compatibility forever, that is okay, but at least people should know so they get a fair chance to look for alternatives

regarding Moose: if it is really that great (and solves so many real-world programming issues), it will prevail regardless of whether there are simple read/write accessors with defaults in Perl core or not

**Iñigo, on 2011-04-18 16:47, said:**  
At a side of previous comments, I see your post just right. Haters will make lot of liar paradoxes and risky assertions. But full reality is out here.

Thanks Larry and the Perl(N) communities. Thanks CPAN authors and Perl porters.

In a time where we're full of semi-beta-py-apis by Googlevil, and Debian is being x86 and x86\_64 py-canonical-ized by noisers pro-blobs, things like backward compatibility and clever development and evolution, are things to be thankful. At least by people who like to \_live_ and \_enjoy\_ the freedom of opensource and the K.I.S.S. legacy of unix (like) systems.

Lot of people talks, but they need to live things (in special API changes). K.I.S.S. isn't just about remove semicolons or braces from code, neither about using dots instead of -> (hey, we're over C systems, right?), and hacking isn't just about blind follow first world twits and companies.

Greetings

**Dave Rolsky, on 2011-04-18 18:03, said:**  
@andre: Well, since you think it's true, it must be true.

Citing any one thing (like Github) is pretty meaningless. Github is written in Ruby, and a lot of people in the Ruby community got excited about it. I'm not surprised there's lots of Ruby projects on there.

Next you'll point to Bitbucket for Python?

re: Moose - my point was that if the Perl core \_already had something\_ that was "good enough", Moose might never have been built.

**CBT, on 2011-04-18 21:23, said:**  
@andre What evidence are you using to conclude Perl is inactive on Github? The best I could find was this:

<https://github.com/languages>

Which currently* lists Perl in the top 10, tied with PHP, and higher than Java. I don't know about you, but frankly that seems pretty skewed from the industry as a whole. Even so, by your own suggested measure of the industry, Perl certainly has a sizable footprint.

* At the time of writing, here are Github's language rankings:

<pre>19% JavaScript
   17% Ruby
    9% Python
    8% C
    7% Perl
    7% PHP
    6% Shell
    6% Java
    4% C++
    2% VimL
</pre>

**John, on 2011-04-18 22:35, said:**  
6 has helped 5 pick up modern new features, and 5 has helped 6 by continuing to grow the Perl community while 6's implementation matures. It's win-win.

**b.c., on 2011-04-19 00:16, said:**  
i'm on the fence. we might be celebrating perl6 as a parallel effort to perl5, but let us be realistic here: this is mostly an artifact of the long development time for perl6, and an eventual understanding that perl5 would have to be modernized to stay relevant (thanks modern perl!)

i'm concerned that perl5 coders will never face external pressure to undertake the migration when the time comes...if so, perl6's library availability will suffer. we need the masses on cpan to eventually pay attention to perl6

**andre, on 2011-04-19 05:48, said:**  
@CBT

I think your numbers are misleading,

1.) as <https://github.com/gitpan> alone includes 21,976 repos as of now, which is just imported from CPAN (not necessarily active)  
(but I don't know how these number are calculated exactly)

2.) I was talking about trends, and a couple of months ago, Perl ranked 3rd on that index ahead of Python and C

so talking about active development (and not people hiding in the dark and writing Perl), there is a trend, and it is important to know

A fault confessed is half redressed :)

**Shawn, on 2011-04-19 08:17, said:**  
Actually, it was the migration from Perl 4 to Perl 5 that taught the Perl developers the importance of backward compatibility. Perl 5 was not backward compatible and many users stopped using Perl because of it.

**chromatic, on 2011-04-19 15:00, said:**  
Which backwards incompatibilities did you see between Perl 4 and Perl 5? I can only think of the incompatibility of the Perl source code itself with regard to extensions such as sybperl and oraperl.

**Robert, on 2011-04-19 18:24, said:**  
I would be curious to see a study on what percentage of Perl5 developers are going to move to Perl6 when it "comes out".

**CBT, on 2011-04-23 10:22, said:**  
@andre As they say on wikipedia, cite your sources. :-) Do you have any evidence of this trend or do we simply have to take your word for it?

**andre, on 2011-04-28 19:11, said:**  
@CBT github doesn't show trends, but I watch the mentioned stats site regularly, so all I can tell is how these stats looked couple of months ago

there are lots of sources for language popularity, some also look positive (like Alexa stats for perlmonks.org e.g.)

<http://www.tiobe.com/index.php/content/paperinfo/tpci/index.html>  
<http://www.alexa.com/>  
<http://www.langpop.com/>  
<https://github.com/languages>

the move to other languages in the web dev area (PHP a couple of years ago, Python and Ruby right now) is pretty evident (and as I do most work still in Perl because of my experience and code base, I don't like this development)

just look at projects like  
<https://github.com/facebook/tornado>  
or rails and you might better understand my point of view