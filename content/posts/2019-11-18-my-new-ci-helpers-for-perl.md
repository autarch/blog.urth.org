---
title: My New CI Helpers for Perl
author: Dave Rolsky
type: post
date: 2019-11-18T20:48:59+00:00
url: /2019/11/18/my-new-ci-helpers-for-perl/
---
Many years ago, [Travis CI][1] was the only game in town for FOSS project CI, because it was the only service that offered unlimited free builds for FOSS projects. Many projects took Travis up on the offer, and I set up testing for all of my Perl projects there. Switching to CI was a huge improvement for many projects across many languages, and I hugely appreciate the impact Travis has had on my FOSS work.

More recently but still years ago (in 2014), Graham Knop created the [travis-perl project][2]. This was a great step forward for doing CI with Perl projects. It made it trivial to test your project across many versions of Perl, including versions not yet supported by the official Travis Perl integration. It also did clever things like testing your build process, running your author/release/etc. tests, and was generally awesome. I also hugely appreciate the work Graham did on this. Again, it's had a huge impact on my FOSS work.

But there have been some downsides with both Travis and the travis-perl helpers. Some of these are fixable and some are just inherent in the Travis model. The biggest issue is that builds which test many versions of Perl are quite slow.

Travis doesn't use Docker, it uses bare VMs. This makes some operations slower than they need to be, mostly because we cannot supply our own base VM images. But with Docker, supplying a custom base image is trivial. This lets you do things like compile many different versions of Perl with different sets of options ahead of time, rather than on request.

Another issue with the Travis/travis-perl combo is that it doesn't use a pipeline approach. All of the work of the build is done in every job. Every job starts from source, installs the author/build deps, creates the distro tarball, untars it, installs its runtime/test prereqs, and runs its tests. Even more painfully, every version of Perl that we test runs the full author/release test suite.

But there's no reason for all this work. We only need to build the tarball **once**. Then every job should take that tarball, untar it, and run its tests with a different version of Perl. Similarly, there's no reason to run the full author/release test suite on every version of Perl. If my code is tidy and passes perlcritic once, I don't need to run that test on ten other Perl versions.

All of this is fixable in the travis-perl helpers. When the travis-perl helpers were created, I don't think Travis supported a pipeline approach, which would allow separating tarball creation from testing. But Travis does support this now.

However, the real speed killer is the fact that Travis limits you to 3 concurrent jobs at once. Some of my builds have 28 jobs, because I build on the last point release of every stable Perl version, plus the latest dev release and the perl repo's `HEAD` (blead), with and without threads. ~~This means that some of my projects take several hours to finish a single build. [See this build of DateTime.pm for an example][3]. It took just under 2 hours and 41 minutes!~~

[_Edit 2019-12-25_: I was looking at the wrong number in travis. The 2 hour, 41 minute time is the total amount of machine time, but it doesn't account for parallelism. Travis is also reporting another time of 5 minutes, 41 seconds. But clearly the run took longer than that. I think that may be because one of the jobs was restarted, so now it just reports that job. Looking at other DateTime builds I see run times of around 33 minutes. I don't know that this includes time waiting in the queue, however, which can be substantial if you kick off multiple builds.]

And that's just on Linux. I really want to be testing on Windows and macOS too. But adding that to my Travis builds is just going to make builds even slower.

So while I could've tried improving the travis-perl helpers to make builds quicker, the upper limit on my improvements would still leave me with fairly slow builds.

## Time for a New CI Service

I investigated a number of CI services. It had to meet several criteria.

First, it had to support builds on Linux, Windows, and macOS. Docker support was a must, since I knew I could use this to speed up Linux builds. It also had to support a multi-stage pipeline, so I could create the distribution tarball in one stage and then do parallel testing of that tarball in the next stage. It also needed to have support for caching files between runs. Caching things like installed Perl modules can greatly speed up successive CI runs.

And of course, it had to be free. Even if I could afford to pay for a service, locking in a new set of tools to a paid service would greatly limit who could benefit from it.

I looked at a number of options, including Travis, CircleCI, GitHub CI, and Azure Pipelines. Spoiler, I went with Azure.

I've already discussed the issues with Travis. GitHub CI looks promising, but it's quite immature right now. It didn't even have support for caching when I started this project (but it does now).

I **love** [CircleCI][4]. I think from a feature standpoint it is hands down **the best** CI SaaS option. We use it at `$work` and it's great. There are a number of things I like about it. Starting up Docker containers is blazing fast, usually under 10 seconds, whereas Azure takes anywhere ~~from 30-60 seconds~~ [_Edit 2020-04-25: as of 2020 it looks like Azure takes 20-22 seconds to start a container_]. It also supports SSHing into a build environment **on all three platforms**, which greatly reduces the pain of debugging CI issues. And their [orb system][5] for sharing templates and tasks is really nicely done.

**But** their FOSS offering is quite anemic. Their pricing model is based on a credit system, where each minute of build time costs a certain number of credits based on OS and underlying VM size. FOSS projects get a weekly credit budget, but each OS gets a different total amount in that budget. Notably, for Windows you get just 2,500 credits, which translates to just 62.5 minutes per week. It's easy to burn all of that time debugging a single issue. And if you have multiple projects like I do, then you could very quickly exhaust these credits. I tried developing my helpers using CircleCI but I hit the credit limits a few times and I gave up.

So that left Azure Pipelines. It's reasonably mature, it supports caching (and allows for multiple caches per job, which is nice). And it's offering for FOSS projects is _extremely_ generous. FOSS projects are given unlimited build minutes and **10** parallel jobs across all supported operating systems. So the end result is really fast builds.

## My New Helpers

My New Perl CI helpers are [available on GitHub][6]. I'd love to have others test this out, but please do note that this is alpha software and I reserve the right to break it at any moment. It also needs some more tests and automation so that it keeps up with new Perl releases without manual intervention.

With hot caches for all jobs, a build of the [DateTime.pm repo takes 10-15 minutes][7]. That's a ~~10x~~ 3x improvement over Travis doing just Linux! This build runs the tests on Windows with Perl 5.30.0, macOS with 5.30.1, and Linux with the latest point releases from 5.8 to 5.30, the latest dev release, and blead perl (fresh from the repo), with both threaded and unthreaded Perls. It runs my author/release tests in one of the Linux builds. And it also has an extra build to test coverage and uploads that coverage to [codecov.io][8]. I also tested uploading the results to [coveralls][9], and the helpers support a number of coverage outputs/services.

This is a huge improvement over Travis. I'll be migrating my projects over to this new CI setup, and no doubt fixing many issues with the helpers along the way. I've created a [few issues][10] for the project outlining some of the things I'd like to work on. I'd welcome help, though if other people want to change the Docker images being used, we'll need to first come up with a better system for tagging them to avoid breaking existing builds.

I'm pretty excited by this improvement. Dealing with CI failures has been a real chore for a long time because of the slow turnaround. A ~~10x~~ 3x speedup should make a big difference!

 [1]: https://travis-ci.com/
 [2]: https://github.com/travis-perl/helpers
 [3]: https://travis-ci.org/houseabsolute/DateTime.pm/builds/567793066
 [4]: https://circleci.com/
 [5]: https://circleci.com/orbs/
 [6]: https://github.com/houseabsolute/ci-perl-helpers
 [7]: https://dev.azure.com/houseabsolute/houseabsolute/_build?definitionId=2&_a=summary
 [8]: https://codecov.io/gh/houseabsolute/DateTime.pm/branch/azureci
 [9]: https://coveralls.io/builds/27039427
 [10]: https://github.com/houseabsolute/ci-perl-helpers/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc
