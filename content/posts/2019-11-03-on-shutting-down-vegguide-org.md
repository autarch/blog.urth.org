---
title: On Shutting Down VegGuide.org
author: Dave Rolsky
type: post
date: 2019-11-03T23:35:17+00:00
url: /2019/11/03/on-shutting-down-vegguide-org/
---
After 17 years (or so) of operation, I'm [shutting down VegGuide.org][1]. You can read more about why by following that link.

When I created the site, I was 28 (which means I'm now 45). Creating the site was a **lot** of work, and I did it in my "free" time outside of paying work. I think at the time I was doing consulting work and probably not working full time. I do miss the ability to simply put a huge amount of time and focus into a personal project, and I won't rule out going back to consulting in the future.

But what really amazes me is that I somehow did major work on the site in 2005 and 2008 while working full time jobs. I just don't have that kind of energy or focus any more.

I think the site provides an interesting lesson about technology choices. It's still running using [Alzabo][2], an ORM I created back in 2000. It has not aged well. While it definitely made creating the site faster than using no ORM at all, it became an increasingly large millstone as time went on, and ultimately ended up being a huge blocker to making progress later on. Ironically, one of the biggest problems was that I forgot how to use it over time! Alzabo never saw huge adoption, so I gave up on it in favor of [DBIx::Class][3] in my professional work. Then I'd come back to work on something in VegGuide and I'd have to try to remember how Alzabo worked, only to forget it again.

I had a branch to convert the site to DBIx::Class, but it was a huge amount of work and I couldn't make much headway. This comes back to the issues of free time, focus, and energy. For large changes like this conversion, what I really needed was 2-4 weeks of full time work with no distractions. But what I had instead was evenings and weekends. Just ramping up to where I'd left off in terms of mental context would consume much of the time I had to do any work, leaving very little time to actually make progress.

I think this is a general symptom of volunteer efforts led by one or a very few people. It's really hard to sustain whatever initial energy and time went into its creation, especially over longer periods of time as the creators age. The ideal is to build a larger community and find ways to break tasks up small chunks so that many people can work in parallel. But that would've been incredibly hard to do with the ORM conversion project I tried, and it's not like there was a huge pool of volunteers clamoring to do the work even if I could've broken it up.

Another interesting topic to reflect on is the rise of mobile devices. As I noted on the shutdown page on VegGuide.org, we never had a mobile app or even a mobile-friendly website design. A number of people told me this was a big problem, but again, there was a major capacity issue here.

Nowadays it's entirely unthinkable to create a website that doesn't work on your phone. And it's quite easy to create a mobile-friendly site, with endless tools and frameworks to choose from. But the last VegGuide redesign was in 2008, and the idea of responsive design was just becoming mainstream around that same time. While I now understand responsive design reasonably well (for someone who's not a UI/UX designer), at the time it was just too much for me to think about.

If there's one thing I've taken away from all this, it's that I should think long and hard about the future prospects of any project I might take on. Do I have any expectation that others will want to contribute to it? If not, is it small enough that I can work on it once a month and load its context into my brain quickly? If neither of those things is true, I probably shouldn't even start.

Of course, I say that while having recently made abortive attempts at huge projects like creating a godoc.org alternative! But on the plus side I try to structure my work on these sorts of projects so that even if I can't finish them, I learn something along the way.

So what's the takeaway? While I'm sad that the site is shutting down I think it was worthwhile to create it. I hope it helped people eat fewer animals. I hope it pushed competitors like [HappyCow][4] to make some changes for the better, like accepting listings for restaurants which are not 100% vegetarian. 

And I'm looking forward to saving $23 per month in hosting fees.

 [1]: https://www.vegguide.org/site/shutdown
 [2]: https://metacpan.org/release/Alzabo
 [3]: https://metacpan.org/release/DBIx-Class
 [4]: https://www.happycow.net/

## Comments

**XAkk G. Asphodel, on 2019-11-07 08:35, said:**  
Dave - thanks for the years of having this available! I still use it when I travel, and I don't own a mobile device of my own (just work), so I do plenty of research from my desktop. I missed the shutdown note the last two times I used it, and after finding (as you said) a couple too many outdated listings for an upcoming trip, I thought there might be something up. I should start noticing little changes like a link to an explanation right there on the page, I suppose.

Cheers and don't spend that $46/month in one place, as they say!

-XAkk

**Larry Sherwood, on 2019-11-11 06:49, said:**  
As a fellow vegetarian, semi-vegan, I am saddened to read this. Disappointed in myself that, while supporting various vege and animal rights organizations, I never paid attention to VegGuide.  Moreover, I never connected it to the Perl world.  My bad, and thank you for your efforts to reduce the wholly unnecessary suffering of animals.

**Chris Homsey, on 2019-11-13 16:45, said:**  
Dave, I so appreciate the effort you put into creating and running VegGuide. Looks like I registered on the site when I was a vegetarian, but it became an invaluable resource when I went vegan in 2011, as some of the other sites weren’t as helpful at the time. VegGuide is also how I first heard about CAA. Thank you!!!  
&nbsp;

**Mark Mathew Braunstein, on 2019-11-27 18:01, said:**  
Dave -  
I am saddened by this news.  
VegGuide initially was my 1st choice for both browsing and contributing, then along came HappyCow, at which time I browsed and contributed to both. Slowly, slowly, I noticed updates on HC that never made it onto VG, and then you know the rest.  
Conde Kedar, at one time more than merely a content contributor but I believe also a VG (volunteer?) staff member, certainly kept listings up to date on the Connecticut scene when he was a student I think at Yale, so VG probably remained relevant in CT longer than elsewhere. His reviews, by the way, were stellar.   
I read your "farewell speeches" both here and on VG itself, and I commend you for your vision and dedication. My best regards to you on your future projects.  
- Mark Mathew Braunstein

**Dave Rolsky, on 2019-11-27 18:10, said:**  
Thanks, Mark.

For the record, HappyCow predates VegGuide by several years. Kedar was a (wildly prolific) volunteer, VegGuide never had any staff (which is part of what caused it to fall behind HappyCow, no doubt).
