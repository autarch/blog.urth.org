---
title: "Fixing Some Bugs in My GitHub Profile Generator"
author: Dave Rolsky
type: post
date: 2022-08-14T11:28:22-05:00
url: /2022/08/14/fixing-some-bugs-in-my-github-profile-generator
---

A while back I was looking at [the output](https://github.com/autarch) from
[my GitHub profile generator](https://github.com/autarch/autarch) and it
seemed off. In particular, the language stats seemed off. The generator sums
up how many bytes of code I've written for each language. and then calculates
what percentage of my total output that represents.

Here's what it showed, more or less:

| Past Two Years    | All Time           |
| ----------------- | ------------------ |
| Perl: 76%, 9.5 MB | Perl: 77%, 11.3 MB |
| Rust: 21%, 2.7 MB | Rust: 18%, 2.7 MB  |
| Go: 2%, 214.8 KB  | Go: 2%, 368 KB     |

This isn't _obviously_ wrong. I've written a _lot_ of Perl and I've been doing
a fair bit of Rust recently. But the Rust numbers seemed excessive. Had I
written 2.7MB of Rust code in two years? That's a lot of code!

So I [filed a bug](https://github.com/autarch/autarch/issues/1) to remind
myself to look at this later. Today was later.

I added some debugging output to my code to print out various bits of info as
it went, focusing on each repo's language stats. Eventually, I had it just
print out bytes of Rust in each repo that had any Rust. That did the trick.

I realized that my Rust repos have _huge_ amounts of generated code. For
example, [my `tailwindcss-to-rust`
project](https://github.com/houseabsolute/tailwindcss-to-rust) exists to
generate Rust code from Tailwind CSS. The repo contains [an example of that
generated
code](https://github.com/houseabsolute/tailwindcss-to-rust/blob/master/macros/examples/css/generated.rs)[^1]. That
generated file is 613KB all by itself.

The fix was simple. GitHub uses [Linguist](https://github.com/github/linguist)
for its language detection and stats. You can [set attributes in your
`.gitattributes`
file](https://github.com/github/linguist/blob/master/docs/overrides.md) to
control how Linguist generates stats. Any file with a `linguist-generated`
attribute is excluded from Linguist's stats collection. So I went through and
added this to my Rust repos.

My Rust stat went down to 2.1MB. I'd have expected it to go down more, but I
think that maybe some of what I marked as generated was already being
excluded somehow.

And then it occurred to me that I have the same issue with some Perl repos
too. Notably,
[`DateTime-Locale`](https://github.com/houseabsolute/DateTime-Locale) and
[`DateTime-TimeZone`](https://github.com/houseabsolute/DateTime-TimeZone) both
contain ridiculous amounts of generated code. Apparently, I knew about this
Linguist thing before because `DateTime-Locale` already had a `.gitattributes`
file. But there was none for `DateTime-TimeZone`. Adding that removed about
**6MB** of Perl code from my stats.

So here are the new stats:

| Past Two Years    | All Time          |
| ----------------- | ----------------- |
| Perl: 60%, 3.6 MB | Perl: 66%, 5.4 MB |
| Rust: 34%, 2.1 MB | Rust: 26%, 2.1 MB |
| Go: 3%, 214.8 KB  | Go: 4%, 368 KB    |
| HTML: 1%, 62.6 KB |                   |

That seems a bit more sensible. I've written a lot of Perl, but I haven't
worked on many of my Perl projects for a while.

I also noticed some weirdness with the count of PRs written and merged. When I
run the profile generate locally I get a higher number than when it runs in
GitHub Actions. That's presumably because running it locally I run it with a
GitHub API token that has access to private repos, so it sees private MongoDB
repos.

But if I change the query to exclude private repos and run it locally, it gets
a much _lower_ number than it should. I'm not sure what's going on
here. [Doing the query manually on the GitHub
website](https://github.com/pulls?q=author%3Aautarch+is%3Apr+is%3Apublic) I
get numbers that match what the code gets in GitHub Actions, so I'm pretty
sure that's the right one. Confusing!

Just for good measure, I excluded all of my work-related orgs from the queries
too. The point of the profile is to highlight my FOSS work, not my work work.

But even with this refinement I still get different results from GitHub
Actions versus running it locally. If anyone has any ideas on why, [I'd love
to hear them](mailto:autarch@urth.org)!

[^1]: GitHub is pretty slow to render this file. Be patient.
