---
title: Dependencies Rule
author: Dave Rolsky
type: post
date: 2009-05-02T18:55:21+00:00
url: /2009/05/02/dependencies-rule/
categories:
  - Uncategorized

---
Dear whiners-about-dependencies,

Please stop whining.

Recently, there was a [thread on Perlmonks][1] which included the quote, &#8220;the dependency chain on Moose and MooseX is &#42;long&#42;.&#8221;

What is &#8220;long&#8221; here? Moose really doesn&#8217;t have that many dependencies. Also, conflating Moose with a bunch of Moose extensions is just weird.

Chris Prather then [wrote a blog post explaining why Moose has each dependency][2]. That was nice of him, but I&#8217;m not sure addressing the whiners like this is worthwhile. Moose&#8217;s dependencies need no justification. We Moose authors thought we needed them, so we used them. End of story.

I really don&#8217;t understand why people complain about dependencies. CPAN is what makes Perl great. It certainly isn&#8217;t the Perl 5 language itself, which is getting a bit long in the tooth. Without Moose, Catalyst, DateTime, DBIC, etc. how interesting would Perl 5 be compared to its numerous competitors? If you want a brilliant language where you can write everything from scratch, I suggest Haskell.

If you&#8217;re going to use Perl, you need to figure out how you will handle dependencies for your applications. There are a lot of options for managing them, including:

  * Writing everything from scratch instead.
  * Copying modules wholesale into your source tree.
  * Copying tarballs into your source tree, and installing them as part of your build process.
  * Using/making packages for your system of each dependency.
  * Maintaining a local CPAN and installing from it.
  * Installing things from CPAN directly and hoping nothing breaks.
  * Some combination of the above.

These are all possible solutions (though the first is for idiots). Whining to module authors that they have &#8220;too many&#8221; dependencies is not a solution.

As an aside, at what point would the whiners stop whining? If Moose had half as many deps, would the whining end? I doubt it.

I will offer one sop to the whiners. If you as a module author are depending on a module, I hope you&#8217;re willing to help maintain that dependency. That means passing on bug reports (people will report a dependency&#8217;s bugs to you), writing patches, and generally helping keep your dependency chain installable.

 [1]: http://perlmonks.org/?node_id=760581
 [2]: http://chris.prather.org/perl/moose-dependencies-a-lurid-tale/

## Comments

### Comment by Vince Veselosky on 2009-05-02 21:53:20 -0500
Dave, I&#8217;m pretty sure the reason people hate long dependency chains is Murphy&#8217;s Law of CPAN: the odds of an installation failing increase as the square of the number of dependencies.

I have found the &#8220;recommended&#8221; Moose modules to be stable and install cleanly along with all their dependencies. I had some minor trouble installing some of the more experimental extensions, but that&#8217;s why they are marked &#8220;experimental&#8221;.

I think your last paragraph is key. Phrased another way, if your module depends on something that is broken, then your module is broken. But as long as quality is maintained down the whole chain, extra dependencies are just extra installation time and not that expensive.

Vince Veselosky  
<a href="http://www.webquills.net" rel="nofollow ugc">http://www.webquills.net</a>

### Comment by Dave Rolsky on 2009-05-02 22:01:01 -0500
Broken dependencies in the chain are annoying, but shit happens. No one purposely depends on a broken module.

The risk of bugs in the chain is no different than risk of bugs in the &#8220;primary&#8221; module. Either way, you as an end user have to rely on someone not to screw up.

So maybe you can trade off installation problems for problems with all the wheel reinvention needed to avoid a dependency. There&#8217;s no free lunch.

Being lazy myself, I prefer to depend on other modules when writing my own code. Sure, I may have to help fix those too, but I think ultimately the end product will be less buggy if I take advantage of other people&#8217;s work.

### Comment by Aristotle Pagaltzis on 2009-05-02 23:58:17 -0500
The one substantial argument against huge dependency chains is conceptual coherence. (Or characterised from the flip side, “bloat”.)

As you use more and more modules, chances increase rapidly that you’ll end up pulling in 6 different modules that all solve roughly the same problem – as third-order (or more) dependencies somewhere down the chain of modules written by other people who relied on stuff written by still other people.

As long as you take care to examine your full dependency chain (and note that you need to do this continuously as new releases of your dependencies come out) and make your choices of dependencies in such a manner as to keep it coherent (at least largely – going through contortions to avoid every last bit of duplication would be silly too), a large dependency list is _good_.

### Comment by Dominic Mitchell on 2009-05-03 01:50:26 -0500
For me the thing isn&#8217;t dependency chain — it&#8217;s great that you&#8217;re getting code reuse.

It&#8217;s how painful dependencies are to manage in Perl. Particularly when you start considering multiple heterogenous servers that all need to be kept in sync. And CPAN.pm&#8217;s tendency to upgrade to the latest of everything. And dependencies tend to be installed into the Perl installation. It&#8217;s more difficult to pull them along with your code base.

### Comment by Dave Rolsky on 2009-05-03 09:41:43 -0500
@Aristotle: That is indeed annoying, but there&#8217;s not much to be done about it. That&#8217;s the price of TIMTOWTDI and CPAN&#8217;s rampant wheel re-invention. I&#8217;d love it if people standardized on Moose for OO helper, but that&#8217;s not gonna happen, so I&#8217;m stuck installing Moose, Mouse, Class::Accessor::*, and probably a few others.

