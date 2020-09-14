---
title: MooseX::Params::Validate and Params::Validate Maintainers Wanted
author: Dave Rolsky
type: post
date: 2016-11-13T21:31:01+00:00
url: /2016/11/13/moosexparamsvalidate-and-paramsvalidate-maintainers-wanted/
categories:
  - Uncategorized

---
Have you seen my new module, [`Params::ValidationCompiler`][1]? It does pretty much everything that `MooseX::Params::Validate` and `Params::Validate` do, but _way_ faster. As such, I don&#8217;t plan on using either of those modules in new code, and I&#8217;ll be converting over my old code as I get the chance. I&#8217;d suggest that you consider doing the same. The speed gains are quite significant from [my benchmarks][2].

Since I&#8217;m not going to use them any more, these two modules could use some maintenance love. Please [contact me][3] if you&#8217;re interested.

 [1]: https://metacpan.org/pod/Params::ValidationCompiler
 [2]: http://blog.urth.org/2016/06/05/making-datetime-faster-and-slower/
 [3]: mailto:autarch@urth.org