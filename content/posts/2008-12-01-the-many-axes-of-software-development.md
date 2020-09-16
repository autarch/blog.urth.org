---
title: The Many Axes of Software Development
author: Dave Rolsky
type: post
date: 2008-12-01T21:33:33+00:00
url: /2008/12/01/the-many-axes-of-software-development/
---
People want many things from software, and those desires are often contradictory. There's a constant back and forth about what people want from CPAN modules, in particular. It seems like we have the same arguments year after year. I think talking about priorities before talking about why something is good or bad is crucial.

So what are these priorities? How do they work together? Which ones are contradictory? Which ones are most important to you, and when do the priorities shift?

(Note: when I say library below, mentally substitute "module, library, distro, or framework")

  * **Well-vetted** - When looking for a library, you might want something other people have already used for a while. You want to know that it does what it says on the box, and that most of the big bugs have been found. 
  * **Cutting Edge** - Some folks like to use new stuff. It's fun to experiment, and often the new stuff is the most advanced, most interesting, most time-saving. It could also be the biggest new piece of shit, the buggiest, slowest, etc. 
  * **Dependency free** - The CPAN dependency discussion never goes away. Some people really, _really_ don't like large dependency chains. When you want to use a module as part of an app, and you want non Perl gurus to install that app, this becomes a huge issue. Telling them "just install these 100 modules from CPAN" doesn't cut it. 
  * **Small (does one thing)** - Less code means less bugs. It also means less docs to read, and makes a library simpler to learn. 
  * **Easy to integrate** - Some libraries are designed to be integrated with other modules (Catalyst), some want you to embrace their world (Jifty). 
  * **Complete** - Some libraries come with a complete solution (Jifty) and some require you to put together a bunch of pieces into a whole (Catalyst). 
  * **Fast** - Sometimes speed (of compilation and/or execution) really matter. 
  * **Memory frugal** - Just like with speed, sometimes memory usage matters. 
  * **No XS** - Sometimes you're stuck using a system where you can't compile anything. Or maybe you have a compiler, but the module requires external C libraries, and you can't install them (a hosted account). 
  * **Active development** - Maybe you feel more comfortable knowing the module has a future, even if that means a higher rate of change. 
  * **Stable** - On the other hand, maybe you want something that's just done, where you know new releases will be infrequent and backwards compatible. 

I'm sure there are more priorities (feel free to mention some in the comments). It's easy to say we want all of these things, but there are many, many conflicts here. I won't go into all of them, but here's a few examples.

If you want **well-vetted**, you're not going to be using **cutting edge** code.

If you want **dependency free**, that code is probably not **well-vetted**. That dependency free code probably has some reinvented wheels, and those wheels are probably less round than the dependency they avoid.

If you want **fast** or **memory frugal**, you probably can't also insist on **no XS**. If you want **complete** solutions, than **small** and **easy to integrate** may go out the window.

Personally, my top priorities are usually **small**, **easy to integrate**, and **active development**. I'd rather learn several small pieces and put them together than try to digest a big framework all at once. And I'd rather have an active community, even if I have to keep up with API changes.

I don't care _too_ much about **fast** or **memory frugal**. I work on a lot of webapps, which are often less demanding performance wise, at least if you can count on a dedicated server or two. Contrast this to a small "throw it in cgi-bin" app. Webapps also often have a lot of opportunities for speed improvements at the application level with caching and other strategies, so I worry less about the underlying libraries.

I'd much prefer **well-vetted** to **dependency free**. I think the latter is an entirely false economy, and what we really need are much, much better installer tools.

But these are just my priorities for the work I do most often. If I were working on an embedded data-crunching app, I'm sure my priorities would change quite a bit!

I'd like to see people state their priorities up front, and explain why it's important for the work they do. Often this gets left out of the discussion. Without this information, we often end up just talking past each other.

## Comments

**Geoffrey Broadwell, on 2008-12-03 13:00, said:**  
I often find that I don't need truly 'fast' or 'memory frugal', but rather just not 'slow as molasses' or 'thrashing swap on small data sets'. Other times my requirements are a bit higher - 'not egregiously wasteful'. Even modules that I swear by and recommend to everyone occasionally trip over that requirement.

