---
title: Testing go.mod Tidiness in CI
author: Dave Rolsky
type: post
date: 2019-08-13T09:16:50+00:00
url: /2019/08/13/testing-go-mod-tidiness-in-ci/
---

_Updated August 18 per discussion on [/r/golang][1]. Thanks to user [Bake_Jailey][2] for noting that
running_ `go mod tidy` _can do more than just remove unneeded module requirements._

Now that Go modules are a thing, I'm starting to use them for my Go projects. So far it's been a
nice improvement from `dep` and before that, `godep`.

With Go modules you end up with two files in your repo, `go.mod` and `go.sum`. The former file
stores a list of your dependencies. The go binary will automatically keep these files up to date
when you run things like `go build`. Or at least mostly up to date. When you remove a dependency it
does not get automatically removed from the `go.mod` file. Instead, you need to run `go mod tidy` to
remove unneeded deps from this file. And of course if you haven't run `go build` yet, then a new
dependency won't be added at commit time.

Unfortunately, `go mod tidy` always exits with a 0, even if it added or removed a dependency. So if
you want to test that this file is up to date in CI, you need to do it yourself. Here's my little
script for doing so:

```bash
#!/bin/bash
set -e
go mod tidy
STATUS=$( git status --porcelain go.mod go.sum )
if [ ! -z "$STATUS" ]; then
    echo "Running go mod tidy modified go.mod and/or go.sum"
    exit 1
fi
exit 0
```

This runs `go mod tidy` and checks to see if it modified either of the files we care about.

Of course, the right way to do this is to add an option to `go mod tidy` to do these sorts of
checks. See <https://github.com/golang/go/issues/27005> for a discussion of exactly that.

You can add this as a `script` step in your `.travis` file:

```yaml
script:
  - go test -v ./…
  - check-go-mod.sh
```

[1]: https://www.reddit.com/r/golang/comments/cpqmmj/testing_gomod_tidiness_in_ci_house_absolutely/
[2]: https://www.reddit.com/user/Bake_Jailey/
