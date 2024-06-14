---
title: My Programming-Related Todo List
author: Dave Rolsky
type: post
date: 2010-11-01T11:43:56+00:00
url: /2010/11/01/my-programming-related-todo-list/
---

I often wish that I had an infinite supply of time, motivation, and skill. If I did, I bet I could
get a lot done! My programming (and programming-related) todo list includes so many items that I'm
quite sure I'll never get to most of them.

Here's my current list, though I'm probably missing some stuff, in no particular order ...

## CPAN Search `$NEXT`

I've been thinking about this for quite some time, but I haven't really done much with it. I played
with [CPANHQ][1], which had some promise, but has stalled.

My wanted list for a new search.cpan is really long, and includes:

- Open source. It's ridiculous that a key piece of the Perl community infrastructure is closed.
- Modern Perl, probably Catalyst, Moose, and DBIC, to make it as easy as possible for the whole
  community to contribute.
- Modern look and feel. The current site is usable, but not beautiful.
- Excellent full text search. The current search is not bad, but it could be better.
- Author-specified documentation ordering. The Moose Manual docs should be listed first on the Moose
  page, for example.
- Easy to find and analyze dependency information. Basically, I'd love to take the information from
  <http://deps.cpantesters.org/> and what used to be on the now-defunct CPAN Kwalitee site and borg
  that.
- Similarly, I'd like to borg CPAN ratings, AnnoCPAN, etc. All the CPAN information should be in one
  place with a spiffy UI.
- I've long wanted some sort of "web of trust" system for CPAN. A CPAN user would mark authors
  and/or distributions as trusted. We'd take the graph of trust relationships and try to figure out
  which authors and modules are most trusted. Trust here would be some combination of good code,
  good docs, responsive author, whatever. The idea is to organically highlight the best of CPAN, and
  in particular help people discover the best modules in their class. I think this would be really
  useful for new users, and a lot more useful than the current CPAN rating system.
- Incorporate all of BackPAN, just cause.
- A million ideas that other people will have.

This is a huge project, and while I think it would be useful, the current site works well enough
that it's not exactly urgent.

## Full CLDR in Perl

I really want to make the full set of [CLDR][2] data available in Perl. This would greatly improve
`DateTime::Locale`, and would be generally useful for lots of other things. There are two
approaches, one is to write a Perl binding to the ICU4C library, the other is to parse the raw data
files and generate Perl modules. `DateTime::Locale` is currently doing the latter, but not terribly
well. A C library binding would be easier, but then requires the end user to have the ICU C library
installed.

Either way, this is a metric frakton of work.

## DateTime V2.0

I'd really like to rewrite large chunks of `DateTime.pm` and the DateTime suite using modern tools
like Moose. I'd also like to fix up all of the many stupid API decisions I made over the past seven
years or so. Some of this would include ...

- Make a date-only module.
- Make leap seconds optional. For most uses you don't care about this, since the exact number of
  seconds between two points in time is not that important. The code for dealing with leap seconds
  makes everything more complicated.
- Using floating point fractional seconds instead of nanoseconds.
- In particular, make the `DateTime::Duration` API less crack-tastic.
- If possible, code it for faster runtime speed.
- I bet there's a lot of ideas out there in the community for improvements to DateTime as well.

## Make `DateTime::TimeZone` use Zefram's binary Olson database reader

Instead of parsing the Olson data files ourself and generating Perl code, I want to use the binary
Olson data. The compiler that transforms the Olson database text files to binary data already just
works. Using the binary data would be a lot less memory-intensive, and probably faster too. Zefram
has already packaged all of the binary data as a CPAN distro, so we don't even have to rely on
potentially very out-of-date system-installed databases.

Really, all that's left to do is make DateTime::TimeZone use Zefram's code, and to make sure that
the DateTime::TimeZone API is fully supported once we switch.

Note to self: Make sure that the binary data works on 32- and 64-bit systems, where "works" means
that we can use the data to the limits of Perl's integer support. I'm pretty sure that Perl can
support larger-than-32-bit ints on 32-bit systems using an NV internally, so we should be able to
read in 64-bit integers from the binary file.

## DateTime for Perl 6

