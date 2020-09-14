---
title: What is Catalyst, Really?
author: Dave Rolsky
type: post
date: 2009-07-02T11:54:32+00:00
url: /2009/07/02/what-is-catalyst-really/
categories:
  - Uncategorized

---
A [recent thread on the Mason users list][1] reminded me of the problems I had grokking Catalyst when I first looked at it. Raymond Wan wrote &#8220;I&#8217;m skimming over the MVC part and as my system doesn&#8217;t use an SQL database, I&#8217;m wondering if Catalyst is overkill??&#8221;

Those of us who know Catalyst know that this question is based on some wrong assumptions, but it&#8217;s easy to see why Raymond has those assumptions. Look at the [Catalyst tutorial][2]. In the very first chapter, it&#8217;s already talking about databases and [DBIx::Class][3].

It&#8217;s easy to look at this and assume that Catalyst is somehow tightly bound to DBIx::Class or SQL databases.

The problem is that the tutorial docs really need to serve two different audiences, though both audiences are Catalyst newbies.

On the one hand, you have people with relatively little web app experience. Presumably, they know some Perl, and they do a web search for &#8220;perl web application framework&#8221;. Eventually, they&#8217;ll get to Catalyst and start reading about it. For those people, being given a set of standards and a full walk through of Model and View (in addition to Controller) is very valuable. It gives them all the tools they need to get started on simple web apps without having to make too many choices.

The other audience is people who have some real web app development experience with something more primitive than Catalyst. These could be people coming from a Mason-based site without any real controllers, or people who used something like Apache::Template with mod&#95;perl, or maybe they wrote their own controllers &#8220;by hand&#8221; using the mod&#95;perl API.

Many of those folks will already have some experience with models. To refer back to Raymond, presumably his system already has some sort of model code, it just doesn&#8217;t use a SQL DBMS. Those people will look at the existing Catalyst tutorial and get confused. Isn&#8217;t Catalyst flexible? Then why does it look like RoR, with all my tool choices made for me?

It took me a while to realize that Catalyst, at its core, is smaller than you might think, and you can use just the pieces you like.

The very core of Catalyst is its dispatching system. Given a URI, it selects a piece of code to run. Its dispatcher is very powerful (Chained methods are great!), and with plugins like [Catalyst::Action::REST][4], it&#8217;s even better.

Along with the dispatching system, Catalyst also provides an abstraction over the typical web app request/response cycle. The Request makes it easy to look at incoming query arguments, POST data, file uploads, and headers. The Response lets you set headers and return output to the client, whether that be HTML or a downloadable file.

