---
title: Isn’t Email Great?
author: Dave Rolsky
type: post
date: 2014-07-23T20:13:59+00:00
url: /2014/07/23/isnt-email-great/
categories:
  - Uncategorized

---
Apparently my post on [Perl 5&#8217;s overloading][1] is deeply, deeply offensive. Here&#8217;s an email I got out of the blue today:

> Perl isn&#8217;t your first language isn&#8217;t it?  You strike me as Java programmer.  Look.  Don&#8217;t do overloading.  If you need to do overloading then you are probably doing something wrong.
> 
> &#8220;If you don’t care about defensive programming, then Perl 5′s overloading is perfect, and you can stop reading now. Also, please let me know so I can avoid working on code with you, thanks.&#8221;
> 
> No.  I don&#8217;t, because we are not programming in Java where that type of mentality is needed.  So yeah, please feel free to memorize my name and lets make damn sure we never work with each other. 

And people say there&#8217;s no hope for humanity!

 [1]: http://blog.urth.org/2010/10/16/whats-wrong-with-perl-5s-overloading/

## Comments

### Comment by Darren Duncan on 2014-07-23 16:08:25 -0500
I see overloading as something best done in very limited circumstances, such as where the object truly is meant to exactly mimic a built-in type and users should be able to use them interchangeably without even knowing they have an object. A solid example just from the last few days on the <rose-db-object@googlegroups.com> mailing list is that Perl&#8217;s Math::BigInt and such objects overload stringification, so if you want a string of an integer, saying &#8221;.$foo just works regardless of whether $foo is a native integer or a BigInt object. The use case was where an application using Rose::DB::Object was returning Math::BigInt objects on 32-bit platforms and native Perl integers on 64-bit platforms, and using the stringification overload was the simplest way for the application to have clean portable code.

### Comment by Caleb Cushing on 2014-07-23 16:26:11 -0500
this reminds me of why I decided to quit looking for perl work and moved to being a java programmer. I got tired of dealing with /that guy/

### Comment by Dave Rolsky on 2014-07-23 17:31:38 -0500
I&#8217;m not against overloading at all. I just find Perl 5&#8217;s implementation broken. Really, I think any overloading to emulate built-in types that isn&#8217;t done based on interfaces (like Go) or roles (like Perl 6) is just going to be broken.

### Comment by Jeremy Leader on 2014-07-24 11:37:48 -0500
Did your correspondent just try to make &#8220;not knowing another language before (or after) Perl&#8221; a badge of distinction? Or a claim of authority? &#8220;I don&#8217;t know any languages other than Perl, therefore my opinion on questions of Perl style overrules yours.&#8221; Wow!

### Comment by Peter Rabbitson on 2014-07-25 04:05:19 -0500
Dave! You are a terrible programmer!!! The <a href="http://blog.urth.org/2010/10/16/whats-wrong-with-perl-5s-overloading" rel="nofollow">shit sundae you posted back in 2010</a> is woefully incomplete. Here is <a href="https://github.com/dbsrgits/sql-abstract/blob/e8d729d48/lib/SQL/Abstract.pm#L93-L127" rel="nofollow">how &#8220;real non-Java programmers&#8221; do it</a>. 

I am appaled by your lack of knowledge on the simplest of subjects, we are \*NEVER\* working together on anything!!!

Cheers ;)