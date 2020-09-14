---
title: Benchmarking MooseX::Method::Signatures
author: Dave Rolsky
type: post
date: 2010-02-09T11:45:48+00:00
url: /2010/02/09/benchmarking-moosexmethodsignatures/
categories:
  - Uncategorized

---
I&#8217;ve been seeing some talk about [MooseX::Method::Signatures][1] and its speed. Specifically, [Ævar Arnfjörð Bjarmason said][2] says that MXMS is about 4 times slower than a regular method call. He determined this by comparing two different versions of a large program, Hailo. This is interesting, but I think a more focused benchmark might be useful.

Specifically, I&#8217;m interested in comparing MXMS to _something else_ that does similar validation. One of the main selling points of MXMS is its excellent integration of argument type checking, so it makes no sense to compare MXMS to plain old unchecked method calls. Therefore, I [made a benchmark][3] that compares MXMS to [MooseX::Params::Validate][4]. Both MXMS and MXPV provide argument type checking use Moose types. That should eliminate the cost of doing type checking as a variable. If you don&#8217;t care about type checking, you really don&#8217;t need MXMS (or MXPV).

The benchmark has two classes with semantically identical methods doing argument validation. One uses MXMS and the other MXPV. All method calls are wrapped in eval since a validation failure causes an exception. I also tested both success and failure cases. My experience with Params::Validate tells me that there&#8217;s a big difference in speed between success and failure, and the results bear that out.

Here&#8217;s what the benchmark came up with:

<pre class="highlight:false nums:false show-plain-default:true">Rate   MXMS failure   MXPV failure   MXMS success   MXPV success
MXMS failure  262/s             --           -41%           -81%           -94%
MXPV failure  448/s            71%             --           -68%           -90%
MXMS success 1393/s           431%           211%             --           -69%
MXPV success 4545/s          1634%           915%           226%             --
</pre>

First, as I pointed out, there&#8217;s a big difference between success and failure. I can only assume that throwing an exception is expensive in Perl. Second, the difference between MXMS and MXPV is much greater in the success case. This makes sense if simply throwing an exception is costly.

It seems that in the success case, MXPV is about 3 times faster than MXMS in the success case. I think the success case is most important, since we probably don&#8217;t expect a lot of validation failures in our production code.

[Benchmark code][3]

 [1]: http://search.cpan.org/dist/MooseX-Method-Signatures
 [2]: http://blogs.perl.org/users/aevar_arnfjor_bjarmason/2010/02/moosexmethodsignatures-is-really-slow.html
 [3]: /files/import/34-mxms-vs-mxpv-benchmark
 [4]: http://search.cpan.org/dist/MooseX-Params-Validate