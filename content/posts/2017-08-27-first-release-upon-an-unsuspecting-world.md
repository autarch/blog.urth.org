---
title: “First release upon an unsuspecting world”
author: Dave Rolsky
type: post
date: 2017-08-27T22:54:13+00:00
url: /2017/08/27/first-release-upon-an-unsuspecting-world/
---
For as long as I can remember, I've been using the phrase "First release upon an unsuspecting world" as the Changes entry for the first release of all my CPAN modules. Thinking about this, I cannot remember where this came from. I don't _think_ that I invented it, but maybe I did. I do have an idea every once in a while. But I _feel_ like I got the idea from someone or something else.

A quick Google search didn't up much except links to my own Changes files. So maybe I did invent this?

Anyone out there have any clue? I obviously don't.

## Comments

**Gabor Szabo, on 2017-08-27 22:11, said:**  
Modules Starter includes this sentence: "First version, released on an unsuspecting world." though you might have been the inspiration for that.

**Dave Rolsky, on 2017-08-27 22:59, said:**  
Or perhaps we both had a common inspiration.

**Diab Jerius, on 2017-08-28 19:59, said:**  
h2xs has generated this message for ages

**Dave Rolsky, on 2017-08-28 21:18, said:**  
Ah, that's surely where I got it from then.

**Dave Rolsky, on 2017-08-28 21:20, said:**  
Except I just ran `h2xs -X Foo` now and the Changes just contains this:

> Revision history for Perl extension Foo.
> 
> 0.01 Mon Aug 28 21:19:22 2017  
> - original version; created by h2xs 1.23 with options  
> -X Foo

**Andy Lester, on 2017-08-30 09:32, said:**  
I think it's my fault. When I wrote Module::Starter I needed something to put in the stock Changes file. I think I made up that sentence myself. My big concern was that I didn't want the author in the boilerplate to be A. U. Thor.

It's in Module::Starter 0.02 from 2004. <a href="http://backpan.perl.org/authors/id/P/PE/PETDANCE/Module-Starter-0.02.tar.gz" rel="nofollow ugc">http://backpan.perl.org/authors/id/P/PE/PETDANCE/Module-Starter-0.02.tar.gz</a>

**Andy Lester, on 2017-08-30 09:37, said:**  
I checked Perl 5.005 (1997) and 5.8.6 (2004) and it's not in either of those.