Years ago, when I first found DateTime, I needed it for an app that stored all times in UTC and did on-the-fly conversion to/from other timezones. For one particular use case, I needed thousands of DateTime objects - and DateTime object instantiation was by far the performance bottleneck. It turns out this is because DateTime::new() is bulletproofed to the hilt, checking for all sorts of insanity. Normally that's a good thing, but all of the times in question were already \*guaranteed\* valid - because they had been processed and vetted by DateTime during input, before being serialized to storage.

All of the DateTime::new() bulletproofing was completely wasted, and I ended up having to monkey patch an additional constructor that skipped all of the bulletproofing and just did the absolute minimum needed to instantiate a valid object set to the requested time. The performance difference was night and day.

These days I often find myself taking a peek under the covers of any library I am considering, looking for pervasive wastefulness. Partially that's because I find efficiency, clean design, and low bug count to be correlated (though clearly not always found together, sadly). And partially it's because I always end up needing to use the library for a much bigger data set than the author ever intended or tested with. A little spelunking up front can vastly reduce the probability of a huge "uh-oh" the first time your app runs into production data volumes ....

**Dave Rolsky, on 2008-12-03 14:31, said:**  
DateTime's bulletproofing may be wasteful for your use case, but it's not wasteful as a general practice (it's called defensive programming).

If I didn't do that, I'd have _someone else_ complaining that they instantiated a DateTime object and it gave them all sorts of crazy output, and then it'd turn out that they gave it a month of 27 and a day of -1 (I'm looking at you, MySQL, with your 0000-00-00 "dates").

Personally, I prefer to write code that protects me against my (and other's) stupid mistakes.

FWIW, Params::Validate, which DateTime uses, has an ENV flag you can set to turn off validation, though it still does a little work to provide defaults.

In an ideal world, this sort of thing would be built into the language (ala Haskell or Perl 6, for example), and would be well-optimized. Sadly, Perl 5 doesn't have that option.

**Geoffrey Broadwell, on 2008-12-03 22:12, said:**  
Regarding this particular case:

I am in no way claiming that the default constructor should allow garbage data. I'm saying that there are times when the programmer knows that the data could not possibly be invalid, so checking (and rechecking) it is just a waste. It would be useful to provide a "raw" constructor with a little more trust and performance.

Now it's fair to say that there will always be programmers that think they know something bad is impossible, and are completely wrong, and you'd like to defend against that. Fair enough.

So what about places that DateTime _itself_ knows the data can't be invalid, because it generated it internally? For example, I ran '`for (1 .. 10_000) {my $dt = DateTime->today}`' through NYTProf, just for kicks. On my machine, the inclusive time for DateTime::today was 15.2 seconds (or 13.1 seconds with PERL\_NO\_VALIDATION=1). That's about 1.5ms per today() call, and several hundred times slower than using gmtime() directly.

So where does the extra time go? Well, among other things, for each today() call, Params::Validate::_validate() is called _five_ times. Twenty functions are called more than once, largely because new() is called twice - and thus all of its children are as well. Almost the entire work of that second construction is wasted. In fact, much of the work of the _first_ construction is wasted, because in the today() => now() => from_epoch() => new() chain, each caller creates arguments for its callee that are sane (and a special case), and then each callee processes and validates these arguments under the assumption that they are fully general and not sane.

In short:

I'm all for defensive programming, but at some point it's worth considering a fast path for internal work - validate all you want at the API border, and run clean and fast within your class's own code. If the real fear is that you might hand garbage between your class's internal functions, then that indicates a bigger problem - one that may be better solved with other software engineering methodologies that have less runtime impact.

In general:

Engineering software with the goal of optimizing one of the axes you list in your original post (or even two or three) does not mean ignoring all of the other axes. Any popular CPAN module will be used in numerous circumstances that the author never imagined - but they will be ignored by anyone who cares about an axis for which the module is completely off the "bad end". Trying to avoid being egregiously bad on any axis is a good thing.

**Dave Rolsky, on 2008-12-03 22:33, said:**  
Clearly you've identified some potential spots for improvement, and you've profiled. Next step is to submit some code. Personally, for me, DateTime works quite well as-is, despite being slow.

But I certainly wouldn't object to making it faster, I just don't have the tuits.

Patches welcome!