I&#8217;m not going to drop a really useful dependency because it doesn&#8217;t use \_my\_ choice of helper modules.

@Dominic: Yes, it can be painful. I mentioned some potential solutions in my original posting. Using CPAN.pm to manage dependencies for an app really doesn&#8217;t cut it, unless you maintain your own own controlled CPAN mirror. That plus local::lib could be a good solution, especially if you&#8217;re installing to a system with >1 Perl application.

Otherwise, creating packages for your platform is the only other sane solution.

### Comment by Yuval Kogman on 2009-05-03 10:15:11 -0500
Umm, <a href="http://hackage.haskell.org/" rel="nofollow ugc">http://hackage.haskell.org/</a>

I think nowadays Hackage has almost as many uploads per day as CPAN.

There are many other languages in which you need to reinvent everything from scratch, but Haskell is definitely not one of them.

### Comment by Stephen Downes on 2009-05-03 10:25:01 -0500
When legitimate comments are called &#8220;whining&#8221;, that is the first sign that the critics are probably right.

### Comment by Dave Rolsky on 2009-05-03 10:53:22 -0500
I wasn&#8217;t suggesting Haskell had nothing, just that it&#8217;s way behind Perl and CPAN. Just take a look on hackage for datetime or email packages, to pick tow.

### Comment by Dave Rolsky on 2009-05-03 11:20:07 -0500
@Stephen: Did you read the Perlmonks thread in question? Seemed like a lot net.kookery to me.

I particularly liked BrowserUK&#8217;s suggestion that every module author should be using AutoLoader and AutoSplit to save piddly amounts of memory. Of course, the cost for this is bizarro installs that look nothing like the original source, and serious memory \_abuse\_ in persistent forking environments like mod_perl or FastCGI.

I really don&#8217;t see how one can legitimately tell a CPAN author not to use other CPAN modules. If you don&#8217;t like modules that use other modules, don&#8217;t use said modules. Write your own &#8220;all-in-one&#8221; distro, but stop whining about the work I did for free.

If you can see a sane, not-too-much-work-for-me method to eliminate some dependencies, I&#8217;d be glad to hear about it. But any suggestion that involves &#8220;just write your own X&#8221; will be summarily dismissed as the net.kookery it is.

### Comment by Jonathan Rockway on 2009-05-04 13:07:32 -0500
Haskell was a poor example to choose for a language where nothing has dependencies. Most Haskell apps have pretty long dependency chains, but the &#8220;cabal&#8221; packaging system and installation tool is so excellent that most people don&#8217;t notice. It is light years ahead of cpan (the script).

Anyway, perhaps you meant PHP?

### Comment by Dave Rolsky on 2009-05-04 13:15:40 -0500
@J Rockway: I was trying to pick a language that was both attractive as a language, and not attractive for its vast library of great libraries. I think Haskell qualifies. It does have libraries and hackage, but compared to Perl, it&#8217;s selection of libraries is pretty weak (and the library docs are nearly all terrible, just a list of functions with the input & output argument types).

PHP definitely does satisfy the &#8220;no vast library&#8221; part, but it&#8217;s not attractive.

Shawn Moore suggested Scheme on #moose.

### Comment by Justin Mason on 2009-05-08 09:19:00 -0500
I disagree that this is just &#8220;whining&#8221;. One poster in that perlmonks thread noted that Catalyst 5.8 now depends (directly or indirectly) on over 250 modules of non-core dependencies. ouch!

Chris Prather&#8217;s post was a little misleading; by just focussing on the direct deps, he ignored the \_indirect\_ dependencies, which clearly add up very quickly if the above is correct. One has to consider both.

In SpamAssassin, we&#8217;ve been very careful to avoid adding deps when we can avoid it, because this is a major pain point for our users. It makes the developer&#8217;s job easier by pushing pain onto our users, and that&#8217;s not a good way to go about writing \*usable\*, \*user-friendly\* open source software, in my opinion. If it means we&#8217;ll have to duplicate a few line s of code that we could import from CPAN, so be it.

### Comment by Dave Rolsky on 2009-05-08 09:29:13 -0500
@Justin: You&#8217;ve avoided one pain point, but there&#8217;s a big cost.

You&#8217;ve probably had to reinvent a bunch of wheels. That takes time, and has the potential to introduce a lot more bugs into SpamAssassin. It&#8217;s also a cost you&#8217;re basically stuck with forever, because once you write the code you&#8217;re on the hook to maintain it going forward.

I&#8217;m not sure why you&#8217;d say &#8220;ouch&#8221; to Catalyst&#8217;s dependencies.

First, just citing a number is extremely misleading. If you&#8217;re using Catalyst to write your own application, chances are you will directly depend on some of its dependencies, so it&#8217;s not 250 _new_ modules.

Second, assuming that all those dependencies install cleanly, what&#8217;s the problem?

Yes, that&#8217;s a big assumption. But the goal should not be &#8220;less dependencies&#8221;, it should be &#8220;the entire chain installs cleanly&#8221;.