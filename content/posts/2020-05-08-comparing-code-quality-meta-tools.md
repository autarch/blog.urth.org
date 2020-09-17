---
title: Comparing Code Quality Meta Tools
author: Dave Rolsky
type: post
date: 2020-05-08T20:44:08+00:00
url: /2020/05/08/comparing-code-quality-meta-tools/
---
What's a code quality meta tool? It's a tool that lets you orchestrate many linting and formatting tools to operate on an entire project which may contain many languages. Examples include [tidyall][1] (which I maintain), [pre-commit][2], [lefthook][3], [husky][4], [overcommit][5], and [precious][6] (my new project in this space).

It's worth noting that only tidyall and precious describe themselves as being focused on tool orchestration. The others all describe themselves as systems for managing Git hooks. The other tools, including pre-commit (despite its name), lefthook, husky, and overcommit, are all capable of managing many types of hooks.

Nonetheless, the documentation for each of these tools has large sections showing how to orchestrate code quality tools as part of your pre-commit hooks. In addition, each tool allows you to run the tools outside of git hooks so you can run them from the CLI and in CI.

Here are the things we'll look at for each tool:

* The language it's written in and how easy it is to install the tool.
* Maturity and current status.
* How to add individual hooks/plugins/programs to be run by the orchestrater.
* What it ships with in terms of support for various code quality tools.
* How to add support for new code quality tools. Do you have to write code, configuration, or both?
* Speed of execution. Since in most scenarios with lots of files and code quality tools being run, this is mostly dominated by the meta tool's parallel execution capabilities.
* Additional features like caching, support for incremental enforcement of linting, etc.

## Tidyall

[Tidyall][7] is a fairly mature tool. It was first released in 2012. To the best of my knowledge, it's never taken off outside the Perl community, but based on issue and PR activity, it has a decent amount of use. I'm currently the only maintainer, though others do submit PRs. For [reasons I wrote about previously][8], its design is somewhat of a dead end, so I'm looking to move away from it myself. I'd encourage existing tidyall users to look at the other tools in this blog post. It's basically impossible to use for [Golang][9] linting, and it can do weird things in the face of non-ASCII content (though mostly it's fine).

Tidyall is written in Perl. It installs easily with standard Perl tools like [cpanm][10] but if you're not familiar with this tooling you may have issues. In addition, if you only have system perl available you'll have to either learn about tools like [perlbrew][11] or install it globally.

Adding individual tools to your config can range from simple to painful to impossible. If there's already an [existing tidyall plugin for your tool][12], you can install that with cpanm as well. If the plugin is for a non-Perl tool, like [eslint][13] or it will generally assume that tool can be found in your path.

In the past, adding support for a new tool that did not have a plugin meant writing a new Perl class, and ideally distributing that class on CPAN. If you look at a lot of these plugins, you'll see that they're usually incredibly trivial. Many of them simply take a filename as input and run a command on it via `system`, then pass or fail based on the exit status of the command. I was getting quite sick of writing these, so in version 0.71, released in September of 2018, I added two new plugins [GenericValidator][14] and [GenericTransformer][15]. These two plugins let you configure many linters (Validator) and formatters (Transformer) solely through your `tidyall.ini` config file.

Out of the box, tidyall includes support for a number of tools, mostly Perl-related. That said, the tools supported by the core are often outdated for other ecosystem. For example, it supports three JS tools, none of which are eslint, though there is [a plugin on CPAN for it][16], and it'd be easy enough to configure as a GenericValidator.

With tidyall you can have it run in parallel on multiple files at once. This must be enabled from the command line with the `-j/--jobs` flag, and you must have [Parallel::ForkManager][17] installed.

Tidyall has caching built in, though it tends to have some false positives. Notably, it does not include its own version or the plugin's config in the cache key, so it will not re-run when those change. Instead, it only re-runs when the file contents change. It also has support for a caching model designed to work well in CI, so you can cache your cache directory between CI runs, which is neat.