I've toyed with working on DateTime for Perl 6 but never gotten very far.

## Mason 2.0

Jon Swartz [started working on this][3] and I've wanted to hack on it too, but am lacking tuits. Jon
had a good [blog post on What Mason 2.0 would look like][4] a year ago. I suspect he's suffering
from the same tuit shortage I am.

I actually have some code in a `Mason2` directory dating back to 2007, where I started working on a
new version of the Mason parser.

## WYSIWYG Editor in Silki

I'd really like to add a full WYSIWYG editor to [Silki][5]. I started doing this with [CKEditor][6]
a while back, but I gave up. CKEditor is very full-featured, but almost impossible to customize
without making a permanent fork. I suspect it would be better to start with a fairly minimal editor
(like the YUI richtext editor) and build on top of it.

## Extract the HTML to Wiki converter from Silki

Silki contains some pretty useful code for turning HTML into wikitext. This could be genericized
into a replacement for [`HTML::WikiConverter`][7]. `HTML::WikiConverter` is a good idea, but its
internal design is wrong. It's very difficult to add a new syntax, especially if that syntax
supports tables.

## Generic blog/forum/wiki spam filter system

There are a lot of web services and tools for doing spam checking on user-submitted content. Step
one is to write small modules, one per service/tool/algorithm. Step two is to take all of these and
incorporate them into a single plugin-based API that ties them together with a weighting system,
like [SpamAssassin][8].

I'm actually quite likely to do this, since I _really_ want to make Silki better at spam
detection/prevention.

## Finish my donor/volunteer management CRM

My [animal rights group][9] could really use a nice full-featured, very easy to use CRM. Yes, I know
about CiviCRM, but last I looked it failed miserably on the easy to use front, and was missing some
key features we needed.

In my dreams, this system would somehow integrate with our bookkeeping, so that every donation in
the CRM linked to a bookkeeping entry, and vice versa.

I started working on this in early 2008, and I'm still not close to done.

## VegGuide Technical Revamp

Right now the [VegGuide][10] code is still using `Alzabo`, which is really making it hard to work on
certain parts of the code. I'd really like to move it over to [`Fey::ORM`][11]. I'd also love to
move from MySQL to Postgres while I'm at it.

## Rewrite perltidy using `PPI`

Perltidy is a really useful tool, but it's internals are a nightmare. It replicates PPI without an
actual API.

Once this was done, I could probably make it actually generate my preferred code style consistently.
I'd also like to see it capable of accepting formatting plugins, where certain blocks could be
formatted differently form the overall style.

### ... and then make `PPI` understand `Devel::Declare`-based syntax extensions

To really make perltidy and similar tools useful, they need to understand syntax-changing modules
like `MooseX::Declare`. I have no idea how one would do this, since the syntax changes are basically
injected into the perl parser itself, and `PPI` is a separate static parser.

## Enhance VCI to support commits and create Dist::Zilla::Plugin::VCI

It's ridiculous that each version control plugin for [`Dist::Zilla`][12] is totally standalone when
[`VCI`][13] exists. However, these plugins need to be able to commit and push, and VCI only supports
reading at the moment.

## Find a way to eliminate the compilation hit from `Moose`

There's the stalled (temporarily?) [`MooseX::Antlers`][14], and we've discussed other approaches
amongst the `Moose` core devs. I'd love to actually take one of these approaches and get it working.

## Introduction to Object-Oriented Programming (using Moose)

I think there's a need for a book that introduces OOP _concepts_, using Moose to illustrate the
ideas. This book would be aimed at people who are totally new to OOP and teach them concepts and
design principles. I think this could be great for attracting new users to Perl, because Moose is a
really amazing tool. If you learn OOP through Moose, imagine how sad it would be to go back to Java
afterwards.

## Moose Class Day Two

I've been encouraged by brian d foy to develop a second day for my Moose class. I have some vague
ideas of focusing on best practices and larger design issues as opposed to basic features. I also am
toying with the idea of having the class spend a few hours actually writing a small
not-entirely-a-toy application and running it against a test suite.

## YAPC 2012 in Minneapolis

I've started working with Leonard Miller on some preliminaries for the bid. I think we could do a
great job of hosting this here.

