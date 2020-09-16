---
title: Please Test Params::Validate 1.14
author: Dave Rolsky
type: post
date: 2014-12-20T21:14:08+00:00
url: /2014/12/20/please-test-params-validate-1-14/
---
I've just released a [new version of Params::Validate][1] that allows validation callbacks to die in order to provide a custom error message or exception object. This was a long-needed feature, and will enable me to make Moose::Params::Validate support the error messages provided by type objects, which has also been long-needed.

However, I'm a little nervous about any changes to Params::Validate, since it's used a rather large chunk of CPAN. It has c. 350 direct dependents, and those include things like Log::Dispatch and DateTime, so the actual downstream reach is pretty huge. I'd rather not break some large swathe of CPAN or your in-house applications.

That all said, the behavior of calling die in a callback sub has always been undefined and undocumented, so no one should have been doing it prior to now (I say with forced optimism and the realization that someone probably is doing it anyway).

So please take a moment to install the latest trial release and test it with your code base. If your apps are using a lot of CPAN modules there's a good chance that Params::Validate is already in your stack, even if you don't use it directly. If you find any breakage, please report it on [rt.cpan.org][2].

If I don't hear about any breakage in a week or so and CPANTesters looks good, I'll release a non-TRIAL version.

 [1]: https://metacpan.org/release/DROLSKY/Params-Validate-1.14-TRIAL
 [2]: https://rt.cpan.org/Dist/Display.html?Name=Params-Validate