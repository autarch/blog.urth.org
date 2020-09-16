---
title: Using Test2 to (Re-)Implement Test::Class::Moose
author: Dave Rolsky
type: post
date: 2016-02-25T17:46:40+00:00
url: /2016/02/25/using-test2-to-re-implement-testclassmoose/
---
I've been on vacation for the past week, and I decided to take a look at using [Test2][1] to reimplement the core of [Test::Class::Moose][2].

`Test::Class::Moose` (TCM) lets you write tests in the form of Moose classes. Your classes are constructed and run by the TCM test runner. For each class, we constructor instances of the class and then run the `test_*` methods provided by that instance. We run the class itself in a subtest, as well as each method. This leads to a lot of nested subtests (I'll tell you why this matters later). Here's an example TCM class:

```perl
package TestFor::Yoyodyne::Person;

use Test::Class::Moose;
use Yoyodyne::Person;

sub test_person_names {
    my $self = shift;

    my $person = Yoyodyne::Person->new( first => 'Shara', last => 'Worden' );
    is( $person->full_name, 'Shara Worden', 'full_name method' );
    is( $person->formal_name, 'Ms. Worden', 'formal_name method' );
}
```

Currently, TCM is implemented on top of the existing Perl test stack consisting of [`Test::Builder`, `Test::More`][3], etc.

The fundamental problem with the existing test stack is that it is not abstract enough. The test stack is all about producing [TAP][4] (the Test Anything Protocol). This is the text-based format (mostly line-oriented) that you see when you run [`prove -v`][5]. It's possible to produce other types of output or capture the test output to examine it, but it's not nearly as easy as it should be.

TAP is great for end users. It's easy to read, and when tests fail it's usually easy to see what happened. But it's not so great for machines. The line-oriented protocol isn't great for things like expressing a complex data structure, and the output format simply doesn't allow you to express certain distinctions (diagnostics versus error messages, for example). Even worse is how the current TAP ecosystem handles subtests, which can be summarized as "it doesn't handle subtests at all". Here's an example program:

```perl
use strict;
use warnings;

use Test::More;

ok( 1, 'test 1 ' );
subtest(
    'this gets weird',
    sub {
        ok( 1, 'subtest 1' );
        print "    not ok 2\n";
        print "    not ok 3\n";
    }
);
ok( 1, 'test 3' );

done_testing();
```

If we run this via `prove -v` we get this:

```
~$ prove -v ./test.t
./test.t ..
ok 1 - test 1
\# Subtest: this gets weird
ok 1 - subtest 1
not ok 2
not ok 3
1..1
ok 2 - this gets weird
ok 3 - test 3
1..3
ok
All tests successful.
Files=1, Tests=3, 0 wallclock secs ( 0.02 usr 0.00 sys + 0.03 cusr 0.00 csys = 0.05 CPU)
Result: PASS[/plain]
```

What happened there? Well, the TAP ecosystem more or less ignore the **contents** of a subtest. Any line starting with space is treated as "unknown text". What `Test::Builder` does is keep track of the subtest's pass/fail status in order to print a test result at the next level up the stack summarizing the subtest. That's the `ok 2 - this gets weird` line up above. Because it's not actually parsing the contents of the subtest, it doesn't see that the test count is wrong or that some tests have failed.

In practice, this won't affect most code. As long as all your tests are emitted via Test::Builder you're good to go. It does make life **much** harder for tools that want to actually look at the contents of subtests, in particular tools that want to emit a non-TAP format.

The core test stack tooling around concurrency is also fairly primitive. The test **harness** supports concurrency at the process level. It can fork off multiple test processes, track their TAP output separately, and generate a summary of the results. However, you cannot easily fork from inside a test process and emit concurrent TAP.

This concurrency issue really bit `Test::Class::Moose`. Unlike traditional Perl test suites, with TCM you normally run all of your tests starting from a single `whatever.t` file. That file contains just a few lines of code to create a TCM runner. The runner loads all of your test classes and executes them. Here's an example:

```perl
use strict;
use warnings:

use Test::Class::Moose::Load 't/lib'; # test classes live here
use Test::Class::Moose::Runner;

Test::Class::Moose::Runner->new->runtests;
```

Ovid is a smart guy. He realized that once you have enough test classes, you'd really want to be able to run them concurrently. So he wrote [TAP::Stream][6]. This modules let you combine multiple streams of subtest-level TAP into a single top-level TAP stream.

This is completely and utterly insane! **This is not Ovid's fault.** He was doing the best he could with the tools that existed. But it's terribly fragile, and it's way more work than it should be. It also made it incredibly difficult to provide feature parity between the parallel and sequential TCM test execution code. The parallel code has always been a bit broken, and there was a lot of nearly duplicated code between the two execution paths.

Enter [Test2][1], which is Chad Granum (Exodist's) project to implement a proper event-level abstraction on top of all the test infrastructure. With `Test2`, our fundamental layer is a stream of events, not TAP. An event is a test result, a diagnostic, a subtest, etc. Subtests are proper first class events which can in turn contain other events.

Working at this level makes writing TCM **much** easier. There's still some trickiness involved in starting a subtest in one process but executing it's contents in another, but the amount of duplicated code is greatly reduced, and it's much easier to achieve feature parity between the parallel and sequential paths.

As a huge, huge bonus, testing tools built on top of `Test2` is a pleasure instead of a chore. The sad truth about TCM is that it was never as well tested as it should have been. The tools for testing with `Test::Builder` are primitive at best, and because of the fact that subtests are ignored by TAP, the testing tools were nearly useless for TCM.

With `Test2` we can capture and examine the event stream of a test run in incredible detail. This lets me write very detailed tests for the behavior of TCM in all sorts of success and failure scenarios, which is fantastically useful. Here's a snippet of what this looks like:

```perl
use Test2::API qw( intercept );
use Test2::Tools::Basic qw( done_testing fail ok pass );
use Test2::Tools::Compare qw( array call end event F is match T );
use Test::Events;

use Test::Class::Moose::Load qw(t/skiplib);
use Test::Class::Moose::Runner;

my $runner = Test::Class::Moose::Runner->new;

test_events_is(
    intercept { $runner->runtests },
    array {
        event Plan => sub {
            call max => 2;
        };
        event Subtest => sub {
            call name      => 'TestsFor::Basic';
            call pass      => T();
            call subevents => array {
                event Plan => sub {
                    call directive => 'SKIP';
                    call reason    => 'all methods should be skipped';
                    call max       => 0;
                };
                end();
            };
        };
        event Subtest => sub {
            call name      => 'TestsFor::SkipSomeMethods';
            call pass      => T();
            call subevents => array {
                event Plan => sub {
                    call max => 3;
                };
                event Subtest => sub {
                    call name      => 'test_again';
                    call pass      => T();
                    call subevents => array {
                        event Ok => sub {
                            call name => 'in test_again';
                            call pass => T();
                        };
                        event Plan => sub {
                            call max => 1;
                        };
                        end();
                    };
                };
                ... # more subtests in here
                end();
            };
        };
        end();
    },
    'got expected events for skip tests'
);
```

The `test_events_is` sub is a helper I wrote using the `Test2` tools. All it does is add some useful diagnostic output if the event stream from running TCM contains [`Test2::Event::Exception`][7] events. And the diagnostics from Test2 are simply beautiful:

```
$ prove -lv t/skip.t
t/skip.t ..
# Seeded srand with seed '20160225' from local date.
not ok 1 - got expected events for skip tests
# Failed test 'got expected events for skip tests'
# at t/lib/Test/Events.pm line 16.
# +-----------------------------------+-----------------------------------+---------+-----------------------------------+--------+
# | PATH                              | GOT                               | OP      | CHECK                             | LNs    |
# +-----------------------------------+-----------------------------------+---------+-----------------------------------+--------+
# | [2]->subevents()->[2]->subevents( | only methods listed as skipped sh | eq      | only methods listed as skipped sh | 58     |
# | )->[0]->reason()                  | ould be skipped                   |         | ould be skipped foo               |        |
# |                                   |                                   |         |                                   |        |
# | [2]->subevents()->[3]->pass()     | 1                                 | FALSE() | FALSE                             | 67     |
# | [2]->subevents()->[3]->subevents( |                                   |         |                                   | 77, 77 |
# | )->[2]                            |                                   |         |                                   |        |
# +-----------------------------------+-----------------------------------+---------+-----------------------------------+--------+
```

It's a lot to read but it's incredibly detailed and makes understanding why a test failed much easier than the current test stack.

Chad is currently working on finishing up `Test2` and making sure that it's stable and backwards-compatible enough to replace the existing test suite stack. Once `Test::More`, `Test::Builder`, and friends are all running on top of Test2, it will make it much easier to write new test tools that integrate with this infrastructure.

The future of testing in Perl 5 is looking bright! And Perl 6 isn't being left behind. I've been working on a similar project in Perl 6 with the current placeholder name of [Test::Stream][8]. This is a little easier than the Perl 5 effort since there's no large body of test tools with which I need to ensure backwards compatibility. I want Perl 6 to have the same excellent level of test infrastructure that Perl 5 is going to be enjoying soon.

 [1]: https://metacpan.org/release/Test2
 [2]: https://metacpan.org/release/Test-Class-Moose
 [3]: https://metacpan.org/release/Test-Simple
 [4]: https://testanything.org/
 [5]: https://metacpan.org/pod/distribution/Test-Harness/bin/prove
 [6]: https://metacpan.org/release/TAP-Stream
 [7]: https://metacpan.org/pod/Test2::Event::Exception
 [8]: https://github.com/autarch/perl6-Test-Stream

## Comments

**Timm Murray, on 2016-02-29 06:48, said:**  
There was a proposal on the old testanything.org web site that would have handled forking streams:

<http://web.archive.org/web/20110611083912/http://testanything.org/wiki/index.php/Test_Groups>

Not the prettiest output, but it should work.
