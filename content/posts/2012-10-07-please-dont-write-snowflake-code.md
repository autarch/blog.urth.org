---
title: Please Don’t Write Snowflake Code
author: Dave Rolsky
type: post
date: 2012-10-07T20:09:27+00:00
url: /2012/10/07/please-dont-write-snowflake-code/
---
[Rocky Bernstein][1] has been working a new Perl debugger called [Devel::Trepan][2]. I came across some discussion in a [git pull request for this project][3] a while back and I've been thinking of this blog post since that time.

Rocky has his own unique coding style. It's not too out there. There are some truly [oddball styles on CPAN][4]. But there a few oddities that stand out. First, he puts various `use` lines _before_ the package declaration. He also uses prototypes completely pointlessly (prototypes on methods do absolutely nothing). He also likes to combine several statements onto one line, like:

    use strict; use warnings;
    

or

    use strict; use vars qw(@ISA); @ISA = @CMD_ISA;
    

Besides the prototype issue, none of these are wrong (and the prototype thing is arguably intended as documentation). The code works as written, and the meaning is more or less clear.

But it's weird, because it's not what most people other do. It's a unique snowflake.

It's a distraction.

Instead of looking at the code, experienced Perl programmers will spend time going "WTF" and wondering why this code looks different from all the other code they've seen.

If you're writing code that you'd like other people to work on, please don't write unique snowflake code. Every moment someone spends being a bit confused by your unique style is a moment that they're not spending improving the code. It's time they're not spending fixing bugs, adding tests, writing docs, or adding new features.

One might argue that we should just accept the oddities but it's often hard to distinguish between a style and code which changes a program's execution.

Please pick from one of a few standard styles (2- or 4-space indent, braces in a sane place, one statement per line, package comes first, etc). Include a perltidyrc that contributors can use to match your style. If your style can't be recreated using perltidy you're probably writing snowflake code. Please don't. It's just code. It's not that special. Save the unique snowflakes for your symphonies, sculputures, and sonnets.

 [1]: https://metacpan.org/author/ROCKY
 [2]: https://metacpan.org/release/Devel-Trepan
 [3]: https://github.com/rocky/Perl-Devel-Trepan/pull/3
 [4]: https://metacpan.org/source/DOMIZIO/HTML-TableTiler-1.21/lib/HTML/TableTiler.pm

## Comments

**djzort.myopenid.com, on 2012-10-07 23:37, said:**  
You are more or less describing why python was created.

Perltidy is great because you can just code code code code code, then with one command make it all pretty. Its like having someone in your toolshed cleaning up after you as you work.

One helper for perltidy which i am not yet aware of, would be a copy of 'well known' standard coding formats which people can easily select.

**holybit.myopenid.com, on 2012-10-08 08:17, said:**  
Agreed. Worse, oddball styles inevitably turn people away from contributing to FLOSS projects. As a project maintainer if you don't get or know the basic style conventions of your chosen language platform it's a strong code smell.

**stevenharyanto, on 2012-10-09 19:16, said:**  
Python doesn't prevent you from putting multiple statements in one file (or many other things) though :)

I think it's okay to have a personal style, and if a project is yours, you reserve the right to dictate the style of the project. But if you contribute to other people's project, please follow that project's style.

**Dave Rolsky, on 2012-10-10 11:13, said:**  
@Steven: Of course it's okay to do anything what you want. My blog post isn't about right and wrong, it's just an opinion and a request.

If you want other people to contribute to your project, I think it's better to adopt a common style rather than a personal one.