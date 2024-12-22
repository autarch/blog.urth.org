---
title: "My actions-rust-cross Action Now Has Built-In Caching"
author: Dave Rolsky
type: post
date: 2024-12-21T22:20:50-06:00
url: /2024/12/21/my-actions-rust-cross-action-now-has-built-in-caching
discuss:
  - site: "/r/rust"
    uri: "https://www.reddit.com/r/rust/comments/1hjrcd3/my_actionsrustcross_action_now_has_builtin_caching/"
---

I just release v1.0.0 Beta 1 of [my `actions-rust-cross` GitHub Action](https://github.com/houseabsolute/actions-rust-cross/tree/v1.0.0-beta1). The big headline feature in this release is integration with the [`Swatinem/rust-cache`](https://github.com/Swatinem/rust-cache) action. This will include the `target` you provide to `actions-rust-cross` as part of the cache key, which from my testing means that it only caches the compilation output relevant to the target platform.

The `Swatinem/rust-cache` action caches compiled _dependencies_, so how helpful this will be for your project depends on how much time it spends compiling dependencies versus the project itself.

From some informal testing with [my `ubi` project](https://github.com/houseabsolute/ubi), I saw that caching reduced build and test time for 21 different targets from 9.5 minutes to around 4.5 minutes. That project has about 255 crate dependencies when I run `cargo test`.

Note that according to the docs for `Swatinem/rust-cache`, this caching is most useful for projects with a `Cargo.lock` file in their repo. For libraries, this caching is less helpful, since `cargo` is always pulling new dependency versions as they're released. However, I suspect that for runs in quick succession this caching might still work well. You can always disable caching entirely by setting `use-rust-cache` to `false` when invoking `actions-rust-cross`.

You can also configure the `Swatinem/rust-cache` action by passing a JSON string in the `rust-cache-parameters` parameter to `actions-rust-cross`. This is a bit awkward, but it was the best way I could figure out how to take parameters _without_ copying all of the `rust-cache` parameters to `actions-rust-cross`.

In order to take advantage of this release, you just need to change your `uses` to `houseabsolute/actions-rust-cross@v1`. If you're already calling `Swatinem/rust-cache` separately from `actions-rust-cross`, you should delete that from your workflow.

I'd love to get some feedback on this release before marking it stable. If you try it and it doesn't work, [please file a GitHub issue](https://github.com/houseabsolute/actions-rust-cross/issues). If it _does_ work for you, [please email me and let me know](mailto:autarch@urth.org)!