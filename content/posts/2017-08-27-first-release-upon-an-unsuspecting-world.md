---
title: “First release upon an unsuspecting world”
author: Dave Rolsky
type: post
date: 2017-08-27T22:54:13+00:00
url: /2017/08/27/first-release-upon-an-unsuspecting-world/
categories:
  - Uncategorized

---
For as long as I can remember, I&#8217;ve been using the phrase &#8220;First release upon an unsuspecting world&#8221; as the Changes entry for the first release of all my CPAN modules. Thinking about this, I cannot remember where this came from. I don&#8217;t _think_ that I invented it, but maybe I did. I do have an idea every once in a while. But I _feel_ like I got the idea from someone or something else.

A quick Google search didn&#8217;t up much except links to my own Changes files. So maybe I did invent this?

Anyone out there have any clue? I obviously don&#8217;t.

## Comments

### Comment by Gabor Szabo on 2017-08-27 22:11:01 -0500
Modules Starter includes this sentence: &#8220;First version, released on an unsuspecting world.&#8221; though you might have been the inspiration for that.

### Comment by Dave Rolsky on 2017-08-27 22:59:24 -0500
Or perhaps we both had a common inspiration.

### Comment by Diab Jerius on 2017-08-28 19:59:13 -0500
h2xs has generated this message for ages

### Comment by Dave Rolsky on 2017-08-28 21:18:44 -0500
Ah, that&#8217;s surely where I got it from then.

### Comment by Dave Rolsky on 2017-08-28 21:20:14 -0500
Except I just ran `h2xs -X Foo` now and the Changes just contains this:

> Revision history for Perl extension Foo.
> 
> 0.01 Mon Aug 28 21:19:22 2017  
> &#8211; original version; created by h2xs 1.23 with options  
> -X Foo

### Comment by Andy Lester on 2017-08-30 09:32:33 -0500
I think it&#8217;s my fault. When I wrote Module::Starter I needed something to put in the stock Changes file. I think I made up that sentence myself. My big concern was that I didn&#8217;t want the author in the boilerplate to be A. U. Thor.

It&#8217;s in Module::Starter 0.02 from 2004. <a href="http://backpan.perl.org/authors/id/P/PE/PETDANCE/Module-Starter-0.02.tar.gz" rel="nofollow ugc">http://backpan.perl.org/authors/id/P/PE/PETDANCE/Module-Starter-0.02.tar.gz</a>

### Comment by Andy Lester on 2017-08-30 09:37:10 -0500
I checked Perl 5.005 (1997) and 5.8.6 (2004) and it&#8217;s not in either of those.