---
title: "Naming Your Binary Executable Releases"
author: Dave Rolsky
type: post
date: 2023-04-16T17:50:12-05:00
url: /2023/04/16/naming-your-binary-executable-releases
discuss:
    - site: "Hacker News"
      uri: "https://news.ycombinator.com/item?id=35595021"
    - site: "/r/programming"
      uri: "https://www.reddit.com/r/programming/comments/12osmk9/naming_your_binary_executable_releases/"
---

[My universal binary installer tool, `ubi`](https://github.com/houseabsolute/ubi), has to deal with
a lot of "interesting" decisions when it comes to how people name their releases on GitHub.

So in the interests of making the world of binary executable releases more machine-readable and a
little less weird[^1], here are my recommendations on naming your release files. The TLDR is:

- Either use an extension or don't include periods in the filename.
- Use well-known operating system and CPU architecture names as part of the filename.

This applies to releases which just contain a single _compiled_ executable (and maybe a readme or
license file, but the binary is the important bit). This doesn't apply to anything which ships its
own installer, nor does it apply to files that contain packages, like debs or RPMs. It also doesn't
apply to programs in interpreted languages like Python or Perl, unless you are actually shipping a
single-file binary using something like `py2exe`

## Either Include an Extension or Don't Include Any Periods

Some folks want to release the bare binary without any compression. That's fine. But if you do this,
please **don't put any periods in the filename unless it also has an actual file extension.**

The reason for this is that it's very hard to determine whether "the text after the period" is a
file extension or just part of the main filename. For example, given the filename
`my-cool-program-v1.2.3-linux-x86-64`, what's the file extension? Well, you and I, as humans[^2],
can tell that there is no extension. But for a computer, it sure looks like this file has an
extension of `.3-linux-x86-64`!

So either give the file a proper extension, like `.exe` on Windows, or avoid periods in the name
entirely.

A simple way to make sure all your files have an extension is to just compress all of them. What I
typically see is `.gz` for Unix-y systems and `.zip` for Windows, but any sort of relatively common
compression scheme is fine.

## Include the Operating System and CPU Architecture in the Filename

**And don't make up your own operating system and architecture naming scheme!**

Don't use names like "linux64" or "win32". Please include both the OS name and the CPU architecture
name as separate components instead of some shorthand for both.

There's no standard for this but there are many reasonable sources for this information.

- Running `uname -p` on systems that support this will give you a reasonable architecture name.
- Running `uname -s` gives you a reasonable OS name.
- With Rust, the "target triple" for the `rustc` command can be taken from `rustc -vV`. You can use
  this target triple directly as part of the filename.
- With Go, you can run `go version`, which will print something like
  `go version go1.18.5 linux/amd64`. Split that last bit on the `/` to get the OS name and CPU
  architecture.
  - If you're cross-compiling Go then you have to set the `GOOS` and `GOARCH` environment variables.
    You can use the contents of those variables in the filename too!
- When you run `gcc -v` it prints a line like `--target=x86_64-linux-gnu`, where the target includes
  both the CPU architecture and OS name (at least on my system with GCC 9.4.0).
- Running `clang --version` prints a line like `Target: x86_64-pc-linux-gnu` with similar info.

Other languages often include this in their version output, like in `perl -V`.

There are probably lots of other ways to get this information. The point is that you don't need to
make this up and hard-code an arbitrary string for each platform you build on. You can get a name
that's useful one way or another.

Different languages and tools don't agree on _exactly_ what to call various things, so we end up
with "Darwin" and "macOS", "x86-64" and "amd64", etc. But there's a fairly limited set of variations
to account for when using the output from other programs. But if you just make stuff up on your own
the variations are limitless, and that's not a good thing!

You might be tempted not to include this because your program only works on one OS/CPU target. But
please don't skip this. It will _still_ be useful for tools like `ubi` to have this info in the
filename. And who knows, you might end up expanding the set of covered platforms in the future.

[^1]: I'm mostly _against_ making the world less weird, but I'll compromise for machine readability.
[^2]: I am definitely _not_ an alien or a dog in a human suit and I can prove it. Woof.
