---
title: Please Try the Latest Test::Class::Moose
author: Dave Rolsky
type: post
date: 2014-06-10T16:13:37+00:00
url: /2014/06/10/please-try-the-latest-testclassmoose/
categories:
  - Uncategorized

---
I&#8217;ve been doing a lot of work on `Test::Class::Moose` recently and I&#8217;ve released [a trial distro with my changes][1].

The highlights in this release are:

  * Support for parameterized test classes &#8211; instantiate a class more than once with different parameters
  * Separated the test runner from `Test::Class::Moose` itself &#8211; there is now a new `Test::Class::Moose::Runner` class so your test classes themselves are not also runners
  * Integrated the parallel runner code into this new runner so you can just pass `jobs => 2` to the Runner class and get parallel testing

These changes are (obviously) backwards incompatible so Ovid and I would love to get your feedback on these changes before enshrining them in a stable release. Please comment in the form of [RT issues][2] or [GitHub pull requests][3].

 [1]: https://metacpan.org/release/DROLSKY/Test-Class-Moose-0.55-TRIAL
 [2]: https://rt.cpan.org/Dist/Display.html?Name=Test-Class-Moose
 [3]: https://github.com/Ovid/test-class-moose