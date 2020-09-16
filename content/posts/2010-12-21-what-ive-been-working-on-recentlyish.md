---
title: What I’ve Been Working on Recently(ish)
author: Dave Rolsky
type: post
date: 2010-12-21T16:11:52+00:00
url: /2010/12/21/what-ive-been-working-on-recentlyish/
---
I've written quite a few new modules in the past few months, but I haven't really written about them. Here's a summary of recent(ish) releases.

## [Silki][1]

(Ok, this isn't really recent, since the first release was in May.)

Silki is a wiki application built with [Catalyst][2] and [Fey::ORM][3].

Silki is a multi-tenant wiki hosting system. Translated into English, that means that once you install Silki, you can host many wikis, each of which can have totally different sets of users. Each wiki also has its own set of access controls, from "guests can edit" to "members only".

One of my main goals for Silki is to make it as easy to use as possible. That means a couple things. First, it means not adding tons of features. A lot of wikis seem to suffer from geekitis, with dozens of fascinating and confusing minor features. Second, I'm trying to build an easy to use UI, though whether that's been achieved is highly debatable. It's still missing at least one key feature in this department, a wysiwyg editor.

If you're in need of some wiki software, please take a look. I've worked on making it easier to install than a lot of Perl apps on CPAN, though there's still a long way to go. See [the Admin manual][4] for details. However, note that it requires Postgres 8.4+.

## [Dist::Zilla::Plugin::Conflicts][5]

If you've been around on IRC, you might've heard me whining about the lack of conflict support in the Perl module toolchain. This module integrates Jesse Luehr's [Dist::CheckConflicts][6] with [Dist::Zilla][7]. This isn't a substitute for support in the installer itself, but it's still useful.

If you maintain a module with a significant number of downstream dependencies, please consider declaring conflicts in your releases.

## [Antispam::httpBL][8] and [Antispam::Toolkit][9]

The Antispam::Toolkit module is a framework for writing spam-checking modules like Antispam::httpBL. The latter uses the Project Honeypot HTTP blacklist to generate a spam score for a user. I have some unreleased work on an Antispam::StopForumSpam module that I need to finish that also uses the Antispam::Toolkit.

My ultimate plan is to write a spam checking tool that can be used to check user-submitted content (or just the users) for spamminess. I want something that does for blogs, wikis, forums, and other web apps what [SpamAssassin][10] does for email.

## [Pg::CLI][11]

This distro provides simple Perl OO wrappers around several of the Postgres command line utilties. For now, it only supports `psql`, `pg_dump`, and `pg_config`. Patches to add support for other utilities are welcome.

## [Pg::DatabaseManager][12]

While writing Silki (and another webapp I need to blog about) I wrote a lot of database management code. This code deployed a schema, ran migrations, etc. I really wanted to make this code reusable, so I packaged it up as Pg::DatabaseManager (and Pg::CLI).

If you're using Postgres and you want to automate database installs and updates, this may be helpful. It's designed to be subclassed, but I haven't really documented that part of the module yet. If you use this, please let me know _how_ you used it so I know what I need to document.

As a bonus, it also provides what I think is a rather clever tool for doing automated tests of your migrations.

## [MooseX::Configuration][13]

This is another piece of code inspired by generalizing something I wrote for Silki. This module lets you add metadata to a class's attributes to associate an attribute with a particular key in a configuration file. It only supports INI-style files (for now?).

It also knows how to read and write config files. The writing is a bit "special" because it includes each attribute's documentation metadata (and attribute defaults) as comments in the generated config file. This lets you create a more user-friendly config file. Remember, the config file is part of your application's interface too! Be kind to the sysadmin who only looks at the config file every six months.

## [Emplacken][14]

Don't use this yet, it's fairly broken ;)

The concept for Emplacken is to let you manage one or more Plack apps from a set of config files, one file per application. It also knows how to generate the PSGI app skeleton for some frameworks, so you don't actually have to have any `.psgi` files installed.

The first release also attempted to add support for pid files, privilege dropping, and error logging.

This is all useful stuff, but I think I need to break it out a little different. Support for pid files, privilege dropping, and error logging belongs in some sort of process management code. There are lots of options here, including start-stop-daemon (widely used in some Linux distros like Debian), daemontools (for people who've smoked the D.J. Bernstein crack), and Perl solutions like [FCGI::Engine][15].

The latter, despite the name, really isn't FCGI-specified, and can already be used for Plack apps, but it doesn't support error logs or privilege dropping.

My goal is to make Emplacken a tool that reads config scripts, maybe generates some `.psgi` files, and then calls some supervisor to start/stop the daemons.

 [1]: http://search.cpan.org/dist/Silki
 [2]: http://search.cpan.org/dist/Catalyst
 [3]: http://search.cpan.org/dist/Fey-ORM
 [4]: http://search.cpan.org/dist/Silki-Manual-Admin
 [5]: http://search.cpan.org/dist/Dist-Zilla-Plugin-Conflicts
 [6]: http://search.cpan.org/dist/Dist-CheckConflicts
 [7]: http://search.cpan.org/dist/Dist-Zilla
 [8]: http://search.cpan.org/dist/Antispam-httpBL
 [9]: http://search.cpan.org/dist/Antispam-Toolkit
 [10]: http://spamassassin.org
 [11]: http://search.cpan.org/dist/Pg-CLI
 [12]: http://search.cpan.org/dist/Pg-DatabaseManager
 [13]: http://search.cpan.org/dist/MooseX-Configuration
 [14]: http://search.cpan.org/dist/Emplacken
 [15]: http://search.cpan.org/dist/FCGI-Engine

## Comments

**Richard Huxton, on 2010-12-22 09:43, said:**  
Regarding Pg::DatabaseManager, you can enforce having only a single row for the "Version" table with something like:

```sql
CREATE UNIQUE INDEX only_one_version_allowed ON "Version" ((true));
```

This creates an expression index on (true) which prevents any subsequent rows being inserted.

<http://www.postgresql.org/docs/9.0/static/indexes-expressional.html>

**Michael Peters, on 2010-12-22 13:25, said:**  
For the anti-spam stuff for blogs, etc, I've been happy with Mollom (<http://mollom.com>) using my Net::Mollom module. It's free for small size things. The nice thing about using a service like this is that it can learn as it goes and my spam protection benefits from what it learns from other people's content.

Also, for process managment stuff that you had Emplacken doing, you might want to look at Ubic (<http://search.cpan.org/perldoc?Ubic>). I haven't used it myself, but it looks pretty nice.

**Rob N, on 2010-12-24 03:19, said:**  
If you already have a SpamAssassin instance lying around you might like to take a look at Text::SpamAssassin.
