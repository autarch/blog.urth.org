---
title: Making DateTime Faster and Slower
author: Dave Rolsky
type: post
date: 2016-06-05T20:27:28+00:00
url: /2016/06/05/making-datetime-faster-and-slower/
categories:
  - Uncategorized

---
I recently released a new parameter validation module tentatively called [Params::CheckCompiler][1] (aka PCC, better name suggestions welcome) (**Edit: Now renamed to [Params::ValidationCompiler][2]**). Unlike [Params::Validate][3] (aka PV), this new module generates a highly optimized type checking subroutine for a given set of parameters. If you use a type system capable of generating inlined code, this can be quite fast. Note that all of the type systems supported by PCC allow inlining ([Moose][4], [Type::Tiny][5], and [Specio][6]).

I&#8217;ve been working on a branch of [DateTime][7] that uses PCC. Parameter validation, especially for constructors, is a significant contributor to slowness in DateTime. [The branch][8], for the curious.

I wrote a simple benchmark to compare the speed of `DateTime->new` with PCC vs PV:

    use strict;
    use warnings;
    
    use Benchmark qw( timethese );
    use DateTime;
    use DateTime::Format::Pg;
    
    timethese(
        100000,
        {
            constructor => sub {
                DateTime->new(
                    year      => 2016, month  => 2,  day    => 14,
                    hour      => 12,   minute => 23, second => 44,
                    locale    => 'fr',
                    time_zone => 'UTC',
                    formatter => 'DateTime::Format::Pg',
                );
            },
        },
    );

Running it with master produces:

<pre class="crayon:false">autarch@houseabsolute:~/projects/DateTime.pm (master $%=)$ perl -Mblib ./bench.pl 
Benchmark: timing 100000 iterations of constructor...
constructor:  6 wallclock secs ( 6.11 usr +  0.00 sys =  6.11 CPU) @ <strong>16366.61/s</strong> (n=100000)
</pre>

And with the `use-pcc` branch:

<pre class="crayon:false">autarch@houseabsolute:~/projects/DateTime.pm (use-pcc $%=)$ perl -I ../Specio/lib/ -I ../Params-CheckCompiler/lib/ -Mblib ./bench.pl 
Benchmark: timing 100000 iterations of constructor...
constructor:  5 wallclock secs ( 5.34 usr +  0.01 sys =  5.35 CPU) @ <strong>18691.59/s</strong> (n=100000)
</pre>

So we can see that&#8217;s there&#8217;s a speedup of about 14%, which is pretty good!

I figured that this should be reflected in the speed of the entire test suite, so I started timing that between the two branches. But I was wrong. The `use-pcc` branch took about 15s to run versus 11s for master! What was going on?

After some profiling, I finally realized that while using PCC with Specio sped up run time noticeably, it also adds an additional compile time hit. It&#8217;s Moose all over again, though not nearly as bad.

For further comparison, I used the [Test2::Harness][9] release&#8217;s `yath` test harness script and told it to preload DateTime. Now the test suite runs slightly faster in the `use-pcc` branch, about 4% or so.</a>

So where does that leave things?

One thing I&#8217;m completely sure of is that if you&#8217;re using [MooseX::Params::Validate][10] (aka MXPV), then switching to [Params::CheckCompiler][1] is going to be a huge win. This was my original use case for PCC, since some profiling at work showed MXPV as a hot spot in some code paths. I have some benchmarks comparing MXPV and PCC I will post here some time that show PCC as about thirty times faster.

Switching from PV to PCC is less obvious. If your module is already using a type system for its constructor, then there are no extra dependencies, so the small compile time hit may be worth it.

In the case of DateTime, adding PCC alone adds a number of dependencies and Specio adds a few more to that. &#8220;Why use Specio over Type::Tiny?&#8221;, you may wonder. Well, Type::Tiny doesn&#8217;t support overloading for core types, for one thing. I noticed some DateTime tests checking that you can use an object which overloads numification in some cases. I don&#8217;t remember why I added that, but I suspect it was to address some bug or make sure that DateTime played nice with some other module. I don&#8217;t want to break that, and I don&#8217;t want to build my own parallel set of Type::Tiny types with overloading support. Plus I really don&#8217;t like the design of Type::Tiny, which emulates Moose&#8217;s design. But that&#8217;s a blog post for another day.

If you&#8217;re still reading, I&#8217;d appreciate your thoughts on this. Is the extra runtime speed worth the compile time hit and extra dependencies? I&#8217;ve been working on reducing the number of deps for Specio and PCC, but I&#8217;m not quite willing to go the zero deps route of Type::Tiny yet. That would basically mean copying in several CPAN modules to the Specio distro, which is more or less what Type::Tiny did with [Eval::Closure][11].

I&#8217;d also have to either remove 5.8.x support from DateTime or make Specio and PCC support 5.8. The former is tempting but the latter probably isn&#8217;t too terribly hard. Patches welcome, of course ;)

If I do decide to move forward with DateTime+PCC, I&#8217;ll go slow and do some trial releases of DateTime first, as well as doing dependent module testing for DateTime so as to do my best to avoid breaking things. Please don&#8217;t panic. Flames and panic in the comment section will be deleted.

**Edit:** [Also on the Perl subreddit][12].

 [1]: https://metacpan.org/release/Params-CheckCompiler
 [2]: https://metacpan.org/pod/Params::ValidationCompiler
 [3]: https://metacpan.org/release/Params-Validate
 [4]: https://metacpan.org/release/Moose
 [5]: https://metacpan.org/release/Type-Tiny
 [6]: https://metacpan.org/release/Specio
 [7]: https://metacpan.org/release/DateTime
 [8]: https://github.com/houseabsolute/DateTime.pm/tree/use-pcc
 [9]: https://metacpan.org/release/Test2-Harness
 [10]: https://metacpan.org/release/MooseX-Params-Validate
 [11]: https://metacpan.org/release/Eval-Closure
 [12]: https://www.reddit.com/r/perl/comments/4mpfko/making_datetime_faster_and_slower/

## Comments

### Comment by Sam Kaufman on 2016-06-05 20:38:54 -0500
At SocialFlow we use DateTime with our slow loading, tons of dependencies 5 year old codebase. It already takes 30 seconds on Amazon&#8217;s ridiculously slow disks to start up, so I&#8217;d much rather take a compile time hit of another second if that means DateTime will be faster during runtime.  
As for Specio v Type::Tiny, I really like Type::Tiny but it&#8217;s seeming like Toby Inkster&#8217;s CPAN contributions have slowed down since 2014, and the number of open issues for Type::Tiny is getting a little intimidating.

### Comment by Dave Rolsky on 2016-06-05 20:45:17 -0500
FWIW, when I just measured the compile time difference, it seemed to be about 100ms extra, so it was not too egregious. It does add up across the test suite, which has about 40 individual files, but I don&#8217;t think &#8220;spawn 40+ separate programs as quickly as possible&#8221; is a typical use case.

### Comment by Stefan Seifert on 2016-06-06 01:02:42 -0500
Speeding up DateTime&#8217;s constructor will help us everywhere thanks to DBIx::Class::InflateColumn::DateTime. At the same time our applications take their sweet long time to start up already, so 0.1 seconds longer compile time will probably not even be measurable. We could easily recover more than that by standardizing our dependencies (yes, I really think one file slurping module would be sufficient&#8230;).