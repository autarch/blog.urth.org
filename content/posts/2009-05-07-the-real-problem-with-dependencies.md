---
title: The Real Problem With Dependencies
author: Dave Rolsky
type: post
date: 2009-05-07T10:39:24+00:00
url: /2009/05/07/the-real-problem-with-dependencies/
categories:
  - Uncategorized

---
After [ranting about dependencies][1], I started thinking (which is not the same as ranting by any means!).

Other systems have long dependency chains, but people don&#8217;t complain. Specifically, I&#8217;m thinking of Debian, which has great tools for tracking and installing package dependencies.

I used the cool [debtree tool][2] to create a dependency graph for gimp. Check this monstrosity out!

That&#8217;s a _lot_ of dependencies! But it isn&#8217;t considered a problem, and I don&#8217;t think you&#8217;ll find anyone out there complaining that gimp&#8217;s dependency chain is &#8220;too long&#8221;.

The difference is that debian packages _always install cleanly_. Install failures are rare, and are fixed very quickly.

By contrast, modules installed via the CPAN shell fail pretty often. This is a case of our own culture biting us in the ass. Debian packages do not run any tests on install. The package maintainers are just responsible for making sure that the package installs cleanly. If the package has bugs, the maintainer fixes them (or gets upstream to fix them) and makes a new package. In most cases, there probably isn&#8217;t even a test suite for the maintainer to run.

Perl has a great culture of testing. We expect all modules uploaded to CPAN to come with a test suite, and we expect modules to run their tests on install and to pass. I love that we have such high standards, but these standards are not without problems. When a module fails its tests, the person doing the install isn&#8217;t in a good position to handle it. In many cases, they could probably force the install and use the module, but how could they know that?

I&#8217;m not sure what the solution is. One possibility is for module authors to cut back on the number of tests that they run on install. We could start moving most of the tests to an &#8220;authors only&#8221; test directory. That seems kind of sad though.

Maybe there&#8217;s also an education component. We could tell people that it&#8217;s ok to force an install of a dependency, as long as the module they want to install passes _its own tests_. For example, if I&#8217;m installing Catalyst, I can probably live with a failure in the Data::Dump test suite, as long as Catalyst works.

Maybe the CPAN shell could have a mode where it simply ignored dependency test failures, but delayed really installing them until checking that the originally requested module passes its tests with said dependencies.

This solution accounts for the reality that everything has bugs. The Catalyst authors can work around bugs in their dependency chain, and all you as an end-user _really_ care about is that you can use Catalyst as advertised.

I&#8217;m not sure what the best solution is, but I do know that the solution is _not_ to demand that module authors reduce their dependencies &#8220;on principle&#8221;. Encouraging wheel reinvention reduces code quality, even though it could give the _appearance_ of less failure. This would just move failure from CPAN install time to &#8220;using the module full of reinvented crap&#8221; time.

 [1]: /2009/05/02/dependencies-rule/
 [2]: http://alioth.debian.org/~fjp/debtree/

## Comments

### Comment by Chas. Owens on 2009-05-07 13:12:28 -0500
Ah, but Debian packages only have to work on one OS, and the basic configuration is known. If someone builds a Linux From Scratch box, they are rarely surprised that a Debian package doesn&#8217;t work, or that they must use workarounds to get it functional. CPAN modules on the other hand are expected to install on a dozen OSes with perl installs built in a variety of ways.

In general, I prefer to install Perl modules through my native package system (rather than CPAN) because I know they have all been built and tested together and when the time comes to update or remove them the package system knows how to do it safely. That said, I use CPAN to get the latest version of a module (if I need it), but I only ever install modules in my home directory. The system directories are the OSes domain, the most recent breakage on OS X proves that point.

### Comment by Dave Rolsky on 2009-05-07 13:40:38 -0500
@Chas: Yes, Debian definitely has it easier. My point was simply that it&#8217;s not dependencies that are the problem, it&#8217;s dependencies _which don&#8217;t install cleanly_.

The solution is not to reduce dependencies, it&#8217;s to increase reliability and/or lower the bar for success.

### Comment by Michael Peters on 2009-05-07 16:19:45 -0500
I like the idea of having a CPAN mode where dependency failures are ignored until after the primary module&#8217;s test suite has failed. While I don&#8217;t envy the person implementing that (special care would be needed to show the user in a non-flood way which dependencies failed and how) it would be incredibly useful.