## Most Likely to Succeed

Of all of these projects, the ones I'm most likely to actually get done are ...

- Generic blog/forum/wiki spam filter system - I don't know that I'll get to something totally
  awesome and generic/pluggable, but enough to put some new modules on CPAN and improve Silki's spam
  filtering.
- Moose Class Day Two
- YAPC 2012 in Minneapolis - surprisingly, I feel like this is one of the most tractable items. It's
  a lot of work, but I _know_ exactly what goes into it. Also, this is the only project where I
  already have a competent, enthusiastic co-conspirator lined up.

The items I _most wish_ I would do are ...

- Finish my donor/volunteer management CRM - I have dreams of turning it into a SaaS business, but
  I'm finding it hard to motivate myself for some reason.
- CPAN Search $NEXT - I think this would be great for the Perl community.

I've also bounced around the idea of trying to get funding for some of this work via Kickstarter/TPF
grants/international ponzi schemes/Soylent Green but I'm not sure if that will ever happen.

I've also left out a lot of things not related to programming, including writing a novel, getting
back to learning Chinese, learning to play guitar, and running for city council.

[1]: http://github.com/bricas/cpanhq
[2]: http://cldr.unicode.org/
[3]: http://github.com/jonswar/perl-mason
[4]: http://www.openswartz.com/2009/09/01/what-mason-2-0-would-look-like/
[5]: http://silkiwiki.org
[6]: http://ckeditor.com
[7]: http://search.cpan.org/dist/HTML-WikiConverter
[8]: http://spamassassin.apache.org/
[9]: http://exploreveg.org
[10]: http://vegguide.org
[11]: http://search.cpan.org/dist/Fey-ORM
[12]: http://dzil.org
[13]: http://search.cpan.org/dist/VCI
[14]: http://git.shadowcat.co.uk/gitweb/gitweb.cgi?p=gitmo/MooseX-Antlers.git;a=summary

## Comments

**Moritz, on 2010-11-01 13:43, said:**  
Thanks for sharing your TODO list; I love reading such lists, because it makes me realize I'm not
the only with such lists :-)

I think the first one has a really good chance to attract a larger community.

As for the DateTime TODOs, I can only recommend to "steal" from Date::Simple for a date-only module,
and maybe add some methods to make it integrate nicer with DateTime.

**magnus, on 2010-11-01 14:13, said:**  
Just out of curiosity, which customizations were you looking at doing with CKEditor? I've personally
managed quite well with just configuration and using my own plugins, without editing the core.

**http://www.wgz.org/chromatic/, on 2010-11-01 15:06, said:**  
I really like the "Introduction to OOP with Moose" idea. Stevan and Chris and I have discussed such
a thing before.

**Dave Rolsky, on 2010-11-01 15:12, said:**  
@magnus: I wanted to do two things. First, I wanted to take away a lot of options. The idea was to
only expose things that the underlying wiki syntax supported. That meant removing things like the
option to manually set image dimensions, or changing the link target, etc.

Second, I wanted to add some dialogs for wiki links, links to files/images in the wiki, etc.

Both turned out to be a nightmare, since they involved editing existing plugins.

**hancock, on 2010-11-01 15:21, said:**  
++perltidy rewrite

**magnus, on 2010-11-01 16:24, said:**  
@Dave yea it's a shame such things aren't configurable. But I've stuck with CKEditor, as I couldn't
find a better one. The tweaks I've made has taken considerably less time than if I was starting from
scratch.

**Dave Rolsky, on 2010-11-01 16:41, said:**  
@magnus: I have no intention of starting totally from scratch, but I do think it might be easier to
start with a more barebones editor and add features, rather than taking CKEditor and trying to strip
a bunch of pieces away.

**magnus, on 2010-11-01 17:09, said:**  
@Dave that's cool, I'd be very happy to see a solid CKEditor competitor.

**j1n3l0.myopenid.com, on 2010-11-01 18:00, said:**  
I really like the first thing on your TODO list. It would be a massive project but it sounds like
the sort of thing a lot of perl developers would be interested in ... myself included ;)

