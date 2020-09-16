---
title: Breaking Changes to My Perl CI Helpers Project Incoming
author: Dave Rolsky
type: post
date: 2019-12-29T17:06:34+00:00
url: /2019/12/29/breaking-changes-to-my-perl-ci-helpers-project-incoming/
---
I'm working on what I plan to be the next version of [my Perl CI Helpers project][1] and it will break any existing use of said project.

Fortunately, I've been tagging releases and you can easily pin your consumption of the project to a specific tag! If you want to pin to the last release, you can do this in your config like this:

<pre><code>
resources:
  repositories:
    - repository: ci-perl-helpers
      type: github
      name: houseabsolute/ci-perl-helpers
      <strong>ref: refs/tags/v0.0.15</strong>
      endpoint: houseabsolute/ci-perl-helpers
stages:
   template: templates/build.yml@ci-perl-helpers
   parameters:
     <strong>image_version: v0.0.15</strong>
   template: templates/test.yml@ci-perl-helpers
   parameters:
     <strong>image_version: v0.0.15</strong>
     coverage: codecov
     include_threaded_perls: 'true'
</code></pre>

The highlighted lines are what is required to fully pin the helpers.

The next version will greatly increase the flexibility of the helpers, letting you test with any Perl version on any platform, instead of hardcoding macOS and Windows to just the latest stable Perl version. You'll also be able to install arbitrary platform packages (apt, brew, or chocolatey), as well as add your own arbitrary list of pre- and post-test steps.

 [1]: https://blog.urth.org/2019/11/18/my-new-ci-helpers-for-perl/