Catalyst also includes engines (think &#8220;environment adapters&#8221;) for a number of common web application environments, including vanilla CGI, mod_perl, FastCGI, and more. These engines make sure that the Request/Response API works exactly the same in any environment where Catalyst can be deployed.

This is a huge win, since you can write your app without worrying about the deployment environment. If you&#8217;re writing an app for public distribution, it gives the installing users a choice of how to deploy.

These core pieces are really the only parts of Catalyst you have to use when you use Catalyst. If you don&#8217;t want dispatch and a request/response API, you don&#8217;t want Catalyst.

Catalyst (really [Catalyst-Devel][5]) also includes a fantastic single-process development server. This server can be started straight from an application&#8217;s checkout directory with one command. Even better, this dev server can be told to monitor all relevant files and restart itself when any of them change. Note that this is a proper restart, which avoids all the myriad problems that afflict Apache::Reload and its ilk, which attempt to reload modules in the same Perl interpreter.

Just these things &#8211; controllers, a request/response abstraction, deployment agnosticism, and a great dev environment &#8211; are enough to make Catalyst a great choice. Ignore everything else it does and you&#8217;ll still have improved your development process and improved your code.

Catalyst also does some other things &#8230;

It has a component system which has allowed people to release a whole host of useful plugins. If you look on CPAN, you&#8217;ll find things like [sessions][6], [powerful authentication][7], [dumb authentication][8], [I18N][9], and much more. If a plugin does what you need, it&#8217;ll save you a lot of development time.

Note that the old &#8220;Catalyst::Plugin&#8221; system is in the process of being deprecated, but the concept of pluggable components is still core to what Catalyst is. All that&#8217;s changed is the way pluggability works.

Catalyst lets you have multiple views. While many apps will just output HTML via a templating system, this flexibility is great for RESTful apps that may want to output XML, JSON, and still fall back to HTML for browsers (see my [REST-ForBrowsers][10] for some help with that).

Catalyst also has configuration file handling built-in. Personally, I avoid it, because it only works within the context of the whole &#8220;Catalyst environment&#8221;. That means it&#8217;s awkward at best to load the configuration outside of the web environment. I always make sure that application wide setting are available for things like cron jobs. This falls into a category of Catalyst features which are not best practices, but are probably useful for people writing their first web app.

Catalyst gives you hooks for models. Again, this is something I never use, but it&#8217;s another &#8220;useful for web app n00bs&#8221; feature.

There&#8217;s probably many other things I&#8217;ve left out. The point is that Catalyst provides a very powerful set of core web app tools, and that core is actually small.

Relative to a &#8220;my way or the highway&#8221; type framework (RoR and Jifty, I&#8217;m looking at you), it&#8217;s easy to port an existing application to Catalyst. In fact, using [Catalyst::Controller::WrapCGI][11], you can wrap an existing CGI application with Catalyst, and then convert slowly over to &#8220;native&#8221; controllers.

And most importantly, you can move to Catalyst without touching your model at all! Since many applications have the bulk of their code in the models (at least, they do if you&#8217;re doing it right), this is a huge win.

Next step is to turn some of this rambling into doc patches. I think a section of the Catalyst tutorial aimed at folks coming from an &#8220;old school&#8221; web app background would be great, and would really help people like Raymond (and would&#8217;ve helped me a few years back).

 [1]: http://www.nabble.com/new-Mason-tutorial-to24256045.html
 [2]: http://search.cpan.org/~hkclark/Catalyst-Manual-5.8000/lib/Catalyst/Manual/Tutorial/01_Intro.pod
 [3]: http://search.cpan.org/dist/DBIx-Class
 [4]: http://search.cpan.org/dist/Catalyst-Action-REST
 [5]: http://search.cpan.org/dist/Catalyst-Devel
 [6]: http://search.cpan.org/dist/Catalyst-Plugin-Session
 [7]: http://search.cpan.org/dist/Catalyst-Plugin-Authentication
 [8]: http://search.cpan.org/dist/Catalyst-Plugin-AuthenCookie
 [9]: http://search.cpan.org/dist/Catalyst-Plugin-I18N
 [10]: http://search.cpan.org/dist/Catalyst-Request-REST-ForBrowsers
 [11]: http://search.cpan.org/dist/Catalyst-Controller-WrapCGI

## Comments

### Comment by devin.austin on 2009-07-02 19:00:40 -0500
Excellent post. People don&#8217;t realize just how flexible Catalyst is and how it was designed really, as a glue system. I like to think of Catalyst as something that allows you to customize it into a framework of your own, that makes sense to you, while still (if you&#8217;ve done things sanely) looking like Catalyst and being readable by others.

++ to you.

### Comment by Vince Veselosky on 2009-07-02 21:48:13 -0500
Dave, Great article, and you&#8217;re right that this needed to be said. Interestingly, I have so far shied away from Catalyst in my professional work precisely because of the virtues you describe. My deployment environment is locked into being Apache/mod_perl, so I have no need for a uniform multi-environment API. And I find that mapping URIs to handlers can be done remarkably easily with a couple of lines of Apache configuration. Why every web framework in existence insists on reimplementing this Apache feature is beyond my understanding.

I will admit to having a twinge of test envy, however. It&#8217;s amazingly easy to run complex tests for Catalyst apps against the Dev server, much easier than the equivalent Apache::Test tools for mod_perl. This alone would be good reason to select Catalyst for new development.

BTW your &#8220;dumb authentication&#8221; is perhaps too much modesty. Signed cookies allow verification of identity that is &#8220;good enough&#8221; for most applications, yet requires no server state and is therefore perfectly RESTful (and more importantly, scalable). That&#8217;s clever in my book.

### Comment by Oliver Gorwits on 2009-07-04 15:34:05 -0500
> The very core of Catalyst is its dispatching system.  
> Given a URI, it selects a piece of code to run.

Spot on! Every time I need to explain Catalyst to someone, this is exactly the tack I use. Most coders have familiarity with even a basic if/elsif/else dispatch system in their old CGI.

This is the &#8216;hook&#8217; that gets them to understand Catalyst, and the rest is just what puts a smile on their face.

### Comment by Larry Leszczynski on 2009-08-15 21:09:02 -0500
Dave said:

> Look at the Catalyst tutorial. In the very first chapter, it&#8217;s already talking about databases and DBIx::Class. 

Good point, I had the same impression when I first ran through the tutorial.

Ashley Pond has some good newbie-friendly non-database model examples in his <a href="http://sedition.com/a/2733" rel="nofollow">10 Catalyst models in 10 days</a> articles.

Larry