---
title: Please Don’t Write Snowflake Code
author: Dave Rolsky
type: post
date: 2012-10-07T20:09:27+00:00
url: /2012/10/07/please-dont-write-snowflake-code/
categories:
  - Uncategorized

---
[Rocky Bernstein][1] has been working a new Perl debugger called [Devel::Trepan][2]. I came across some discussion in a [git pull request for this project][3] a while back and I&#8217;ve been thinking of this blog post since that time.

Rocky has his own unique coding style. It&#8217;s not too out there. There are some truly [oddball styles on CPAN][4]. But there a few oddities that stand out. First, he puts various `use` lines _before_ the package declaration. He also uses prototypes completely pointlessly (prototypes on methods do absolutely nothing). He also likes to combine several statements onto one line, like:

    use strict; use warnings;
    

or

    use strict; use vars qw(@ISA); @ISA = @CMD_ISA;
    

Besides the prototype issue, none of these are wrong (and the prototype thing is arguably intended as documentation). The code works as written, and the meaning is more or less clear.

But it&#8217;s weird, because it&#8217;s not what most people other do. It&#8217;s a unique snowflake.

It&#8217;s a distraction.

Instead of looking at the code, experienced Perl programmers will spend time going &#8220;WTF&#8221; and wondering why this code looks different from all the other code they&#8217;ve seen.

If you&#8217;re writing code that you&#8217;d like other people to work on, please don&#8217;t write unique snowflake code. Every moment someone spends being a bit confused by your unique style is a moment that they&#8217;re not spending improving the code. It&#8217;s time they&#8217;re not spending fixing bugs, adding tests, writing docs, or adding new features.

One might argue that we should just accept the oddities but it&#8217;s often hard to distinguish between a style and code which changes a program&#8217;s execution.

Please pick from one of a few standard styles (2- or 4-space indent, braces in a sane place, one statement per line, package comes first, etc). Include a perltidyrc that contributors can use to match your style. If your style can&#8217;t be recreated using perltidy you&#8217;re probably writing snowflake code. Please don&#8217;t. It&#8217;s just code. It&#8217;s not that special. Save the unique snowflakes for your symphonies, sculputures, and sonnets.

 [1]: https://metacpan.org/author/ROCKY
 [2]: https://metacpan.org/release/Devel-Trepan
 [3]: https://github.com/rocky/Perl-Devel-Trepan/pull/3
 [4]: https://metacpan.org/source/DOMIZIO/HTML-TableTiler-1.21/lib/HTML/TableTiler.pm

## Comments

### Comment by djzort.myopenid.com on 2012-10-07 23:37:36 -0500
You are more or less describing why python was created.

Perltidy is great because you can just code code code code code, then with one command make it all pretty. Its like having someone in your toolshed cleaning up after you as you work.

One helper for perltidy which i am not yet aware of, would be a copy of &#8216;well known&#8217; standard coding formats which people can easily select.

### Comment by holybit.myopenid.com on 2012-10-08 08:17:31 -0500
Agreed. Worse, oddball styles inevitably turn people away from contributing to FLOSS projects. As a project maintainer if you don&#8217;t get or know the basic style conventions of your chosen language platform it&#8217;s a strong code smell.

### Comment by stevenharyanto on 2012-10-09 19:16:46 -0500
Python doesn&#8217;t prevent you from putting multiple statements in one file (or many other things) though :)

I think it&#8217;s okay to have a personal style, and if a project is yours, you reserve the right to dictate the style of the project. But if you contribute to other people&#8217;s project, please follow that project&#8217;s style.

### Comment by Dave Rolsky on 2012-10-10 11:13:27 -0500
@Steven: Of course it&#8217;s okay to do anything what you want. My blog post isn&#8217;t about right and wrong, it&#8217;s just an opinion and a request.

If you want other people to contribute to your project, I think it&#8217;s better to adopt a common style rather than a personal one.