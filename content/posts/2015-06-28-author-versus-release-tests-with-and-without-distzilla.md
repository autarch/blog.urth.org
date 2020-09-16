---
title: Author Versus Release Tests with (and without) Dist::Zilla
author: Dave Rolsky
type: post
date: 2015-06-28T20:10:00+00:00
url: /2015/06/28/author-versus-release-tests-with-and-without-distzilla/
---
In a discussion on #moose-dev today, [ether][1] made the following distinction:

> author tests are expected to pass on every commit; release tests only need to pass just before release

I think this is a good distinction. It also means that almost every single "xt" type test you might think of should probably be an author test. The only one we came up with in #moose-dev that was obviously a release test was a test to check that Changes has content for the release.

I'm sending PRs to various dzil plugins to move them to author tests, with the goal of being able to safely **not** run release tests under Travis.

 [1]: https://metacpan.org/author/ETHER