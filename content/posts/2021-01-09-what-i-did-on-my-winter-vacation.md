---
title: What I did on my winter vacation
author: Dave Rolsky
type: post
date: 2021-01-09T11:12:57-06:00
url: /2021/01/09/what-i-did-on-my-winter-vacation
---
TLDR: Helped my father move. Then I shaved all the yaks. Fur everywhere. Very messy.

Because of the way holidays at ActiveState work, it's very economical in terms
of vacation days to take the last two weeks of the year off (Christmas and New
year's weeks). I had a fair bit of vacation left, so I decided to take the
first week of the new year off as well, for a total of three weeks of
vacation.

So what did I do with all that time?

## Helping My Father Move

My mother died at the beginning of September. She and my father had been
living in Florida, but it didn't make sense for my father to continue living
there alone. My wife and I had been discussing moving to a new house in
Minneapolis for a while, so my father suggested we find a place where we could
all live. We were looking for either a duplex or a property with an
ADU[^1]. We found a perfect odd duplex[^2] very quickly. The sale closed on
December 16. My father's stuff from Florida arrived a few days later, and he
moved in to his part of the duplex.

Unfortunately, because of COVID, we didn't go down to Florida to help him
prepare for the move. While he did sort through some of his stuff, his sorting
could've been more aggressive, as he was moving from a large house with two
people to a much smaller space with one person. The upshot is that he moved a
ridiculous amount of stuff here, far more than could ever fit in his space. So
we spent many hours going through it.

We still have a ridiculous number of boxes of stuff to give away in the main
part of the house, along with an endless pile of cardboard and packing paper,
but his unit in the duplex is looking great.

This made me even more enthusiastic about getting rid of tons of stuff before
my wife and I move, which will happen later this year, after some renovations
to our part of the duplex.

## My Local COVID Tracker

I've [posted about this]({{< relref
"2020-12-12-my-local-covid-stats-tracker.md" >}}) a [couple times]({{< relref
"2020-12-19-my-new-rube-goldberg-machine.md" >}}) already. I made an update to
track more counties, as well as to add a graph [showing the seven-day new case
average per 10,000 people](https://covid.urth.org).

The new graph by population made it clear that the counties near me were doing
_worse_ than the state as a whole. The original graph, showing just the raw
count of new cases, made it look like the state overall was worse than the
nearby counties, when in fact I think the opposite is true.

## Precious and My Yak Shaving Expedition

[Precious is a project](https://github.com/houseabsolute/precious) is a
project I started to create a meta-linter/tidier in Rust. The goal is to
replace [TidyAll](https://metacpan.org/release/Code-TidyAll). I've written
about [TidyAll's issues]({{< relref "2020-04-25-the-real-dirt-on-tidyall.md"
>}}) in the past.

### Switching DateTime to use Precious

I've [used
`precious`](https://github.com/houseabsolute/precious/blob/master/precious.toml)
for a few projects, including itself, but I wanted to try moving a Perl
project to it. I picked
[DateTime](https://github.com/houseabsolute/DateTime.pm) for no particular
reason, other than that it's something I've worked on for many years.

This is what led me down the yak shaving rabbit hole, to mix some metaphors.

First, I found some bugs with `precious` and made [a v0.0.7
release](https://github.com/houseabsolute/precious/releases/tag/v0.0.7) of it.

Then when I started working on converting DateTime from TidyAll to `precious`,
I found several bugs in
[`omegasort`](https://github.com/houseabsolute/omegasort)[^3], leading to a
[new release of
that](https://github.com/houseabsolute/omegasort/releases/tag/v0.0.4) as well.

As I worked on switching DateTime to use `precious`, I realized there was a
bootstrapping problem. With TidyAll, I can just specify TidyAll and any needed
plugins as develop phase prereqs for the distribution, making it easy for
others to install all the needed tools, like
[perltidy](https://metacpan.org/release/Perl-Tidy),
[perlcritic](https://metacpan.org/release/Perl-Critic), and TidyAll itself.

But `precious` isn't on CPAN, nor is `omegasort`. I did briefly consider going
down the whole [Alien](https://metacpan.org/pod/Alien) route, but quickly
discarded that idea. While depending on a notional `Alien::precious` would
work fine for my Perl projects, it wouldn't help for anything that's not Perl.

*Note that `precious`, being a Rust project, produces a single statically
linked[^4] binary. Go programs like `omegasort` are totally static, not even
linking libc. This will become more important later in my yak shaving
journey.*

### Just One Little Installer

So my next thought was to build a simple installer for `precious` that could
be run using the very safe "pipe `curl` output into an interpreter"
strategy. I quickly wrote an installer in Perl that would live in the
`precious` repo. I was using
[fatpack](https://metacpan.org/release/App-FatPacker), which is a great tool
for turning Perl programs into single-file executables, as long as all of its
dependencies are pure Perl.

But then I started thinking about `omegasort`. Did I want to write a nearly
identical program to live in the `omegasort` repo? And then do it again for my
next Rust or Go project? Plus there are lots of other useful tools that fall
in this "released as a single binary on GitHub" bucket, like
[ripgrep](https://github.com/BurntSushi/ripgrep).

### Just *One*(!) Installer

Then I had an idea. What if I wrote _one_ installer for all these things? So I
made a little Perl distribution called `App-ugri`, where "ugri" stood for
Universal GitHub Release Installer. I actually finished that before I realized
the critical flaw in my plan. Even though I could fatpack `ugri` into a single
file so you could pipe `curl` into `perl`, what about Windows?

Then I remembered why I was creating this installer in the first place. It's
because of languages like Rust and Go that produce a single statically linked
executable. The solution was pretty obvious. Write this installer in Rust.

### ubi

"UBI" stands for Universal Binary Installer. I liked the pun here more than
the original "ugri" name. Of course, by "universal binary installer" I mean it
just installs single-file executables from GitHub project releases, so it's
not very universal (yet?).

Since I'd already written this once in Perl, writing a Rust version was mostly
pretty easy. The only wrinkle was that I had to learn a little bit about async
programming in Rust, because the GitHub API client I was using,
[`octocrab`](https://github.com/XAMPPRocky/octocrab), is async. This was
something I'd been wanting to learn about anyway, so I welcomed the challenge.

There is a usable 0.0.2 release on the [GitHub project's releases
page](https://github.com/houseabsolute/ubi/releases).

Of course, ubi has a bootstrapping problem. What do you install a universal
binary installer with? You `curl` a script into `sh`, of course[^5]!

That looks like this:

```
$> curl --silent --location \
       https://raw.githubusercontent.com/houseabsolute/ubi/master/bootstrap/bootstrap-ubi.sh |
       sh
```

That should work on Linux and macOS. But I would love [some help with creating
the equivalent PowerShell script for
Windows](https://github.com/houseabsolute/ubi/issues/1). I also need to
improve the release tooling to provide binaries for more systems.

#### Installing `precious` and `omegasort`

Once you have `ubi` installed, installing these tools is trivial:

```
$> ubi --project houseabsolute/precious --in ~/bin
$> ubi --project houseabsolute/omegasort --in ~/bin
# and for good measure
$> ubi --project BurntSushi/ripgrep --exe rg --in ~/bin
```

### But wait, there's more yak!

Along the way, I also ended up working on [my `dzil`
bundle](https://metacpan.org/release/Dist-Zilla-PluginBundle-DROLSKY) to to
make switching to `precious` easier. So now my bundle will:

* Generate a `precious.toml` config file for any project which doesn't yet
  have one, as long as there's no `tidyall.ini` file either.
* Generate an extended test that runs `precious lint --all` and makes sure
  there are no files that fail the linting checks.
* Generate a simple `dev-bin/install-xt-tool.sh` script that installs `ubi`,
  then uses that to install `precious` and `omegasort`.
* Generate a git hook script that uses `precious`, along with a `git/setup.pl`
  script to install that hook for the given repo.
* Update the `dist.ini` to always include an `authordep` on the version of the
  bundle that is being run.

And since I was messing with all this, I added
[`podchecker`](https://metacpan.org/release/Pod-Checker/) and
[`podtidy`](https://metacpan.org/release/Pod-Tidy) to my standard `precious`
config for Perl projects.

That last bullet point, about updating the `dist.ini` file, came out of some
issues I found in trying to get precious tests passing in CI using my
[`ci-perl-helpers`](https://github.com/houseabsolute/ci-perl-helpers) tooling
for Azure Pipelines. I've [written about those]({{< relref
"2019-11-18-my-new-ci-helpers-for-perl.md" >}}) in the past as well. I ended
up [making some improvements to the
helpers](https://github.com/houseabsolute/ci-perl-helpers/releases), so now
they'll automatically run the `dev-bin/install-xt-tools.sh` script before
running extended tests.

And when they're building a tarball for any Perl distro where the name starts
with "Dist-Zilla", they make sure to include the git checkout's `lib`
directory in `@INC` when running `dzil build`. I assume that if you're testing
a `dzil` plugin or plugin bundle in CI, then you want to use said plugin or
bundle when generating the tarball for said plugin or bundle[^6].

The results of all of this can be seen in [my PR to switch DateTime to
`precious`](https://github.com/houseabsolute/DateTime.pm/pull/117).

### Other Random Bits

* I tweaked [a PR for the CLDR
  project](https://github.com/unicode-org/cldr/pull/885) (Common Locale Data
  Repository) to fix a typo in one language's datetime info.
* I submitted [a PR to
  octocrab](https://github.com/XAMPPRocky/octocrab/pull/63) to update its
  dependencies so _I_ could update the same deps in `ubi`.
* I made a new release of
  [DateTime-Locale](https://metacpan.org/release/DateTime-Locale) to add some
  more documentation.
* I almost started rewriting omegasort in Rust (just because I like it better
  than Go), but I managed to restrain myself. I might get back to this at some
  point, but I'm glad I worked on these other projects for now.
* I wrote this blog post.

## Putting the Yaks to Bed

I wrapped this all up yesterday, more or less. I return to work on Monday, so
my timing was pretty good.

[^1]: Accessory Dwelling Unit - think of an apartment built over a garage.
[^2]: It's not a normal duplex. Instead of a house split into two pieces, it's
    an older three story house, built in 1915, with a newer, much smaller two
    story "apartment" attached to the back.
[^3]: Because TidyAll is in Perl, sorting plugins for it are just simple Perl
    classes. But `precious` only invokes other executables, so I realized I
    needed a sorting tool soon after starting on `precious`. I wanted to write
    the sorting tool in Rust but at the time I started, Rust had no support
    for Unicode collation, so I wrote it in Go instead.
[^4]: Except for libc.
[^5]: But it can install itself if you already have it installed.
[^6]: Does that sentence make any sense? I've lost track. There's too much yak
    fur in here!
