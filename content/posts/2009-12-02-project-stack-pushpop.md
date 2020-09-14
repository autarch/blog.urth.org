---
title: Project Stack Push/Pop
author: Dave Rolsky
type: post
date: 2009-12-02T16:26:54+00:00
url: /2009/12/02/project-stack-pushpop/
categories:
  - Uncategorized

---
I have an amazing ability to get distracted from my goals when programming. Sometimes it feels like each project I work on is just the latest distraction from what I **was** working on. Usually this happens because I&#8217;m happily hacking away on project A until I hit a roadblock. That roadblock might be a missing feature in a module I&#8217;m using, or maybe a module I need that doesn&#8217;t exist. Sometimes the roadblock is a gap in my understanding. I don&#8217;t know how to do what I want in a satisfactory way, so I need to learn more about a tool, or just experiment with ways to approach the problem.

I push a new project onto the stack and off I go. I don&#8217;t know how deep the stack is now. There&#8217;s probably items that were on ther elong ago that have already been forgotten.

Here&#8217;s an example of where I am in my stack right now:

  * Working on [VegGuide][1] and other things, I&#8217;ve become thoroughly sick of Alzabo &#8230; 
      * so I play with DBIx::Class but it doesn&#8217;t grab me &#8230;
      * I write [Fey::ORM][2] &#8230;
  * and back to VegGuide, but I really don&#8217;t like a lot of things about it, I need to explore new ways of writing webapps &#8230; 
      * I start working on a [new webapp][3], a donor/volunteer management app for nonprofits. By building an app from scratch I can get a better understanding of how I want to write modern webapps. But this type of app is rather complicated so &#8230; 
          * having been unhappy with [MojoMojo][4], I start working on a [wiki][5] designed for non-geeks (target audience, my animal rights group). I&#8217;m using Markdown as the wikitext language, but the existing Markdown tools in Perl don&#8217;t do what I want so &#8230; 
              * I write [Markdent][6].
          * now I&#8217;m running into major issues with [HTML::WikiConverter][7], which I use to turn GUI-generated HTML back to Markdown. The temptation to fix/rewrite is strong &#8230; 
              * sigh

Of course, it&#8217;s not really quite as simple as this might imply. It&#8217;s not like the _only_ reason for working on a donor management application is to explore webapps. It&#8217;s useful all on its own.

Even scarier is the fact that there are other unrelated projects that keep trying to intrude, like making ACT run on mod_perl2 so I can upgrade my server from Dapper to Hardy. I&#8217;ve managed to put that one off for a while, at least, but it keeps nagging at me.

My capacity for adding projects to my stack is simultaneously impressive and disturbing. There&#8217;s no problem so compelling that it can&#8217;t be superceded by a new problem uncovered in the course of solving the original.

 [1]: http://www.vegguide.org
 [2]: http://search.cpan.org/dist/Fey-ORM
 [3]: http://hg.urth.org/hg/R2
 [4]: http://mojomojo.org/
 [5]: http://hg.urth.org/hg/Silki
 [6]: http://search.cpan.org/dist/Markdent
 [7]: http://search.cpan.org/dist/HTML-WikiConverter

## Comments

### Comment by Ron Savage on 2009-12-02 17:55:49 -0600
Hi Dave

I&#8217;m close to releasing a contacts manager, CGI::Office::Contacts, which will have an importer, CGI::Office::Contacts::Import::vCards, and a donation-addon, CGI::Office::Contacts::Donations.

I wonder if we&#8217;re working on parallel paths :-)?

Cheers  
Ron

### Comment by Randal L. Schwartz on 2009-12-02 22:28:33 -0600
Welcome to Yak Shaving. :)

### Comment by Dave Rolsky on 2009-12-02 22:37:16 -0600
So many yaks, so little time.

### Comment by Eric Larson on 2010-01-04 10:38:05 -0600
Geez, this sounds familiar&#8230; And yes, it is pretty scary :)