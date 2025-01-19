---
title: "What's the Right Way to Merge a Pull Request?"
author: Dave Rolsky
type: post
date: 2022-07-02T15:58:02-05:00
url: /2022/07/02/what-s-the-right-way-to-merge-a-pull-request
discuss:
  - site: "/r/programming"
    uri: "https://www.reddit.com/r/programming/comments/vq1p3x/whats_the_right_way_to_merge_a_pull_request/"
---

**Edit: In
[the discussion on /r/programming](https://www.reddit.com/r/programming/comments/vq1p3x/whats_the_right_way_to_merge_a_pull_request/)
a
[comment from /u/nik9000](https://www.reddit.com/r/programming/comments/vq1p3x/comment/ien5oaw/?utm_source=share&utm_medium=web2x&context=3)
pointed me at what I think is the best solution.**

GitHub has a feature where the PR submitter can allow me to push directly to their fork. This means
I can effectively edit their PR directly by checking it out and force pushing back to _their_ fork
of the repo! Apparently this has existed for a while but I didn't notice it.

Thanks again to [/u/nik9000](https://www.reddit.com/user/nik9000/) for pointing this out.

So I made a new saved reply on GitHub that I will use for all future PRs I receive. Here's the
content:

{{< aside >}}

Hi, thanks for your PR! I'm pretty finicky about my projects (see
[this blog post](https://blog.urth.org/2022/07/02/what-s-the-right-way-to-merge-a-pull-request/) for
details), so I rarely merge a PR as-is. I can move forward on your PR in one of two ways:

1. I check it out locally, fiddle with it as needed, merge it locally, and simply close this PR.
   This will preserve at least one commit with your name on it, but the PR will show up as closed in
   your GitHub stats.
2. If you enable me to push directly to your fork, I can do my fiddling, then force push to your
   fork and merge the resulting PR. Again, this will preserve at least one commit with your name on
   it, but you _also_ get credit for the PR merge in your GitHub stats. The only downside is that I
   will be force pushing directly to your fork.

Please let me know which approach you'd prefer. If I don't hear from you before I get around to
working on this PR I'll go with option #1.

Thanks again for your contribution!

{{< /aside >}}

---

I've received a lot of pull requests over the years. But recently, I've been thinking about whether
I merge them the right way.

When I wrote my [my GitHub profile generator]({{< relref
"2022-03-28-yet-another-github-profile-generator.md" >}}), one of the stats I had it generate was
how many of my pull requests were merged. [My profile](https://github.com/autarch) currently says
I've created 562 PRs, of which 420[^1] have been merged.

But in fact _more_ than 420 have been merged in some form. It's just that for some of them, the
maintainer fiddled a bit with the submission and merged it locally via the CLI, then closed the PR.

My precious stats!

The issue is that I _always_ do this for PRs submitted to me. I'm incredibly picky about the code in
my personal projects, so it's nearly impossible to submit a PR that I will merge as-is. Things I
typically edit in PRs include:

- Names of everything.
- Code nits like when to include optional parentheses, exactly what operators to use when there are
  multiple options, and every other possible thing you can think of.[^2]
- Adding documentation for API changes/additions (people mostly forget to do this).
- Comments, including the word wrapping of comments (I like the way Emacs does it when I hit
  `alt-q`).
- Commit messages themselves. I like a very specific format, more or less following
  [Chris Beams's recommendations](https://cbea.ms/git-commit/), except I'm okay with longer
  subjects.
- Making sure the commits are organized well. I _hate_ commits like "fix typo in last commit". Just
  edit the previous commit!
- Making sure commits that make public-facing changes also update the Changes file.

I _could_ instead put the PR submitter through the wringer to do all this, but I'd rather not. The
only way to get someone else to submit something that's exactly what I want would be to try to
operate them as a puppet via PR comments. That would be exhausting for me and infuriating for them.

So instead what I typically do is check out the PR as a local branch with the
[GitHub CLI tool](https://cli.github.com/) (`gh pr checkout 42`), fiddle with their commit(s), make
sure CI passes, and then merge it locally. This preserves their name as a committer in the git
history, so they get some credit. It's bit weird, however, since the code with their name on it may
be fairly different from what they submitted.

And they won't get Internet points for the PR being merged. Hell,
[GitHub gives you _achievements_](https://github.blog/2022-06-09-introducing-achievements-recognizing-the-many-stages-of-a-developers-coding-journey/)
for this stuff! So I'm sure some folks would really prefer to have a proper PR merged.

One option I _could_ offer would be to take their original PR, edit it, push it back to my repo as a
new branch, then have them submit that branch as a PR. I would be open to doing this if someone
really cared about getting that "PR merged" stat up.

So what do you think? If enough people told me they wanted this I would start offering that when
people submit a PR. Or maybe there's another approach I haven't though of?[^3] You can
[email me](mailto:autarch@urth.org) or
[discuss this on /r/programming](https://www.reddit.com/r/programming/comments/vq1p3x/whats_the_right_way_to_merge_a_pull_request/).

[^1]: hurr durr

[^2]:
    Fortunately, I'm able to suppress this when reviewing work PRs, but I channel all the insanity
    back into my personal projects.

[^3]: Note that "don't be so picky" isn't an option.
