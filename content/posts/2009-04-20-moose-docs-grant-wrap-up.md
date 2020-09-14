---
title: Moose Docs Grant Wrap-up
author: Dave Rolsky
type: post
date: 2009-04-20T11:18:04+00:00
url: /2009/04/20/moose-docs-grant-wrap-up/
categories:
  - Uncategorized

---
The Moose docs grant is finished, so I&#8217;m going to review what exactly was accomplished, and how it differed from the original grant proposal. I&#8217;ll take each section of the original proposal one at a time.

## Write a set of Moose::Intro docs

I ended up calling this documentation Moose::Manual instead, but what was produced is pretty similar to the original plan.

The original proposal called for the following sections:

  * Moose::Intro::Attributes
  * Moose::Intro::Subclassing
  * Moose::Intro::MethodModifiers
  * Moose::Intro::MooseObject
  * Moose::Intro::Roles
  * Moose::Intro::Types
  * Moose::Intro::Introspection
  * Moose::Intro::MooseX

The end result produced the following:

  * Moose::Manual::Concepts 
    This is just a reworking of the Moose::Intro documentation I had written prior to the grant. It focuses on concepts without including much code.

  * Moose::Manual::Classes 
    This includes the proposed Subclassing documentation, as well as providing a general intro to Moose.

  * Moose::Manual::Attributes 
    This is pretty much as I imagined.

  * Moose::Manual::Delegation 
    The Attributes documentation is already quite huge, so it made sense to separate a chunk out.

  * Moose::Manual::Construction 
    This is the proposed MooseObject page with a better name.

  * Moose::Manual::MethodModifiers 
    More or less identical to the proposal.

  * Moose::Manual::Roles 
    More or less identical to the proposal.

  * Moose::Manual::Types 
    More or less identical to the proposal.

  * Moose::Manual::MOP 
    This is the proposed Introspection page renamed.

  * Moose::Manual::MooseX 
    More or less identical to the proposal.

  * Moose::Manual::BestPractices 
    This is a collection of tips I came up with while writing the rest of the manual, and it also includes recommendations that were in Moose::Cookbook::Style, which existed prior to the grant.

  * Moose::Manual::Contributing and Moose::Manual::Delta 
    Stevan Little added these pages later.

## Revise all of the existing cookbook recipes for clarity and simplicity

Yep, did that.

## Write the recipes marked as TODO

The original proposal called for:

  * Moose::Cookbook::Basics::Recipe8 &#8211; Managing complex relations with trigger 
    I ended up putting a trigger example into Recipe 3 instead. Recipe 8 remains unwritten, and probably needs a new topic.

  * Moose::Cookbook::Basics::Recipe11 &#8211; BUILD and BUILDARGS 
    I wrote this.

  * Moose::Cookbook::Roles::Recipe3 &#8211; Runtime Role Composition 
    I wrote this too.

  * Moose::Cookbook::Meta::Recipe6 &#8211; Hooking into the immutabilization system 
    This recipe did not get written at all. The core team realized that the immutabilization system is too nasty to document as-is. For Meta Recipe 6, I showed a Meta Method class that enforces method privacy.

  * Moose::Cookbook::Meta::Recipe7 &#8211; Custom meta-instances 
    I wrote this.

I also ended up writing a new recipe, Basics Recipe 12, which shows how to subclass a non-Moose parent using Moose.

## Complete API docs for all Moose and Class::MOP classes

While working on this, I realized that some of the more internalish classes had really weird APIs that should not be documented. Therefore, a few classes are still entirely undocumented. In many cases, I was able to rename, deprecate, and refactor to a point where we had a reasonably sane public API to document.

So the upshot is that while not every class is fully documented, everything that _should_ be documented is documented, for now.

## What next?

Doing all this documentation work definitely highlighted some areas of the code that need changing. There are further refactorings to come, especially for the pieces that were deemed to gross to document at all. That includes immutabilization, some aspects of the type system, and some other areas.

I&#8217;d like to thank the Perl Foundation again for sponsoring this work. The grant was motivational for me, because this was a huge amount of work. I might have done some of it over time, but I doubt I would have done all or done it nearly as quickly without the grant.

I hope people out there in Perl-land find the new documentation useful. If you have feedback, you can find us on IRC at <irc://irc.perl.org/#moose>, [email the Moose list][1], or file a ticket in the appropriate RT.cpan.org queue.

 [1]: mailto:moose@perl.org

## Comments

### Comment by Shlomi Fish on 2009-04-20 14:01:08 -0500
Sounds like it was a successful grant both for you and for the TPF. All the power to you, and congratulations!

### Comment by hdp on 2009-04-20 20:20:07 -0500
The new manual is a huge improvement over the old; TPF&#8217;s money and your time were certainly well spent. Thank you.

### Comment by Dave Rolsky on 2009-04-20 20:30:20 -0500
What old manual?

### Comment by Bill Ruppert on 2009-04-22 23:38:04 -0500
The new documentation really helped me get started using Moose. Thanks!

### Comment by askbjoernhansen.com on 2009-04-26 23:53:01 -0500
I just want to join the chorus saying this is really great! Thank you for doing it.

&#8211; ask

### Comment by maletin.pip.verisignlabs.com on 2009-05-01 19:11:35 -0500
great work.  
i found a typo at <a href="http://search.cpan.org/~drolsky/Moose-0.76/lib/Moose/Cookbook/Basics/Recipe4.pod#DESCRIPTION" rel="nofollow ugc">http://search.cpan.org/~drolsky/Moose-0.76/lib/Moose/Cookbook/Basics/Recipe4.pod#DESCRIPTION</a>  
&#8220;showing how how constraints&#8221;

and later there are missing quotes:  
&#8220;container types), such as ArrayRef[\`a]