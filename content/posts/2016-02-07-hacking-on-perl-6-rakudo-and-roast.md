---
title: Hacking on Perl 6 (Rakudo and Roast)
author: Dave Rolsky
type: post
date: 2016-02-07T20:10:42+00:00
url: /2016/02/07/hacking-on-perl-6-rakudo-and-roast/
---
I found a bug in Perl 6 recently. Really I independently discovered [one that was already reported][1].

Here's how to trigger it:

```
$ perl6 -e 'say <2147483648/3>'
===SORRY!===
Cannot find method 'compile_time_value'
```

Any numerator of 2<sup>31</sup> or greater causes that error. Note that Perl 6 is perfectly happy to represent rationals of that size or larger:

```
$ perl6 -e 'say Rat.new(2147483648, 3)'
715827882.666667
```

So the problem was clearly somewhere in the compiler.

Here's a quick guide to how I fixed this.

First, I added a test to the Perl 6 test suite. Unlike many programming languages, the primary test suite for Perl 6 is not in the same repo as the compiler. Instead, [it has its own repo, roast][2]. Roast is The Official Perl 6 Test Suite, and any toolchain which can pass the test suite is a valid Perl 6.

In this particular case, I added a test to `S32-num/rat.t`. The test makes sure that a Rat value with a large numerator can round trip via the `.perl` method and `EVAL`:

```
is(Rat.new(807412079564, 555).perl.EVAL, Rat.new(807412079564, 555), '807412079564/555 round trips without a compile_time_value error');
```

Running this with the latest Rakudo caused the test to blow up with the same error as my first example. Success! Well, failure, but success at failing the way I wanted it to.

Next I had to figure out where this error was happening. This can be a bit tricky with compiler errors like this. The best way to get a clue to the problem's location is to pass `--ll-exception` as a CLI flag:

```
 perl6 --ll-exception -e 'say <2147483648/3>'
annot find method 'compile_time_value'
  at gen/moar/m-Perl6-Actions.nqp:7230  (/home/autarch/.rakudobrew/moar-nom/install/share/nqp/lib/Perl6/Actions.moarvm:bare_rat_number:35)
from gen/moar/stage2/QRegex.nqp:1342  (/home/autarch/.rakudobrew/moar-nom/install/share/nqp/lib/QRegex.moarvm:!reduce:29)
from gen/moar/stage2/QRegex.nqp:1303  (/home/autarch/.rakudobrew/moar-nom/install/share/nqp/lib/QRegex.moarvm:!cursor_pass:47)
from :1  (/home/autarch/.rakudobrew/moar-nom/install/share/nqp/lib/Perl6/Grammar.moarvm:bare_rat_number:133)
from :1  (/home/autarch/.rakudobrew/moar-nom/install/share/nqp/lib/Perl6/Grammar.moarvm:rat_number:64)
... [many more lines]
```

If we look at the top of the trace we see references to `Perl6/Actions.moarvm:bare_rat_number`. Looking in the rakudo repo, we can find a `src/Perl6/Actions.nqp` file that contains `method bare_rat_number($/) {...}`. This seemed like a pretty good guess at where the error was coming from.

Here's the method in full before my patch:

```
method bare_rat_number($/) {
    my $nu := @($<nu>.ast)[0].compile_time_value;
    my $de := $<de>.ast;
    my $ast := $*W.add_constant('Rat', 'type_new', $nu, $de, :nocache(1));
    $ast.node($/);
    make $ast;
}
```

After doing some dumping of values in the AST with code like `note($<nu>.dump)`, I realized that the numerator could end up being passed in as either a `QAST::Want` or `QAST::WVal` object. What are these and how do they differ? Why is there a break at 2<sup>31</sup>? I have no clue!

However, I could see that while a `QAST::Want` object could be treated as an array, a `QAST::WVal` could not. Fortunately, both objects support a `compile_time_value` method. Looking at this method's implementation in `QAST::Want` I could see that it was getting the first array element from the object's internals, while `QAST::WVal` implemented this differently. But since they both implement the same method why not just call it and be done with it?

Here's the patched method:

```
method bare_rat_number($/) {
    my $nu := $<nu>.ast.compile_time_value;
    my $de := $<de>.ast;
    my $ast := $*W.add_constant('Rat', 'type_new', $nu, $de, :nocache(1));
    $ast.node($/);
    make $ast;
}
```

All the tests passed, so I think I fixed it.

Overall, this wasn't too hard. Because much of Perl 6 is either written in Perl 6 or in NQP (a subset of Perl 6), fixing the core can be much easier than with many other languages, especially most dynamic languages which are implemented in C.

 [1]: https://rt.perl.org/Ticket/Display.html?id=126873
 [2]: https://github.com/perl6/roast
