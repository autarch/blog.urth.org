---
title: "Should People Just Use Goreleaser Instead of `actions-rust-release`?"
author: Dave Rolsky
type: post
date: 2025-02-16T16:25:57-06:00
url: /2025/02/16/should-people-just-use-goreleaser-instead-of-actions-rust-release
---

I'm cross-posting this from
[an issue I made](https://github.com/houseabsolute/actions-rust-release/issues/10) for
[`actions-rust-release`](https://github.com/houseabsolute/actions-rust-release). For context, _I_ am
the action's author, and this is a serious question, not the start of a pitch for why you should use
my action.

TLDR; Does `actions-rust-release` serve any purpose that isn't better served by
[goreleaser](https://goreleaser.com/)?

Here's the issue body in full:

> Recently, I was considering adding some features to this action, notably adding the ability to
> produce signed releases (specifically, signing the checksums file). As I started looking into
> this, I realized that [goreleaser](https://goreleaser.com/) already does this, as well as many
> other things this action doesn't do:
>
> - It offers a lot more power and flexibility in what is included in the resulting release archive
>   files.
>   - This includes templating files, so for example you can update the copyright year in the
>     `LICENSE` file to match the release date.
> - Deb, RPM, macOS DMG, MSI, Chocolatey, etc. support.
> - Integration with SBOM creation tools.
> - And more
>
> So I'm wondering whether it's worth continuing to invest in this action. It seems like using
> goreleaser to release a Rust project is fairly easy. It even supports _building_, though I think
> for that I'd still use my
> [actions-rust-cross](https://github.com/houseabsolute/actions-rust-cross) action, as I don't think
> goreleaser would make it easier to do cross-platform builds.
>
> Will people who use this action see this issue? If you do, I'd greatly appreciate your feedback!
> Take a look at [goreleaser](https://goreleaser.com/), focusing specifically on the parts related
> to releasing, not building. After looking, do you still prefer this actions? If so, why?

Please
[provide your feedback on that issue](https://github.com/houseabsolute/actions-rust-release/issues/10).
