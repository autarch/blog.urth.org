---
title: "actions-rust-release v1 Released"
author: Dave Rolsky
type: post
date: 2026-08-23T09:22:02-07:00
url: /2026/08/23/actions-rust-release-v1-released
---

I just released [v1.0.0](https://github.com/houseabsolute/actions-rust-release/releases/tag/v1.0.0)
of my [actions-rust-release](https://github.com/houseabsolute/actions-rust-release) action.

This is a big, breaking change. See the
[release notes](https://github.com/houseabsolute/actions-rust-release/releases/tag/v1.0.0) for
details, but the summary is that this splits the action into two pieces. The first piece, still
named `actions-rust-release`, creates release archive files (tarballs and zips) and uploads them as
workflow artifacts. The second piece, named `actions-rust-release/publish`, gathers all of these
artifacts and publishes a GitHub release. It also publishes SHA256 checksum files for each release
artifact. Both of these actions live in the same repo.

Previously, the release was created or updated for every build target in your build matrix. This
meant that if some targets failed to build entirely, you ended up with a partial release. You had to
either delete the tag or make a new release with a new version. With v1, if the build matrix doesn't
fully succeed, it won't create a broken release.

In addition, the v0 workflow could not support immutable releases, since you cannot update an
immutable release. Also unlike v0, it will never update an existing release. Instead, it will fail
if one already exists.

If you're using the v0 action, check out the
[v0 to v1 migration guide](https://github.com/houseabsolute/actions-rust-release/blob/v1/MIGRATING.md).
