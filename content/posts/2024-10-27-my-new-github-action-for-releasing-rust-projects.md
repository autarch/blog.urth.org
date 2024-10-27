---
title: "My New GitHub Action for Releasing Rust Projects"
author: Dave Rolsky
type: post
date: 2024-10-27T15:49:39-05:00
url: /2024/10/27/my-new-github-action-for-releasing-rust-projects
discuss:
  - site: "/r/rust"
    uri: "https://new.reddit.com/r/rust/comments/1gdlc7n/my_new_github_action_for_releasing_rust_projects/"
---

A while back I created a [new GitHub Action for releasing Rust projects](https://github.com/marketplace/actions/release-rust-project-binaries-as-github-releases). This works nicely with my [Rust Cross Action](https://github.com/marketplace/actions/build-rust-projects-with-cross) to let me automate away most of the toil from releasing new versions of my Rust CLI tools like [`precious`](https://github.com/houseabsolute/precious), [`ubi`](https://github.com/houseabsolute/ubi), and [`omegasort`](https://github.com/houseabsolute/omegasort).

Using it is pretty simple and can be done in one step:

```yaml
- name: Publish artifacts and release
  uses: houseabsolute/actions-rust-release@v0
  with:
    executable-name: ubi
    target: x86_64-unknown-linux-musl
```

For a longer example, see how I use this action and my Rust Cross Action to [build, test, and release `ubi`](https://github.com/houseabsolute/ubi/blob/master/.github/workflows/ci.yml).

Right now, all it does is the following:

* Creates a tarball (most platforms) or zip file (Windows) with the executable, along with any extra files that are requested. By default, it will include a changes file (defaults to `Changes.md`) and anything matching `README*`.
* Creates a sha256 checksum file for this archive file.
* Uploads these two files as release artifacts for the workflow run in GitHub.
* Uses the [GH Release Action](https://github.com/marketplace/actions/gh-release) to do the actual release publication on GitHub.

It's not much, but I was copying the YAML config to do this between my Rust projects, so it made sense to turn this into its own standalone Action.

In the future, I might turn this into something a little more generic. The only Rust-specific piece of it is that it knows where to `cargo build` puts the executable file. But there's no reason this couldn't work just as well for any other language capable of producing single-file binaries, like Go.
