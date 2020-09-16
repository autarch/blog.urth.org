---
title: Reviewing Perl Best Practices, Chapter 15, Objects
author: Dave Rolsky
type: post
date: 2011-03-23T10:40:45+00:00
url: /2011/03/23/reviewing-perl-best-practices-chapter-15-objects/
---
_Perl Best Practices_ (PBP) was released in 2004, about 7 years ago. Perl is a great language, but its culture of [TIMTOWTDI][1] can be a problem. These days, we often hear that "there's more than one way to do it, but sometimes consistency is not a bad thing either" (TIMTOWTDIBSCINABTE). PBP deserves a lot of credit for encouraging discussion about the downsides of TIMTOWTDI.

PBP has a _lot_ of recommendations. A lot of them are fairly trivial, like recommendations on code formatting. I'm a big fan of using a consistent style throughout a single code base, but I'm flexible about what that style should be. Some of his other recommendations are more meaningful, and deserve some review 7 years later.

I'll take a look at each recommendation in Chapter 15, Objects, and see how it's stood up in the era of Modern Perl. Maybe I'll tackle some other chapters in the future.

## "Make object orientation a choice, not a default" and "choose object orientation using appropriate criteria"

Damian presents a list of criteria on when to use OO. This is a great list. Read it, understand it, think about it.

## "Don't use pseudohashes"

Well, they're gone from the Perl core, so I agree!

## "Don't use restricted hashes"

I never ran across any code using this feature, even back in the early 2000s. Has anyone else? I agree with Damian, but this seems like a non-issue.

## "Always use fully encapsulated objects"

Right on.

## "Give every constructor a standard name"

As more and more people use object systems like Moose, Class::Accessor, and so on, this becomes less of an issue.

However, offering _alternate_ constructors can be useful. The DateTime module has a standard `new()` constructor, but it also has constructors named `from_epoch()` and `today()`.

## "Don't let a constructor clone objects"

Again, this seems to have become less of an issue as fewer people hand roll their own OO code. I agree with Damian. Cloning should be a separate, explicit operation.

## "Always provide a destructor for every inside-out class"

Damian really pushes inside-out objects in PBP. At one point, it seemed like inside-out objects were the next big thing in Perl, but I don't think they really took off, especially compared to Moose and Class::Accessor.

This recommendation is basically irrelevant today.

## "When creating methods, follow the general guidelines for subroutines"

Basically, Damian says "write methods like I told you to write subroutines in previous chapters." That advice in previous chapters is all pretty good, but I won't go through it here.

## "Provide separate read and write accessors"

Damian wants you to write `get_name()` and `set_name()`. I don't think this ever took off. My personal preference is `name()` and `set_name()`, though that's just as unpopular.

I think the real recommendation should be to use read-only attributes as much as possible. Mutability adds complexity to your code. Avoid it whenever possible.

In that context, I'd avoid the `get_name()` style. Very little Perl code I've seen uses that naming scheme. The naming of writers matters less if they're rare, but readers will be common, and you should just use the style that everyone else uses.

## "Don't use lvalue accessors"

Indeed. I think the lvalue feature was a waste of time. Really, is writing `$object->foo = 42` so much better than `$object->foo(42)`? I don't get it.

## "Don't use indirect object syntax"

Double indeed!

## "Provide an optimal interface, rather than a minimal one"

Basically, Damian says that your classes should provide methods that will be as useful as possible for callers. Don't write an API that makes people do lots of extra work.

For example, with Moose, instead of returning raw array and hash references from accessors, use the Native Traits feature to provide cleaner APIs.

This is a good recommendation, but it's very difficult to teach this to people. Most people write terrible APIs, period.

## "Overload only the isomorphic operators of algebraic classes"

Let me translate this. Damian is saying "don't get cute with operator overloading, just use it for math-like things".

I agree, and would go further. I've written about how [Perl 5's operator overloading is broken][2]. With that in mind, I suggest avoiding it entirely in most cases.

## "Always consider overloading the boolean, numeric, and string coercions of objects"

I disagree. Unfortunately, because of the broken nature of Perl 5 overloading, providing these coercions oftens ends up being useless.

## Conclusion

This chapter of PBP holds up pretty well 7 years later. He was out of sync with the community on accessor naming in 2004, and that hasn't changed. I disagree with him on overloading, but I don't know that there's any community agreement on that.

Other chapters talk more about inside-out objects, and I think he missed the mark in thinking those were the future of Perl OO. I'll cover that in more detail if I review one of those chapters.

His remaining recommendations remain pretty solid in 2011.

 [1]: http://en.wikipedia.org/wiki/There%27s_more_than_one_way_to_do_it
 [2]: /2010/10/16/whats-wrong-with-perl-5s-overloading/

## Comments