It has no support for incremental linting enforcement. You can, however, build your own on top of its testing tools. Speaking of which, one nice feature it provides is a test module called [`Test::Code::TidyAll`](https://metacpan.org/pod/release/DROLSKY/Code-TidyAll-0.78/lib/Test/Code/TidyAll.pm). This module plays nice with Perl's testing infrastructure and lets you add linting/formatting tests to your project easily. As long as your project is in Perl.

Also, it has support for [Subversion][18] in addition to Git. So if you're stuck in the early aughties that'll be handy[^1].

## pre-commit

The [pre-commit tool][19] is written in Python. As a Perl person, I found installing it less annoying than I imagine non-Perl people find installing tidyall to be. You can either use pip or pipe a Python script you retrieve with curl into a local python binary. I think I did the latter, which works fine, but does who knows what to your system. That said, it is simpler than installing tidyall. It uses [virtualenv][20] and ends up with me having pre-commit at `~/bin/pre-commit`.

Its first release was in 2014, and it appears to be actively developed and widely supported by many other tools.

What do I mean by "supported by many other tools"? Well, that gets to one of the most terricleverifying aspects of it. With pre-commit, you add new tools to your config by referring to a github repo. For example, if I wanted to add [yamllint][21], I'd add this config:

```yaml
repos:
    repo: https://github.com/adrienverge/yamllint
    rev: v1.23.0
    hooks:
        - yamllint
```

Once you do this, pre-commit will clone the remote repo and save it locally for you. That means that if the config lives in the repo for the tool itself, it automatically installs the tool. It also install that tool's deps based on the remote repo's language. You can even run `pre-commit autoupdate` later to update one or more plugins to the latest tag on the remote repo's master branch.

The actual config for how to execute this tool lives in the external repo. For example, check out the [yamllint config][22]:

```yaml
- id: yamllint
  name: yamllint
  description: This hook runs yamllint.
  entry: yamllint
  language: python
  types: [file, yaml]
```

This config tells pre-commit how to execute yamllint, and on what types of file. The `language: python` bit tells pre-commit that this plugin needs python. The pre-commit tool supports many languages, including Perl, Go, Ruby, JS (Node), Rust, and more. And not only does pre-commit know how to _execute_ these plugins, but it also knows how to install their dependencies and how to sequester those deps into a virtualenv-like system. So for Ruby it will use [rbenv][23] and install all of the gems a tool depends on in an rbenv for just that tool.

Mind blown! The pre-commit project itself maintains a huge number of plugin definitions, and some tools include pre-commit config in their repo directly.

It's also worth noting that you can configure which files a plugin runs on locally. The yamllint config above just says it operates on YAML files, but you can narrow that done to specific parts of your project.

All of this is very cool but there is one big downside. You're at the mercy of the person who makes this remote repo for much of the tool's config. For one small example, the [golangci-lint repo's plugin config][24] says to run `golangci-lint run --fix`. If you didn't want the `--fix` flag you have to find [another repo that defines a golangci-lint hook][25] instead.

Except that other one I linked always runs it as `golangci-lint run --new-from-rev="$(git rev-parse HEAD)"`. So that's going to make it impossible to just run this tool across your entire current codebase. But hey, there's [yet another repo that does it the way I'd want][26].

You can probably see where this is going. The degree to which this is convenient is highly variable. You're also at the mercy of all these other repos in terms of updating their config as the tool adds features. If the config lives in the tool's repo itself, they'll (I hope) update the config as the tool changes. But in many cases, the only config for a tool lives in some random repo that only contains the pre-commit config for one or more tools. If there's a bug in that tool's config you'd have to submit a PR to the repo in question or start using a clone of it.

That all said, there are some escape hatches.

You can define additional arguments to be passed to a given tool. So if the hook is defined as taking no arguments **and** the hook config doesn't discard all arguments its given you can easily add more. But if it's defined with default arguments like my `golangci-lint` examples, you can't remove those. For maximum control, you can easily [define configs for hooks in your project directly][27].

It runs in parallel by default, but individual plugins can opt out of being run in parallel.

It doesn't do any caching of hook results, but it does store the remote repos it clones in a directory that you can cache between CI runs, which is nice. It also doesn't support incremental linting, from my reading of the docs.

Overall, I'm very impressed by pre-commit. It's designed for maximum ease of adoption and it has support for a huge array of tools in a variety of languages.

But at the same time, I wouldn't be that excited to use it. I really dislike the way I have to go look at config in all these different repos just to find one that works the way I want, or maybe to find out that _none_ of them work the way I want. If I _were_ to use pre-commit, I think I'd just define all of my hooks locally. That does throw away some of the convenience of pre-commit, but I'd still be able to take advantage of its great support for managing tools and dependencies across many languages.

## lefthook

The [lefthook tool][3] is written in Go. They're using [goreleaser][28] to publish binary releases to GitHub, so installation is trivial. You can download a binary from [the releases page][29] or use [godownloader][30] to automate this completely.

It was first released in February of 2019, and appears to be under active development.

Compared to pre-commit, lefthook is much simpler. You configure tools to run in a YAML config file and that's it. It doesn't automate installation of those tools or look to other repos for config on how to run them. That means you have to instruct it how to run each tool in your config.

It has a number of options for configuration and execution. You can essentially extend config from other files in a sort of OO/wrapper way. You can also define execution pipelines, where a series of commands are executed only if the previous one passed.

It supports parallel execution, though you have to explicitly tell it what things can be run in parallel. You can run it directly from the CLI or CI, and you can run just a subset of plugins as well.

Overall, lefthook is fairly minimal compared to other tools. Because it's all config based, and you can put shell commands in the config directly, it's quite flexible. From what I can see, it doesn't have any caching built in, nor does it support incremental linting.

## husky

The [husky][4] tool is dog themed, which is a clear point in its favor, as opposed to focusing on cleaning (no fun), violence (fun?), or actually naming itself after exactly what it's for, like a boring boomer or something.

Installation is via npm or yarn, which is about as annoying as using the CPAN tools in my experience. It looks like a fairly JavaScript focused tool. It's configured through entries in a project's `package.json` file. If your project is in JS this is very convenient. If it's not it will feel weird, but it's just yet another config file in your project root. What's one more?

The first release was in December of 2016 and it appears to be under active development.

Either way, I applaud it for not using YAML like pre-commit and lefthook. While my current favorite config language is TOML, I'll take pretty much anything over YAML except XML.

Running tools from husky is done by specifying shell commands in its config or by writing a config file in JS which defines the commands to be run. It really doesn't have much in the way of other features. For example, there is no way to specify files to run against in your config.

It's not clear to me, but I think many people combine [lint-staged][31] with husky, which allows you to select files in various ways.

From looking at the code, I think all commands are run in parallel by default, but the docs don't really clarify this. There are no caching options or support for incremental linting.

So while it's quite flexible it also doesn't do much to help you. If pre-commit is the maximum hand holding option, this one is the least, with all the others in between.

## overcommit

Alright, the last one before the last one. It's another hook manager, this time in Ruby. You install it with the gem tool, so I'd assume it's as annoying as JS or Perl tools if you're not familiar with the language.

Its first release was in May of 2013 and it looks to be active developed.

Configuration is in YAML. Plugins are defined externally as Ruby classes, much like tidyall. However, it ships with an **enormous** number of plugins. You can also add local plugins by plopping a Ruby class in `.git-hooks/$hook_name/$some_file.rb`, which is handy. And you can configure plugins as external executables directly in your YAML config.

It supports parallel execution, which it does by default. You can turn this off on a per-plugin basis.

It does not appear to support caching or incremental linting enforcement.

It has an interesting and unique plugin signature feature. This is designed so that someone cannot submit a PR with a malicious plugin enabled. For example, if the PR added a malicious post-checkout hook and you checked the PR code out locally, that'd be bad. The signature feature will catch the configuration change and warn you before executing any hooks, which is quite nice. The signature also incorporate's the plugin's source code.

My reading is that this is a good option if you're using Ruby. It has a huge set of existing plugins defined, and if you're already using Ruby it's easy to add overcommit to your project. And I really like the signature feature.

## precious

Finally, the last one! This is [my new contribution to the mix][6].

It's written in Rust, which is a lot of fun for me. I could've written it much more quickly in Perl or Go, but I wanted to learn something new. And that's also why it's not really done yet.

It's first release was in August of 2019 and its development is intermittent at best. I'm only using it on one project right now, so it's adoption rate is fairly low. That project is a Go tool called [omegasort][32] I wrote to use with precious as a replacement for a plugin I use with tidyall, so is this even adoption?

It's pretty easy to install. When releases are made a set of binaries gets posted to the [project's GitHub releases page][33] You can almost use godownloader to generate an install script, but you'll need to [edit the generated script a bit][34]. I hope to provide a better auto-install method in the future.

Unlike all the other tools except tidyall, it's **not** a hook manager. It's entirely designed around the idea of orchestrating multiple code quality tools for a project. Running it from a pre-commit hook is quite simple. Just run `precious lint -s`, which lints all the code that's about to be committed.

It's entirely config driven, but it doesn't use YAML. You're welcome. It uses TOML so a config file looks like this:

```toml
[commands.golangci-lint]
type = "lint"
include = "**/*.go"
run_mode = "root"
chdir = true
cmd = [
    "golangci-lint",
    "run",
    "-c",
    "$PRECIOUS_ROOT/golangci-lint.yml",
]
ok_exit_codes = [0]
lint_failure_exit_codes = [1]

[commands.goimports]
type = "tidy"
include = "*/**.go"
cmd = ["goimports", "-w"]
ok_exit_codes = [0]
```

Rather than specifying commands as shell, you actually break them out into an array where the first element is the executable and the rest are arguments to pass. So you don't need to think about shell interpolation. You can define commands as linters, tidiers, or both. You also tell it whether to run the command on each file, each directory, or just once from the project root. Each command needs to define the exit codes that indicate a non-error result and whether output to `stderr` indicates a failure (but you should really try to get everything to just use exit codes because).

There are some examples in the project's repo, but this needs to be expanded quite a bit.

Probably the best feature is that it has cool Unicode emoji output:

```
$> precious lint -a
💍 Linting all files in the project
💯 Passed rustfmt: src/vcs.rs
💯 Passed rustfmt: src/command.rs
💯 Passed rustfmt: src/testhelper.rs
💯 Passed rustfmt: src/path_matcher.rs
💯 Passed rustfmt: src/config.rs
💯 Passed rustfmt: src/filter.rs
💯 Passed rustfmt: src/basepaths.rs
💩 Failed rustfmt: src/main.rs
Diff in /home/autarch/projects/precious/src/main.rs at line 371:
...
```

See, it's got a poo when the file isn't tidy. That's programming!

By default, everything runs in parallel and you can't change it, but parallelization is by file/directory, not by tool, so that should be safe for nearly everything (I hope). I'm sure I'll have to add a serial option for plugins at some point.

It doesn't yet have caching or incremental linting support, though I'd love to add both. I also have a vague idea of using language servers in addition to external commands for tidying and linting support. I want to try that to see if it's much faster than executing binaries.

Overall, precious sits in a spot somewhere in the middle in terms of hand holding. It's a bit higher level than writing a bunch of shell code, but it's not as simple as "just add this plugin by name". That said, my experience with the latter in tidyall made me write precious this way, so I think this is a good balance.

Should you use it? I have mixed feelings. I'd love to have some people try it out and give me feedback. But on the other hand, it's **much** less mature than anything else I've covered and it doesn't have a big user base driving it forward and keeping it healthy.

## Summary

You should be using tools like this in your projects. It automates away a lot of things people either do in code review or don't do at all. This makes it easier for people to contribute, whether that project is FOSS or proprietary.

If I had to pick one tool to use tomorrow, I'd probably go with [pre-commit][35]. It's quite mature and feature rich. And even though I don't love the way config is done by reference to other repos, you don't have to use it that way. I think it's most winning feature is that it understands how to install dependencies needed for each plugin on a per-language basis. That's really slick. It'd be even slicker if it added overcommit's signature checking feature.

That said, I'm going to keep working on precious, if only just as a way to keep learning Rust. But I hope to get it to the point where it provides serious competition for the other tools I reviewed.

What tools do you use and which do you love and hate? Comment here, on [reddit][36], or on [Hacker News][37].

 [1]: https://metacpan.org/release/Code-TidyAll
 [2]: http://pre-commit.com/
 [3]: https://github.com/Arkweid/lefthook
 [4]: https://github.com/typicode/husky
 [5]: https://github.com/sds/overcommit
 [6]: https://github.com/houseabsolute/precious
 [7]: https://metacpan.org/release/DROLSKY/Code-TidyAll-0.78
 [8]: https://blog.urth.org/2020/04/25/the-real-dirt-on-tidyall/
 [9]: https://golang.org/
 [10]: https://metacpan.org/pod/distribution/App-cpanminus/bin/cpanm
 [11]: https://perlbrew.pl/
 [12]: https://metacpan.org/search?q=code%3A%3Atidyall%3A%3Aplugin
 [13]: https://eslint.org/
 [14]: https://metacpan.org/pod/release/DROLSKY/Code-TidyAll-0.78/lib/Code/TidyAll/Plugin/GenericValidator.pm
 [15]: https://metacpan.org/pod/release/DROLSKY/Code-TidyAll-0.78/lib/Code/TidyAll/Plugin/GenericTransformer.pm
 [16]: https://metacpan.org/release/Code-TidyAll-Plugin-ESLint
 [17]: https://metacpan.org/release/Parallel-ForkManager
 [18]: https://subversion.apache.org/
 [19]: https://pre-commit.com/
 [20]: https://virtualenv.pypa.io/en/stable/
 [21]: https://github.com/adrienverge/yamllint
 [22]: https://github.com/adrienverge/yamllint/blob/master/.pre-commit-hooks.yaml
 [23]: https://github.com/rbenv/rbenv
 [24]: https://github.com/golangci/golangci-lint/blob/master/.pre-commit-hooks.yaml
 [25]: https://github.com/Bahjat/pre-commit-golang
 [26]: https://github.com/dnephin/pre-commit-golang/blob/master/run-golangci-lint.sh
 [27]: https://pre-commit.com/#repository-local-hooks
 [28]: https://goreleaser.com/
 [29]: https://github.com/Arkweid/lefthook/releases
 [30]: https://github.com/goreleaser/godownloader
 [31]: https://github.com/okonet/lint-staged
 [32]: https://github.com/houseabsolute/omegasort
 [33]: https://github.com/houseabsolute/precious/releases
 [34]: https://github.com/houseabsolute/omegasort/blob/master/dev/bin/download-precious.sh
 [35]: https://pre-commit.com/#plugins
 [36]: https://www.reddit.com/r/programming/comments/gg1a2g/comparing_code_quality_meta_tools/
 [37]: https://news.ycombinator.com/item?id=23119256

## Comments

**David Hodgkinson, on 2020-05-11 03:34, said:**  
What happened to Perl::Critic? It's my first stop in code quality.

**Dave Rolsky, on 2020-05-11 09:18, said:**  
This post was about meta tools that orchestrate the running one or more code quality tools. Perl::Critic is not an orchestrator, it's just a code quality tool to be orchestrated along with many others.

[^1]: I'm making fun of it but let me tell you, when Subversion first came out, it was a **huge** improvement over previous tools like CVS, and I couldn't switch to it fast enough!