I was installing Smolder (my own package) on a new box the other day and had to force install several modules who&#8217;s Pod tests failed. These were dependencies of dependencies of &#8230; But Smolder didn&#8217;t care if some module 5 levels deep has POD problems.

### Comment by Chas. Owens on 2009-05-07 17:49:31 -0500
@Dave Rolsky: Well, install cleanly and in a timely fashion. The other gripe I generally have with CPAN is the length of time it takes to build some of the larger modules (especially the XS ones).

The best solution I can see is working with the OS people for the various Linuxes to make sure important modules are in their package system (and are updated frequently) and creating a binary package system like ActiveState&#8217;s ppm for the OSes that don&#8217;t have (decent) package systems. But that is a lot of non-trival work. It even has legal issues (if I remember correctly ActiveState stopped distributing some DBD::* modules because of legal threats from Oracle and the like).

It would be nice to be able to say

cpan> o conf binary only

and have CPAN install a binary version for my OS without running any tests. Or

cpan> o conf binary prefered

and have it install a binary version of a module if it exists or build it if it doesn&#8217;t. Or

cpan> o conf binary never

to get the current behavior. It would be even nicer if the binary option used the native package management system to get/install the module. Hmm, this shouldn&#8217;t be too hard to add on Debian/RedHat based systems.

### Comment by Kyle Keen on 2009-05-07 19:37:51 -0500
It is interesting to compare that dependency chart to other distros.

Here is Gimp on Arch:  
<a href="http://kmkeen.com/pacgraph/gimp.png" rel="nofollow ugc">http://kmkeen.com/pacgraph/gimp.png</a>

### Comment by Bruno Vecchi on 2009-05-24 16:44:09 -0500
Another problem with CPAN vs. debian&#8217;s package management is how it deals with test failure due to absence of external libraries (header files). It&#8217;s an easy thing to fix if you know what is happening, but the output when a header file is missing is definitely not beginner-friendly in most cases.

### Comment by Dave Howorth on 2009-05-26 08:41:30 -0500
_&#8220;Maybe the CPAN shell could have a mode where it simply ignored dependency test failures, but delayed really installing them until checking that the originally requested module passes its tests with said dependencies.&#8221;_

It would also need to make sure the part-failed module still didn&#8217;t appear to be installed for any other perl programs that ran, since they might have different test dependencies. It would be difficult to diagnose subsequent problems that weren&#8217;t reported. Extending the &#8216;site\_perl&#8217; and &#8216;vendor\_perl&#8217; paths to ${app}_perl or somesuch.

### Comment by Perrin Harkins on 2009-05-29 00:05:04 -0500
Running the tests in the CPAN shell before every module install was never very realistic and gets less so every day. I remember back in the early days of working with mod_perl, when the Perl testing culture was not that strong. I would find modules didn&#8217;t install with the CPAN shell because the tests were written in a way that would never run on any computer except the author&#8217;s. When I told authors about this, they would say &#8220;Oh, I&#8217;ve never used the CPAN shell. I just install modules in the normal way.&#8221;

No one does that anymore, because the dependency chains are now too long and annoying to do manually. We have to use the CPAN shell. (Or make alternative packaging of some kind, but that&#8217;s a different story.) So, CPAN.pm should stop running the tests. Either they should be off by default, or it should be obvious how to turn them off globally. If someone is having trouble with a module, they can go run the tests then.

Simply turning off the tests in the CPAN shell would make installing Moose a reasonable thing and do away with nearly all griping about dependencies.

### Comment by Jonathan Swartz on 2009-06-25 18:16:06 -0500
It is easy to install things without running tests:

notest install Moose

I do it reflexively now &#8211; in fact, I should figure out how to turn it on permanently, just because I forget occasionally.

But you&#8217;re right that this should be advertised more heavily.

### Comment by Mihai Bazon on 2009-07-07 03:44:28 -0500
I use Perl for 8 years now, yet I didn&#8217;t know about &#8220;notest&#8221;. :-) This definitely needs more exposure.

Yeah, requiring tests at install time sucks. It took me one hour to install my own product on a new machine, because various tests failed in dependencies. Tests are good for developers, but once a module is released it should be considered reasonably stable and already tested.

However, it&#8217;s probably unfeasible to remove tests completely because CPAN cannot automatically install missing libraries (i.e. if some module needs libwhatever.so and that&#8217;s not available from CPAN). Then it&#8217;s better to know at install time that you&#8217;re going to have trouble, rather than have the module installed and trying to figure out later why it doesn&#8217;t work.