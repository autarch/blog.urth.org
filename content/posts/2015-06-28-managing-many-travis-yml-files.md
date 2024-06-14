---
title: Managing Many .travis.yml Files
author: Dave Rolsky
type: post
date: 2015-06-28T22:47:13+00:00
url: /2015/06/28/managing-many-travis-yml-files/
---

If you have a lot of distributions, you may also have a lot of `.travis.yml` files. When I want to
update one file, I often want to update all of them. For example, I recently wanted to add Perl 5.22
to the list of Perls I test with. Doing this by hand is incredibly tedious, so I wrote a [somewhat
grungy script][1] to do this for me instead. It attempts to preserve customizations present in a
given Travis file while also imposing some uniformity. Here's what it does:

- Finds all the `.travis.yml` files under a given directory. I exclude anything where the remote
  repo doesn't include my username, since I don't want to do this sort of blind rewriting with
  shared projects or repos where I'm not the lead maintainer.
- Ensures I'm using the right repo for Graham Knop's fantastic [travis-perl helper][2] scripts.
  These scripts let you test with Perls not supported by Travis directly, including Perl 5.8, dev
  releases, and even blead, the latest commit in the Perl repo. These helpers used to be under a
  different repo, and some of my files referred to the old location.
- If possible, use `--auto` mode with these helpers, which I can do when I don't need to customize
  the Travis `install` or `script` steps.
- Make sure I'm testing with the latest minor version of every Perl from 5.8.8 (special-cased
  because it's more common than 5.8.9) to 5.22.0, plus "dev" (the latest dev release) and "blead"
  (repo HEAD). If the distro has XS, it tests with both threaded and unthreaded Perls, otherwise we
  can just use the default (unthreaded) build. If the distro is not already testing against 5.8.8,
  this won't be added, since some of my distro are 5.10+ only.
- Add coverage testing with Perl 5.22 and allow blead tests to fail. There are all sorts of reasons
  blead might fail that have nothing to do with my code.
- If possible, set `sudo: false` in the Travis config to use Travis's container-based
  infrastructure. This is generally faster to run and **way** faster to start builds. If I'm using
  containers, I take advantage of the [apt addon][3] to install aspell so `Test::Spelling` can do
  its thing.
- Clean up the generated YAML so the blocks are ordered in the way I like.

Feel free to [take this code][1] and customize it for your needs. At some point I may turn this into
a real tool, but making it much more generic seems like more work than it's worth at the moment.

[1]: https://gist.github.com/autarch/ee1569cb22c80208ff72
[2]: https://github.com/travis-perl/helpers
[3]: http://docs.travis-ci.com/user/apt/
