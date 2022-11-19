---
title: "Big Changes in Precious v0.4.0"
author: Dave Rolsky
type: post
date: 2022-11-19T16:24:35-06:00
url: /2022/11/19/big-changes-in-precious-v0-4-0
---

I just [released version 0.4.0 of
`precious`](https://github.com/houseabsolute/precious/releases/tag/v0.4.0), my
code quality meta-tool for configuring a collection of linters and tidiers for
a project.

The headline change for this release is that command invocation configuration
has changed, with the old `run_mode` and `chdir` keys being
deprecated. Don't worry, you can safely upgrade to this release, as the
old config keys still work and do not cause `precious` to emit any warning
yet[^1].

Also, `precious` still works the same way by default as it always did. It runs
the command once per file from the project root, passing the command the
file's path relative to that root.

The problem with the old configuration is that it didn't really capture the
full scope of possible ways to invoke commands. Specifically, it has a few
shortcomings:

- You couldn't pass absolute paths to the command no matter what you did.
- You couldn't run a command per directory and pass any path to it except a
  dot (`.`) or no path at all.
- You couldn't run a command once and pass file or directory paths to the
  command.
- You couldn't run a command once from any directory except the project root.

All of these cases are addressed with the new system, which offers three
command invocation keys, `invoke`, `working_dir`, and `path_args`. The
[documentation in the project's
repo](https://github.com/houseabsolute/precious) has been updated. There's
also [documentation on upgrading to
v0.4.0](https://github.com/houseabsolute/precious/blob/master/docs/upgrade-from-0.3.0-to-0.4.0.md)
as well as [docs on every valid combination of invocation config
options](https://github.com/houseabsolute/precious/blob/master/docs/invocation-examples.md).

Please install the new release and take it for a spin. If you encounter any
problems please [file a GitHub
issue](https://github.com/houseabsolute/precious/issues?q=is%3Aissue+is%3Aopen+sort%3Aupdated-desc).

[^1]:
    I do plan to add warnings in a future release and eventually remove
    support for the old keys.
