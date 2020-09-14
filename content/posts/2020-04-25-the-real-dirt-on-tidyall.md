---
title: The Real Dirt on Tidyall
author: Dave Rolsky
type: post
date: 2020-04-25T21:29:59+00:00
url: /2020/04/25/the-real-dirt-on-tidyall/
categories:
  - Uncategorized

---
Sorry, couldn&#8217;t resist the pun.

First, a bit of background. [Tidyall (aka Code::TidyAll)][1] was [first released][2] in June of 2012 by Jon Swartz. It&#8217;s a code quality meta-tool that orchestrates other code quality tools. With a single configuration file you can enable many different tools for a single project. By &#8220;code quality tools&#8221; I mean both pretty printers and linting tools. Each tool is supported via a plugin, implemented as a Perl class, that knows how to talk to that tool. In some cases the plugin _is_ the tool, as with the [SortLines plugin][3], which sorts lines in text files.

The first version supported [perltidy][4], [perlcritic][5], and [podtidy][6], and as you can tell from that list it was very much a Perl-specific tool at first. But Jon added support for JavaScript tools like js-beautify a few months after the initial release, in September of 2012. Over time, it&#8217;s grown to include plugins for PHP, Go, YAML, Postgres SQL, and many more. Just search [MetaCPAN for `Code::TidyAll::Plugin`][7] to see them.

Within the first few months after release it also acquired support for use as an SVN or Git pre-commit hook, which is a natural use for this type of tooling. Over time, I think there&#8217;s been a fair number of Perl people who&#8217;ve used it, but I don&#8217;t know if it&#8217;s ever gotten much traction (if any) outside the Perl community. In November of 2014, Jon gave me primary ownership of the distribution, and I&#8217;ve maintained it ever since.

But it&#8217;s starting to show its age. The primary issues come from its initial design and are not easy to fix. Note this is not Jon&#8217;s fault. Like most successful projects, eventually people wanted to use it in ways that the initial design doesn&#8217;t support. Projects that don&#8217;t reach this point usually do so because they don&#8217;t get used, not because the creator was a visionary genius who foresaw all possible future uses.

The basic algorithm behind how tidyall works is as follows:

  1. Find all the files to which tidyall _could_ apply based on each plugin&#8217;s include/exclude rules as well as any global exclude rules.
  2. Looping over each file, it finds all the plugins that apply to that file and applies each plugin to it in turn. Specifically, it reads in the source of the file, passes it to the plugin, and then writes that source back out to disk. Remember this detail, it&#8217;s important!
  3. That&#8217;s it. There&#8217;s not much to it conceptually.

There are two issues that occur because of this design.

First, because it&#8217;s based on files, not directories or any sort of generic notion of paths, it has serious problems with Go. **In Go, packages are directory-based.** All of the files in a directory are part of that package, and when it comes to linting (as opposed to pretty printing), many linters must consider the whole directory at once.

This also causes issues for linters that want to look at multiple packages at once. For example, the [Rust clippy tool][8] is invoked across your entire crate at once. A crate can contain many directories. Clippy doesn&#8217;t even have a way to run it on single directories or files because that doesn&#8217;t make sense in Rust.

Relatedly, remember that in step #2 I said it reads the file source, passes it to the plugin, and then writes it back? Well, that _also_ causes problems for some languages. If a plugin only works on files (versus in-memory source as a string), then tidyall will write the source out to a file in a temporary directory, then pass that temporary file name to the plugin. The plugin is expected to change the file it&#8217;s given, after which tidyall reads the source back into memory from the temp file and moves on to the next plugin.

Again, this [causes issues with some languages][9], notably Go, which expects files to live in directories named after the package they are in, alongside the other files that make up the package.

This makes using tidyall for tools in some languages more or less impossible without a major redesign.

The other big issue with all of this reading and writing is that it&#8217;s really hard to keep track of the file&#8217;s encoding. Tidyall doesn&#8217;t have any way of knowing if the file it&#8217;s reading is binary data, UTF-8 strings, or something else. Combine this with Perl&#8217;s sometimes idiosyncratic Unicode handling and you get [all sorts of confusing issues][10].

Fixing these issues basically involves throwing out the core of the system and starting from scratch. If I were to do that ([which I am][11], so far purely as an experiment), it&#8217;s pretty easy to fix. Instead of operating on source in memory, we only operate on paths. And instead of implementing plugins as Perl classes, they&#8217;re implemented via configuration telling the tool how to invoke an executable. We can leave string encoding handling to the individual tools, which are in the best position to do so.

Along the way, I&#8217;m also making my rewrite loop over plugins before files. In other words, rather than taking each file one at a time and passing it to each plugin in sequence, I&#8217;d take each plugin one at a time and pass it the appropriate set of paths. This isn&#8217;t that big a deal, but I think it makes for slightly better output on failures.

But making any of these changes to tidyall, much less all of them, would break every existing plugin. In essence I&#8217;d be writing tidyall2. And if I&#8217;m going to do that, I&#8217;m going to use it as an excuse to learn Rust, which is [exactly what I&#8217;m doing with precious][11].

In a follow up post I&#8217;ll compare and contrast tidyall, precious, and [pre-commit][12]. If you know of any other tools in this category (code quality meta-tools), I&#8217;d love to hear about them. Please add a comment with a link!

 [1]: https://metacpan.org/release/Code-TidyAll
 [2]: https://metacpan.org/release/JSWARTZ/Code-TidyAll-0.01
 [3]: https://metacpan.org/release/Code-TidyAll/source/lib/Code/TidyAll/Plugin/SortLines.pm
 [4]: https://metacpan.org/release/Perl-Tidy
 [5]: https://metacpan.org/pod/Perl-Critic
 [6]: https://metacpan.org/release/Pod-Tidy
 [7]: https://metacpan.org/search?q=code%3A%3Atidyall%3A%3Aplugin
 [8]: https://github.com/rust-lang/rust-clippy
 [9]: https://github.com/houseabsolute/perl-code-tidyall/issues/62
 [10]: https://github.com/houseabsolute/perl-code-tidyall/issues/84
 [11]: https://github.com/houseabsolute/precious
 [12]: https://pre-commit.com/

## Comments

### Comment by Dotan Dimet on 2020-04-26 02:23:45 -0500
I ran across a git hooks manager called lefthook, which seems to fit the same niche.

### Comment by Dave Rolsky on 2020-04-26 11:06:04 -0500
Thanks for the pointer. The docs for lefthook also mention Husky, lint-staged, and Overcommit.