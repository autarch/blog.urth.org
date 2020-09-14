---
title: Who Are the Perl 5 Core Docs For?
author: Dave Rolsky
type: post
date: 2011-03-16T14:36:26+00:00
url: /2011/03/16/who-are-the-perl-5-core-docs-for/
categories:
  - Uncategorized

---
I&#8217;ve been spending a fair bit of time working on Perl 5 core documentation. I started by editing and reorganizing some of the documents related to core hacking. This update will be in 5.14, due to be released in April. I&#8217;m also working on replacing the existing OO tutorials and updating the OO reference docs, though this won&#8217;t make it into the 5.14 release.

There&#8217;s been a lot of discussion on my OO doc changes, some of it useful, some of it useless, and some of it very rude (welcome to p5p!). Many of the people in the discussion don&#8217;t have a clear vision of who the docs are for. Without that vision, it&#8217;s really not possible to say whether a particular piece of documentation is good or not. A piece of documentation has to be good _for a particular audience_.

There&#8217;s a number of audiences for the Perl 5 core docs, and they fall along several axes. Here are the axes I&#8217;ve identified.

## Newbies vs experienced users

Newbie-ness is about being new _to a particular concept_. You could be an experienced Perl user and still be new to OO programming in general, or new to OO in Perl.

For my OO docs, I&#8217;m writing for two audiences. First, I&#8217;m writing for people who are learning OO. That&#8217;s why the document starts with a general introduction to OO concepts. Second, I&#8217;m writing for people who want to learn more about how to do OO in Perl 5. For those people, the tutorial points them at several good OO systems on CPAN.

I&#8217;m _not_ writing for people who already know Perl 5 OO and want to learn more, that&#8217;s what the perlobj document is for.

From the discussion on p5p, I can see that many people there have trouble understanding how newbies think. I like how chromatic addresses these issues in a [couple][1] of his [blog posts][2].

## How the reader uses Perl

Perl is used for lots of different tasks, including sysadmin scripts, glue code in a mostly non-Perl environment, full app development, etc.

Ideally, we&#8217;d have tutorial documents that are appropriate for each of these areas. I think the OO tutorial is most likely to be of interest to people writing full Perl applications. If you&#8217;re just whipping up some glue code, OO is probably overkill.

It would also be great to see some job-focused tutorials, like &#8220;Basic Perl Concepts for Sysadmins&#8221; or &#8220;Intro to Web Dev in Perl 5&#8221;. Yes, I know there are books on these topics, but having at least some pointers to modules/books/websites in the core docs is useful.

## Constraints on the reader&#8217;s coding

If you&#8217;re doing green field development, you have the luxury of using the latest and greatest stuff on CPAN. If you&#8217;re maintaining a 10-year old Perl web app (I&#8217;m so sorry), then you probably don&#8217;t. Some readers may not be able to install CPAN modules. Some readers are stuck with in house web frameworks.

People stuck with old code need good reference docs that explain all the weird shit they come across. People writing new code should be guided to modern best practices. They don&#8217;t need to know that you can implement Perl 5 OO by hand using array references, ties, and lvalue methods

My OO tutorial is obviously aimed toward the green field developers. It&#8217;s all about pointing them at good options on CPAN. As I revise perlobj, I&#8217;m trying to make sure that I cover every nook and cranny so that the poor developer stuck with 2001 Perl OO code can understand what they&#8217;re maintaining.

(Sadly, that&#8217;s probably _my_ code they&#8217;re stuck with.)

## Conclusion

I&#8217;d like to see more explicit discussion of who the intended readers are when we discuss core documentation. Any major doc revision should start with a vision of who the docs are for.

There&#8217;s probably other axes we can think about when writing documentation as well. Comments on this are most welcome.

 [1]: http://www.modernperlbooks.com/mt/2011/03/on-the-hostility-of-user-documentation.html
 [2]: http://www.modernperlbooks.com/mt/2011/03/why-modern-perl-teaches-oo-with-moose.html

## Comments

### Comment by brian d foy on 2011-03-16 16:07:08 -0500
This is essentially why Perl marketing sucks. People tend to think that &#8220;marketing&#8221; means the Perl community beating the Perl community&#8217;s message into the heads of everyone else in the world, instead of carefully thinking about who&#8217;s using Perl and what those people and groups need to get to do their work effectively.

One of the things I constantly have to say in Perl classes is that &#8220;You may not need this or ever use it, but you&#8217;ll probably run across some code that does&#8221;. That&#8217;s one of the reasons something like _Learning Perl_ must partially-ignore &#8220;Best Practices&#8221;. We have to teach people to deal with bad code as well as write good code. If we only showed the latest fad, we&#8217;d alienate most of our audience since they have to work with stuff that already exists and they have little power to change drastically.

### Comment by Mark A. Stratman on 2011-03-16 16:18:29 -0500
I&#8217;ve been on about this topic for a while now (e.g. <a href="http://www.nntp.perl.org/group/perl.perl5.porters/2011/03/msg169804.html" rel="nofollow ugc">http://www.nntp.perl.org/group/perl.perl5.porters/2011/03/msg169804.html</a> )

And been starting to write (and outline a talk), urging for us all to make greater efforts to acknowledge the difference between \*reference\* documents, and \*tutorial\* documents, and the goals of the readers of each.

I&#8217;m glad to see you pushing on this branch of the discussion as well (albeit in a more articulate, and louder voice ;)

&#8220;I&#8217;d like to see more explicit discussion of who the intended readers are when we discuss core documentation.&#8221; &#8230;  
I&#8217;ve always taken for granted that the very nature of Perl is &#8220;all things to all people&#8221;, and the result has been its monstrous and unwieldy pile of perldocs.

In my opinion this naturally leads to multiple tracks of documentation:  
* Reference / API  
* Tutorials  
* FAQ&#8217;s / How do I&#8230; ?  
and so on.

Within each track you find a different set of underlying assumptions about the reader, his/her purpose for reading, and preexisting knowledge.

Your post here seems a good first step toward getting the commuity to decide exactly what these assumptions are (then ideally, rewriting and reorganizing the docs accordingly).

That&#8217;s my 20-second projected approach to this question anyhow. I&#8217;m curious to see where you&#8217;re going with this though. :)

### Comment by Robert on 2011-03-19 20:44:52 -0500
I think by default if someone is looking up how to do OO in Perl, that person is NOT a newbie.

### Comment by Dave Rolsky on 2011-03-19 23:10:41 -0500
@Robert: I alluded to this a bit in my blog entry, but &#8220;newbieness&#8221; is all relative. Someone could know OO but not know OO in Perl. Someone could know Perl but not know OO.

I think by definition anyone wanting to read a tutorial on OO in Perl is probably new to that topic. That&#8217;s the readership that something called a tutorial attracts.