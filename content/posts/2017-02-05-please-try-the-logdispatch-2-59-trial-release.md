---
title: Please Try the Log::Dispatch 2.59 Trial Release
author: Dave Rolsky
type: post
date: 2017-02-05T19:41:11+00:00
url: /2017/02/05/please-try-the-logdispatch-2-59-trial-release/
---
I just released [Log::Dispatch 2.59][1]. This is a trial release because it replaces [Params::Validate][2] with [Params::ValidationCompiler][3]. While the tests pass I could imagine there being some corner cases that this change ends up breaking.

If I don't see any bug reports for this release I will release a non-trial in a week or so.

 [1]: https://metacpan.org/release/DROLSKY/Log-Dispatch-2.59-TRIAL
 [2]: https://metacpan.org/pod/Params::Validate
 [3]: https://metacpan.org/pod/Params::ValidationCompiler