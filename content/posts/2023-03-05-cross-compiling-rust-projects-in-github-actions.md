---
title: "Cross Compiling Rust Projects in GitHub Actions"
author: Dave Rolsky
type: post
date: 2023-03-05T15:28:32-06:00
url: /2023/03/05/cross-compiling-rust-projects-in-github-actions
discuss:
  - site: "/r/rust"
    uri: "https://www.reddit.com/r/rust/comments/11jgkdv/cross_compiling_rust_projects_in_github_actions/"
---

{{< aside >}}

The highlight of all this is
[my brand new GitHub Action for cross-compiling Rust projects](https://github.com/marketplace/actions/build-rust-projects-with-cross).
The rest of the post is about why and how I wrote it.

{{< /aside >}}

I was recently working on the CI setup for [my `ubi` project](https://github.com/houseabsolute/ubi)
with a couple goals. First, I wanted to stop using
[unmaintained](https://github.com/actions-rs/toolchain/issues/216) actions from
[the `actions-rs` organization](https://github.com/actions-rs). Second, I wanted to add many more
release targets for different platforms and architectures[^1].

Replacing some of what I used from `actions-rs` was pretty easy:

- [`dtolnay/rust-toolchain`](https://github.com/dtolnay/rust-toolchain) replaces
  `actions-rs/toolchain`.
- [`actions-rust-lang/audit`](https://github.com/actions-rust-lang/audit) replaces
  `actions-rs/audit`.

But what about [`actions-rs/cargo`](https://github.com/actions-rs/cargo)? You'd think that running
`cargo` wouldn't even _need_ an action, and you'd be right. Except that this action doesn't just run
`cargo`. If you set its `use-cross` parameter to true it uses
[`cross`](https://github.com/rust-embedded/cross) to do the build instead of `cargo`, making it
trivial to cross-compile a Rust project.

I was already doing some cross-compilation for all my Rust projects, and I wanted to add more. So I
needed to replace this action with something of my own. I couldn't find any already written,
probably because everyone who moved away from `actions-rs` kept saying things like "this is too
trivial to need an action, it's just running `cargo build`."

So for my first pass, I simply embedded the build pieces directly in the GitHub workflow for UBI,
like this:

```yaml
jobs:
  release:
    name: Release - ${{ matrix.platform.os_name }}
    if: startsWith( github.ref, 'refs/tags/v' ) || github.ref == 'refs/tags/test-release'
    strategy:
      matrix:
        platform:
          - os_name: FreeBSD-x86_64
            os: ubuntu-20.04
            target: x86_64-unknown-freebsd
            bin: ubi
            name: ubi-FreeBSD-x86_64.tar.gz
            cross: true
            cargo_command: ./cross

          - os_name: Linux-x86_64
            os: ubuntu-20.04
            target: x86_64-unknown-linux-musl
            bin: ubi
            name: ubi-Linux-x86_64-musl.tar.gz
            cross: false
            cargo_command: cargo

          - os_name: Windows-aarch64
            os: windows-latest
            target: aarch64-pc-windows-msvc
            bin: ubi.exe
            name: ubi-Windows-aarch64.zip
            cross: false
            cargo_command: cargo

          - os_name: macOS-x86_64
            os: macOS-latest
            target: x86_64-apple-darwin
            bin: ubi
            name: ubi-Darwin-x86_64.tar.gz
            cross: false
            cargo_command: cargo

    runs-on: ${{ matrix.platform.os }}
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      - name: Install toolchain if not cross-compiling
        uses: dtolnay/rust-toolchain@stable
        with:
          targets: ${{ matrix.platform.target }}
        if: ${{ !matrix.platform.cross }}
      - name: Install musl-tools on Linux
        run: sudo apt-get update --yes && sudo apt-get install --yes musl-tools
        if: contains(matrix.platform.os, 'ubuntu') && !matrix.platform.cross
      - name: Install cross if cross-compiling (*nix)
        id: cross-nix
        shell: bash
        run: |
          set -e
          export TARGET="$HOME/bin"
          mkdir -p "$TARGET"
          ./bootstrap/bootstrap-ubi.sh
          "$HOME/bin/ubi" --project cross-rs/cross --matching musl --in .
        if: matrix.platform.cross && !contains(matrix.platform.os, 'windows')
      - name: Install cross if cross-compiling (Windows)
        id: cross-windows
        shell: powershell
        run: |
          .\bootstrap\bootstrap-ubi.ps1
          .\ubi --project cross-rs/cross --in .
        if: matrix.platform.cross && contains(matrix.platform.os, 'windows')
      - name: Build binary (*nix)
        shell: bash
        run: |
          ${{ matrix.platform.cargo_command }} build --locked --release --target ${{ matrix.platform.target }}
        if: ${{ !contains(matrix.platform.os, 'windows') }}
      - name: Build binary (Windows)
        # We have to use the platform's native shell. If we use bash on
        # Windows then OpenSSL complains that the Perl it finds doesn't use
        # the platform's native paths and refuses to build.
        shell: powershell
        run: |
          & ${{ matrix.platform.cargo_command }} build --locked --release --target ${{ matrix.platform.target }}
        if: contains(matrix.platform.os, 'windows')
      - name: Strip binary
        shell: bash
        run: |
          strip target/${{ matrix.platform.target }}/release/${{ matrix.platform.bin }}
        # strip doesn't work with cross-arch binaries on Linux or Windows.
        if: ${{ !(matrix.platform.cross || matrix.platform.target == 'aarch64-pc-windows-msvc') }}
      - name: Package as archive
        shell: bash
        run: |
          cd target/${{ matrix.platform.target }}/release
          if [[ "${{ matrix.platform.os }}" == "windows-latest" ]]; then
            7z a ../../../${{ matrix.platform.name }} ${{ matrix.platform.bin }}
          else
            tar czvf ../../../${{ matrix.platform.name }} ${{ matrix.platform.bin }}
          fi
          cd -
      - name: Publish release artifacts
        uses: actions/upload-artifact@v3
        with:
          name: ubi-${{ matrix.platform.os_name }}
          path: "ubi*"
        if: github.ref == 'refs/tags/test-release'
      - name: Publish GitHub release
        uses: softprops/action-gh-release@v1
        with:
          draft: true
          files: "ubi*"
          body_path: Changes.md
        if: startsWith( github.ref, 'refs/tags/v' )
```

I've actually cut quite a bit of this out, notably the other 15 or so platforms in the matrix.

Here are the highlights:

1. If it needs `cross` it will install that from its latest GitHub release using `ubi` itself. This
   is much faster than compiling `cross` by running `cargo install`. Otherwise it uses
   `dtolnay/rust-toolchain` to install the Rust toolchain.
2. It will run the build command (`cross` or `cargo`) in the appropriate shell for the platform.
   Using the right shell matters for some corner cases. Notably, `ubi` now depends on
   [the `openssl` crate](https://lib.rs/crates/openssl) with the `vendored` feature enabled. With
   that feature, the crate will actually compile OpenSSL and statically link it into your binary.
   But OpenSSL fails to compile in an msys shell on Windows!

And that's really it. I've extracted the generic bits and turned it into a reusable action called
[Build Rust Projects with Cross](https://github.com/marketplace/actions/build-rust-projects-with-cross).x

You can see it in use in
[the release job for `ubi`](https://github.com/houseabsolute/ubi/blob/master/.github/workflows/ci.yml#L50-L220).
The YAML for `precious` is nearly identical (which suggests that maybe I need to write _another_
action).

[^1]:
    For [the 0.0.20 release](https://github.com/houseabsolute/ubi/releases/tag/v0.0.20), there are
    published binaries for 20 different OS/CPU targets, including many for Linux, some for Windows
    and macOS, and one each for FreeBSD and NetBSD.
