---
title: TAP is Great Except When It’s Not
author: Dave Rolsky
type: post
date: 2017-01-21T16:17:05+00:00
url: /2017/01/21/tap-is-great-except-when-its-not/
---
Having recently worked quite a bit on some testing tools, including tools to parse TAP, I've become intimately familiar with its shortcomings. I'm going to write these up here in the hopes that future generations of test output format developers will not repeat these mistakes.

TAP is (mostly) well-suited for human consumption. It's easy to read, and when tests fail, it's easy to figure out what failed and why. But the simplicity that makes it easy to read also makes it really difficult to parse properly. This leads to heuristics, and heuristics are the devil.

## No Connection Between Connected Output

What happens when this test code fails:

<pre class="lang:perl decode:true">is( 1, 2, 'one equals two' );
</pre>

We get this output:

<pre class="lang:none highlight:0 decode:true">not ok 1 - one equals two
#   Failed test 'one equals two'
#   at ./foo.t line 3.
#          got: '1'
#     expected: '2'
</pre>

This is nice and readable. It's very clear what went wrong. But from a parsing perspective it's a nightmare. There is no indication that the diagnostic output (the lines starting with `#`) are connected to the previous `not ok` line. So you have to implement a heuristic in your parser along the lines of "diagnostic output after a test is connected to that test". That might be correct, or it might not. Consider this code:

<pre class="lang:perl decode:true">is( 1, 2, 'one equals two' );

my $size = 42;
diag('About to test sizing');
is( $size, 42, 'size is 42' );
</pre>

Our output looks like this:

<pre class="lang:none highlight:0 decode:true">not ok 1 - one equals two
#   Failed test 'one equals two'
#   at ./foo.t line 3.
#          got: '1'
#     expected: '2'
# About to test sizing
ok 2 - size is 42
</pre>

Now our heuristic about diagnostic output is clearly wrong.

There are further heuristics we could try. We could parse the diagnostic content and look for leading space, but this really depends on the vagaries of how each test tool formats its output.

Figuring out what the output means is trivial for a human, but incredibly hard to code for.

## Multiple Output Handles for One Stream

TAP sends output to both `stdout` and `stderr` in parallel. Most of of the output goes to `stdout`, but diagnostic output goes to `stderr`. This causes all sorts of problems.

The `stdout` handle is usually buffered but `stderr` is not. In practice, this means that the output gets weird, with `stderr` output sometimes appearing much earlier than its related `stdout` output. One way to fix this is to enable `autoflush` on `STDOUT` in the test code itself.

With `prove` you can also pass the `-m` flag to merge the streams, which generally produces saner interleaving. The downside of merging is that you can no longer tell whether a line like `# foo` is diagnostic-level output, because that same line could be sent to `stdout` as a note.

Needless to say, having multiple handles contributes to more parsing problems. The problem discussed above of grouping together lines of output becomes **much** harder when those lines are split across two handles.

## The Epic Subtest Hack

The original versions of TAP had no concept of subtests. It may surprise you to know that modern TAP has no concept of subtests either!

Subtests are a clever hack that take advantage of the original TAP spec's simplicity. A normal TAP parser only cares about lines that start with non-whitespace. For example:

<pre class="lang:none highlight:0 decode:true">ok 1 - foo
  ok 2 - foo
</pre>

A TAP parser should only see one test here. The second line is ignored because of its leading whitespace.

Subtests take advantage of this to present human-readable output that the TAP parser ignores. Take this code for example:

<pre class="lang:perl decode:true">subtest 'Test several things' => sub {
    ok( 1, 'thing 1' );
    ok( 1, 'thing 2' );
};
</pre>

The output looks like this:

<pre class="lang:none highlight:0 decode:true"># Subtest: Test several things
    ok 1 - thing 1
    ok 2 - thing 2
    1..2
ok 3 - Test several things
</pre>

TAP parsers will ignore all of the indented output. All the parser sees is the first and last lines. The lines that start with whitespace are ignored.

This is a great hack, since it let test tools generate subtest output while parsing tools like `Test::Harness` continue to work unchanged.

Unfortunately, this also means that none of the parsing tools until [`Test2::Harness::Parser::TAP`][1] actually parsed subtest output. If you were trying to transform TAP output into something else you had to write your own subtest parsing, which is pretty hard to get right. I think `Test2::Harness::Parser::TAP` is pretty good at this point, but getting there was no mean feat.

## None of This Matters Any More

With [Test2][2] out, all of my complaints are more or less irrelevant. Internally, Test2 represents testing events as **event objects**. If we want to understand what's happening in our tests, we can look at these events. If we want to run tests in a separate process and capture the event output, we can tell those test processes to use the [`Test2::Formatter::EventStream`][3] formatter instead of TAP. This formatter dumps events as JSON objects which we can easily parse and turn back into event objects in another process. As of the 1.302074 release of Test2, events include a `cid` (context id) attribute. Multiple events with the same `cid` are related, so a test ok/not ok event followed by diagnostics can be easily grouped together.

The future of testing tools is looking very bright with Test2! TAP still drives me crazy, but now it's mostly doing that in theory rather than in practice.

 [1]: https://metacpan.org/pod/Test2::Harness::Parser::TAP
 [2]: https://metacpan.org/pod/Test2
 [3]: https://metacpan.org/pod/Test2::Formatter::EventStream

## Comments

**Larry S, on 2017-01-23 11:56, said:**  
Thank you for this. You have about convinced me to take a serious look at Test2.

**Dagfinn Reiersøl, on 2017-01-24 07:34, said:**  
I **have** started looking at Test2 after reading this. I have a question. Is there an easy way to run setup before each subtest? I'm a big fan of independent unit tests. Re-creating all setup before each separate test run prevents unpredictable errors due to undetected non-obvious dependencies. Classic JUnit has setUp() and tearDown() for this, and a huge number of other test frameworks have the same or something similar, including Test::Class.

It's not hard to do with Test::More type tests. It's a fairly simple matter of redefining subtest(). Test::More::Hooks does this, adding before() and after() methods. It seems to work with Test2, except that it tries to check that Test::More is loaded.

I can fool it this way:

`BEGIN { $INC{'Test/More.pm'} = 1; }<br />
use Test2::Bundle::More;<br />
use Test::More::Hooks;`

**Dave Rolsky, on 2017-01-24 07:58, said:**  
You should ask this at <a href="irc://irc.perl.org/#perl-qa" rel="nofollow">irc://irc.perl.org/#perl-qa</a>.