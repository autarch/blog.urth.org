---
title: New Type Constraint Module for Perl
author: Dave Rolsky
type: post
date: 2012-05-14T22:21:27+00:00
url: /2012/05/14/new-type-constraint-module-for-perl/
---
I recently uploaded a new distro to CPAN recently called [Type][1]. The concepts are largely on Moose's built-in type system, but it's a standalone distribution.

Right now this is all very alpha, and the current release is not intended for use by anyone. I've released so people can take a look at critique the design. I've tried to remedy some of the problems that Moose's type system has. MooseX::Types fixes some of these problems but then introduces its own. Type addresses the problems of both.

My long-term goal is to replace Moose's built-in system with Type. This will probably mean rewriting Type to _not_ use Moose itself. The current release uses Moose because it made it easy to prototype the system.

Here's the comparison with Moose and MooseX::Types from the Type distro's docs:

## Type names are strings, but they're not global

Unlike Moose and MooseX::Types, type names are always local to the current package. There is no possibility of name collision between different modules, so you can safely use short types names for code.

Unlike MooseX::Types, types are strings, so there is no possibility of colliding with existing class or subroutine names.

## No type auto-creation

Types are always retrieved using the `t()` subroutine. If you pass an unknown name to this subroutine it dies. This is different from Moose and MooseX::Types, which assume that unknown names are class names.

## Exceptions are objects

The `$type->validate_or_die()` method throws a `Type::Exception` object on failure, not a string.

## Anon types are explicit

With Moose and MooseX::Types, you use the same subroutine, `subtype()`, to declare both named and anonymous types. With Type, you use `declare()` for named types and `anon()` for anonymous types.

## Class and object types are separate

Moose and MooseX::Types have `class_type` and `duck_type`. The former type requires an object, while the latter accepts a class name or object.

In Type, the distinction between accepting an object versus object or class is explicit. There are four declaration helpers, `object_can_type`, `object_isa_type`, `any_can_type`, and `any_isa_type`.

## Overloading support is baked in

Perl's overloading is broken as hell, but ignoring it makes Moose's type system frustrating.

## Types can either have a constraint or inline generator, not both

Moose and MooseX::Types types can be defined with a subroutine reference as the constraint, an inline generator subroutine, or both. This is purely for backwards compatibility, and it makes the internals more complicated than they need to be.

With Type, a constraint can have _either_ a subroutine reference or an inline generator, not both.

## Coercions can be inlined

I simply never got around to implementing this in Moose.

## No crazy coercion features

Moose has some bizarre (and mostly) undocumented features relating to coercions and parameterizable types. This is a misfeature.

## Your feedback is requested

The current distro has mostly complete docs, so it should give you a sense of what I'm aiming at.

I'd love to hear from the Perl community on this distribution. Do this seem like it'd help fix problems you've had with Moose types? Can you imagine using this distribution without using Moose? What's on your wishlist?

 [1]: https://metacpan.org/release/DROLSKY/Type-0.02-TRIAL

## Comments

**jnareb, on 2012-05-15 14:53, said:**  
> _With Type, a constraint can have I_

Can have **what**?

**xenoterracide, on 2012-05-15 15:55, said:**  
Are Types, and Type Coercions global? The biggest problem I noticed with types being global is that someone would inevitably coerce Str from undef (not realizing it's global). (note: also wonder if Undef->Unset by default is not the right behavior as it's the easiest to cope with if receiving user input). Also +1000 exception objects

**xenoterracide, on 2012-05-15 16:08, said:**  
Also, there's was the problem of only throwing 1 attribute exception at a time, ultimately it would be better if the exception could tell us all the attributes that had failed.

**xenoterracide, on 2012-05-15 16:15, said:**  
I think perhaps for the last comment, the problem is that the types throw exceptions, rather than having Moose run the 'validation' collect the failed attributes and throw a single exception. Maybe types shouldn't throw exceptions at all but instead just boolean pass, fail, and let the system using them (moose) throw the exception.

**Dave Rolsky, on 2012-05-15 16:30, said:**  
@xenoterracide: Types are not global at all. Every time a package imports a type, it gets a clone of the type. Coercions are attached to the individual clone.

As to throwing one exception at a time, that has nothing to do with the type constraint system itself, it's something Moose does. You want MooseX::Constructor::AllErrors.

**Mark Lawrence, on 2012-05-15 16:49, said:**  
This seems way too complicated or over-engineered. That long list of modules implies a large learning curve, and that list of dependencies means I won't use it with short scripts or anything that involves the command line.

Perhaps it makes sense in the context of Moose, and if so then take my comments with a grain of salt, but in any case please don't take the "Type" namespace; leave it for something a little simpler and faster.

**Dave Rolsky, on 2012-05-15 20:08, said:**  
This sort of thing really isn't designed for short scripts. I generally want type checking when I'm doing some sort of app that has a lot of moving parts, especially when I have to deal with user input, or work with a team of programmers. In that case, defensive programming is a good idea.

As far the deps, the docs say that this is a prototype. It's possible that in the future I'll have to rewrite it to not use Moose. It's not a particularly long dep list, especially once you ignore core modules. Metacpan lists everything the module lists, and since I use an auto-prereq listing Dist::Zilla plugin, it ends up listing things like B and Carp.

Regarding the namespace, I don't feel particularly compelled to change it so some other distro can have it, but I'm open to arguments that \*no one\* should use it.

**Mark Lawrence, on 2012-05-15 22:12, said:**  
The problem with using such a generic, top-level name is the confusion in the event that someone else wants to write a Type::Tiny (or Type::MyWhatever) - either totally unrelated distribution's module names will be name-mixed with yours, or people will be forced crank out other random top-level names (TinyTypes). I think not having anyone use "Type(s)" but everyone using "Types::[whatever]" is ... probably the least worst thing I could suggest.

**xenoterracide, on 2012-05-16 05:27, said:**  
Re: namespace, I think I'd personally like to see only core perl modules use the top level. e.g. if there's ever a Type(s), it should be in core perl, or be aimed at core perl. (really wishing an Exception module didn't exist) The other question should be is how useful will this be outside of Moose? if it won't be then why should it not be in the Moose(X) namespace, even under development.

**Ovid, on 2012-05-24 08:35, said:**  
Is it possible to convert a type failure from an exception to a warning? Particularly when you're working with others or working on refactoring lots of code, sometimes you want a warning rather than an exception. (Think -t version -T for taint checking)

**Dave Rolsky, on 2012-05-24 09:33, said:**  
@ovid: This is controlled by whatever code calls the type constraint's checks. There is a "->value\_is\_valid" method that returns true or false, so you can call that and warn on failure.