A feature I would like to see as well would be **the ability to tag** modules (_a la_ flicker,
twitter, etc) by both the author and users to assist searching by functionality. That should help
users find modules like [Moose](http://search.cpan.org/~drolsky/Moose-1.18/) which, though great at
its job, cannot be found when you search for [CPAN](http://search.cpan.org/) for OOP :)

**Peter Rabbitson, on 2010-11-02 07:39, said:**  
 _... Modern Perl, probably Catalyst, Moose, and DBIC..._

Why not Fey::ORM? ;)

**Dave Rolsky, on 2010-11-02 10:21, said:**  
@Peter: Because a lot more people know DBIC, and for this particular project, I think it's key to
make it something that's easy for the community to hack on.

**Olaf Alders, on 2010-11-02 14:11, said:**  
The CPAN project is a very good idea. Toronto.pm is just starting to build an open API for CPAN
data. We actually just started work over this past weekend. I had put this example together using
Moose before I read your post:

<http://github.com/CPAN-API/cpan-api/wiki/JSON>

Our plan is to have something that is free, open and distributed. A web service which will not only
return metadata, but will eventually allow module tagging, up-voting, down-voting etc. Something
which can function as a back end for a CPAN web site, command line client, iPhone app, Android app
etc.

**Dave Rolsky, on 2010-11-03 15:58, said:**  
@j1n310: Yes, tagging would be great. I think a good overall goal for a search.cpan replacement
should be incorporating user input into the site in lots of ways. The current site is basically
read-only, in that new content only shows up because it was added somewhere else (PAUSE, CPAN
ratings, etc.)

**pshangov.myopenid.com, on 2010-11-04 04:28, said:**  
Dave, obviously there are a lot of people who are willing to contribute to a new-generation CPAN
frontend. So I think what a project like this needs in the first place is a good and well-known
leader, and developers will follow. What could be done to get this process started?

**Dave Rolsky, on 2010-11-04 10:23, said:**  
@pshangov: If you email me, I'll give you an address to which you can send the massive supply of
round tuits that will be needed.

**cpankme, on 2010-11-04 17:05, said:**  
the new cpan site should be named cpandex or cpankit :-)

**piotr pogorzelski, on 2010-11-09 13:56, said:**  
being hit lately by inconsistency with default time zone in DateTime->now [UTC] and
DateTime::Format::ISO8601-parse [floating] i'm dreaming of a root namespace in CPAN (DateTime,
Catalyst) having only one responsible person/team for whole module tree.

all other modules should be in private namespaces following cpan author nickname.

or stable.cpan.org, testing.cpan.org, unstable.cpan.org, when module placed in CPAN must have some
"Contract" which other modules must obey if they are to be placed in the same area
(stable,testing...) and extended system for testing if modules obey contracts.

or perl7.cpan.org with moosed versions of CPAN modules ;)

**Dave Rolsky, on 2010-11-09 14:03, said:**  
@piotr: That's \*way\* out of scope for what I was talking about. I'm not talking about
re-engineering PAUSE, just providing a new and improved interface for interacting with its data.

**piotr pogorzelski, on 2010-11-10 20:24, said:**  
it's not a big deal :) for a person to write a new  
web interface for PAUSE/CPAN (like everyone writes it's own ORM).

but as someone told me some time ago about programming.  
rubbish in - rubbish out, no matter how good the program is.

no offence, but how do you judge whether to use a cpan module?

i evolved this way:  
have no time - i take anything;

cpan is cpan, it must be good if it's from cpan,  
so i take anything if it's from cpan;

look what your favourite perl gurus use, and use  
the same modules, even if it costs you time and money

perl/cpan needs some "distributions", just like linux has.  
some people prefer solving problems using this set of  
toos/modules. some prefer other set.

i don't mind several cpans, if each has clear rules i can accept or deny and look for somethig else,
if each is consistent and verified. than i can choose the one i feel good with.

so cpan is good as a starting point. now some arbitrary decision should be made, which subset of
cpan modules should be user for solving problems in selected areas and polishing of those modules
should be done to improve consistency and increase code reuse and decrease number of dependiencies
of other modules.

if none perl distro suits me, i still have cpan.

imho

- pp