**Steven Haryanto, on 2011-03-23 20:48, said:**  
> "Don't use lvalue accessors"
> 
> Indeed. I think the lvalue feature was a waste of time. Really, is writing $object->foo = 42 so much better than $object->foo(42)? I don't get it.

Well, lvalue allows niceties like $object->foo++ or $object->foo //= 1 (which is arguably much better than $object->foo($object->foo+1) or $object->foo(1) if !defined($object->foo)). That's why other languages have properties.

**Dave Rolsky, on 2011-03-23 20:56, said:**  
@Steven: If you're using Moose you can get some of that from the Native Traits feature, so you end up with `$object->inc_foo()>` where Moose generates the inc_foo() method for you.

Similarly, Moose makes it very trivial to assign defaults to attributes.

Personally, I think lvalue accessors are solving the wrong problem. Our problem isn't that we don't have properties, it's that Perl core has no good accessor generation.

**Aristotle Pagaltzis, on 2011-03-24 05:44, said:**  
So you write `$foo++` to increment a variable, but `$obj->inc_foo` to increment a member variable. Why is this incongruity supposed to be preferable over uniformity? How many different operation methods do you generate anyway? How do you rely on one naming convention being followed consistently and comprehensively (instead of lots of people painting sheds or staying home), esp with all the useful legacy already on CPAN? And least significantly, but not insignificantly esp. in long-running processes (Moose’s preferred environment!), why should you have to accept the level of symbol table bloat all these just-in-case methods entail?

On beyond that: everyone always picks the simplest case. How about `$table->cell(7,6)++`? What sort of equivalent method might Moose autogenerate for me there? Or am I then supposed to live with `$table->set_cell(7,6,$table->cell(7,6)+1)`?

If nothing else, adding a mechanism to core that allows lvalue methods to validate the new value on mutation would do no harm to people who don’t want to use it, it would just round out the feature in its existing state. Personally I bet it’d get adopted in a hurry though.

**Frank, on 2011-03-24 12:24, said:**  
Aristotle,

In the example above, you should probably make the table cell an object in it's own right. So you would do:

```perl
my $cell = $table->cell(7,6);
$cell->set_value($cell->value()+1);
```

With this interface you can easily extend table cells to contain non-numeric values at a later point. Generally I agree that operator overloading is more trouble than it's worth, and methods calls are the most maintainable way to modify the internal state of another object.

**Aaron Crane, on 2011-03-24 12:50, said:**  
I agree with all of that, in principle.

In practice, though, Perl’s lvalue routines have a flaw which seems insurmountable at the moment. The great thing about using methods for getters and setters is that they let a future version of the class change the underlying implementation while leaving the published API untouched. In particular, you can easily add code which validates whatever the caller's trying to store, and throws an exception if it’s unacceptable.

But the current semantics of lvalue routines make that impossible: the code never gets to see what the caller is trying to store. Instead it must return merely an lvalue “location” into which Perl itself will store the caller's data.

Given that, I’ve always treated lvalue routines as more trouble than they’re worth. The idea is wonderful, but the implementation has consequences which strike me as worse, in the general case, than accepting an inconvenient setter-method API.

**doomvox.myopenid.com, on 2011-03-28 09:31, said:**  
"My personal preference is name() and set_name()"

+1. The most common case should get the simplest usage. (And like Damien, I don't like mutators much.)

**Jon Bjornstad, on 2011-04-25 14:36, said:**  
Has Damian (or Larry) ever expressed their opinion on  
the Moose revolution in Perl OO? They must have some  
interesting thoughts on this topic.

Or are they focusing their energies on Perl 6 instead?  
The Perl 6 object model borrowed and learned a lot from Ruby, Moose, etc, yes?

**Dave Rolsky, on 2011-04-25 14:39, said:**  
@Jon: It's more like Moose borrowed a lot from Perl 6. Stevan worked on the Perl 6 OO design before creating Moose, and Moose embodies a lot of that work.

The Perl 6 OO design in turn draws on many sources, most notably CLOS, but also Smalltalk and other languages.

**Eric Strom, on 2011-04-27 16:01, said:**  
The general problem with lvalue subroutines is that they do not provide a hook for verifying or post-processing the assigned value. However, by combining tied scalars with lvalue subroutines, it is possible to get around this. I have encapsulated this functionality into the module Lvalue up on CPAN. The module allows you to wrap any object with lvalue functionality, while still using the original object's getter and setter methods internally.

```perl
my $obj = NormalObject->new();

$obj->value(5);
print $obj->value(); # prints 5

use Lvalue;
Lvalue->wrap( $obj );
$obj->value = 10;
print $obj->value; # prints 10
$_ += 2 for $obj->value;
print $obj->value; # prints 12
```

<a href="http://search.cpan.org/perldoc?Lvalue" rel="nofollow ugc">http://search.cpan.org/perldoc?Lvalue</a>
</p>
