---
title: Reviewing Perl Best Practices, Chapter 15, Objects
author: Dave Rolsky
type: post
date: 2011-03-23T10:40:45+00:00
url: /2011/03/23/reviewing-perl-best-practices-chapter-15-objects/
categories:
  - Uncategorized

---
_Perl Best Practices_ (PBP) was released in 2004, about 7 years ago. Perl is a great language, but its culture of [TIMTOWTDI][1] can be a problem. These days, we often hear that &#8220;there&#8217;s more than one way to do it, but sometimes consistency is not a bad thing either&#8221; (TIMTOWTDIBSCINABTE). PBP deserves a lot of credit for encouraging discussion about the downsides of TIMTOWTDI.

PBP has a _lot_ of recommendations. A lot of them are fairly trivial, like recommendations on code formatting. I&#8217;m a big fan of using a consistent style throughout a single code base, but I&#8217;m flexible about what that style should be. Some of his other recommendations are more meaningful, and deserve some review 7 years later.

I&#8217;ll take a look at each recommendation in Chapter 15, Objects, and see how it&#8217;s stood up in the era of Modern Perl. Maybe I&#8217;ll tackle some other chapters in the future.

## &#8220;Make object orientation a choice, not a default&#8221; and &#8220;choose object orientation using appropriate criteria&#8221;

Damian presents a list of criteria on when to use OO. This is a great list. Read it, understand it, think about it.

## &#8220;Don&#8217;t use pseudohashes&#8221;

Well, they&#8217;re gone from the Perl core, so I agree!

## &#8220;Don&#8217;t use restricted hashes&#8221;

I never ran across any code using this feature, even back in the early 2000s. Has anyone else? I agree with Damian, but this seems like a non-issue.

## &#8220;Always use fully encapsulated objects&#8221;

Right on.

## &#8220;Give every constructor a standard name&#8221;

As more and more people use object systems like Moose, Class::Accessor, and so on, this becomes less of an issue.

However, offering _alternate_ constructors can be useful. The DateTime module has a standard `new()` constructor, but it also has constructors named `from_epoch()` and `today()`.

## &#8220;Don&#8217;t let a constructor clone objects&#8221;

Again, this seems to have become less of an issue as fewer people hand roll their own OO code. I agree with Damian. Cloning should be a separate, explicit operation.

## &#8220;Always provide a destructor for every inside-out class&#8221;

Damian really pushes inside-out objects in PBP. At one point, it seemed like inside-out objects were the next big thing in Perl, but I don&#8217;t think they really took off, especially compared to Moose and Class::Accessor.

This recommendation is basically irrelevant today.

## &#8220;When creating methods, follow the general guidelines for subroutines&#8221;

Basically, Damian says &#8220;write methods like I told you to write subroutines in previous chapters.&#8221; That advice in previous chapters is all pretty good, but I won&#8217;t go through it here.

## &#8220;Provide separate read and write accessors&#8221;

Damian wants you to write `get_name()` and `set_name()`. I don&#8217;t think this ever took off. My personal preference is `name()` and `set_name()`, though that&#8217;s just as unpopular.

I think the real recommendation should be to use read-only attributes as much as possible. Mutability adds complexity to your code. Avoid it whenever possible.

In that context, I&#8217;d avoid the `get_name()` style. Very little Perl code I&#8217;ve seen uses that naming scheme. The naming of writers matters less if they&#8217;re rare, but readers will be common, and you should just use the style that everyone else uses.

## &#8220;Don&#8217;t use lvalue accessors&#8221;

Indeed. I think the lvalue feature was a waste of time. Really, is writing `$object->foo = 42` so much better than `$object->foo(42)`? I don&#8217;t get it.

## &#8220;Don&#8217;t use indirect object syntax&#8221;

Double indeed!

## &#8220;Provide an optimal interface, rather than a minimal one&#8221;

Basically, Damian says that your classes should provide methods that will be as useful as possible for callers. Don&#8217;t write an API that makes people do lots of extra work.

For example, with Moose, instead of returning raw array and hash references from accessors, use the Native Traits feature to provide cleaner APIs.

This is a good recommendation, but it&#8217;s very difficult to teach this to people. Most people write terrible APIs, period.

## &#8220;Overload only the isomorphic operators of algebraic classes&#8221;

Let me translate this. Damian is saying &#8220;don&#8217;t get cute with operator overloading, just use it for math-like things&#8221;.

I agree, and would go further. I&#8217;ve written about how [Perl 5&#8217;s operator overloading is broken][2]. With that in mind, I suggest avoiding it entirely in most cases.

## &#8220;Always consider overloading the boolean, numeric, and string coercions of objects&#8221;

I disagree. Unfortunately, because of the broken nature of Perl 5 overloading, providing these coercions oftens ends up being useless.

## Conclusion

This chapter of PBP holds up pretty well 7 years later. He was out of sync with the community on accessor naming in 2004, and that hasn&#8217;t changed. I disagree with him on overloading, but I don&#8217;t know that there&#8217;s any community agreement on that.

Other chapters talk more about inside-out objects, and I think he missed the mark in thinking those were the future of Perl OO. I&#8217;ll cover that in more detail if I review one of those chapters.

His remaining recommendations remain pretty solid in 2011.

 [1]: http://en.wikipedia.org/wiki/There%27s_more_than_one_way_to_do_it
 [2]: /2010/10/16/whats-wrong-with-perl-5s-overloading/

## Comments

### Comment by Steven Haryanto on 2011-03-23 20:48:42 -0500
> &#8220;Don&#8217;t use lvalue accessors&#8221;
> 
> Indeed. I think the lvalue feature was a waste of time. Really, is writing $object->foo = 42 so much better than $object->foo(42)? I don&#8217;t get it.

Well, lvalue allows niceties like $object->foo++ or $object->foo //= 1 (which is arguably much better than $object->foo($object->foo+1) or $object->foo(1) if !defined($object->foo)). That&#8217;s why other languages have properties.

### Comment by Dave Rolsky on 2011-03-23 20:56:38 -0500
@Steven: If you&#8217;re using Moose you can get some of that from the Native Traits feature, so you end up with `$object->inc_foo()>` where Moose generates the inc_foo() method for you.

Similarly, Moose makes it very trivial to assign defaults to attributes.

Personally, I think lvalue accessors are solving the wrong problem. Our problem isn&#8217;t that we don&#8217;t have properties, it&#8217;s that Perl core has no good accessor generation.

### Comment by Aristotle Pagaltzis on 2011-03-24 05:44:00 -0500
So you write `$foo++` to increment a variable, but `$obj->inc_foo` to increment a member variable. Why is this incongruity supposed to be preferable over uniformity? How many different operation methods do you generate anyway? How do you rely on one naming convention being followed consistently and comprehensively (instead of lots of people painting sheds or staying home), esp with all the useful legacy already on CPAN? And least significantly, but not insignificantly esp. in long-running processes (Moose’s preferred environment!), why should you have to accept the level of symbol table bloat all these just-in-case methods entail?

On beyond that: everyone always picks the simplest case. How about `$table->cell(7,6)++`? What sort of equivalent method might Moose autogenerate for me there? Or am I then supposed to live with `$table->set_cell(7,6,$table->cell(7,6)+1)`?

If nothing else, adding a mechanism to core that allows lvalue methods to validate the new value on mutation would do no harm to people who don’t want to use it, it would just round out the feature in its existing state. Personally I bet it’d get adopted in a hurry though.

### Comment by Frank on 2011-03-24 12:24:27 -0500
Aristotle,

In the example above, you should probably make the table cell an object in it&#8217;s own right. So you would do:

```perl
my $cell = $table->cell(7,6);
$cell->set_value($cell->value()+1);
```

With this interface you can easily extend table cells to contain non-numeric values at a later point. Generally I agree that operator overloading is more trouble than it&#8217;s worth, and methods calls are the most maintainable way to modify the internal state of another object.

### Comment by Aaron Crane on 2011-03-24 12:50:12 -0500
I agree with all of that, in principle.

In practice, though, Perl’s lvalue routines have a flaw which seems insurmountable at the moment. The great thing about using methods for getters and setters is that they let a future version of the class change the underlying implementation while leaving the published API untouched. In particular, you can easily add code which validates whatever the caller&#8217;s trying to store, and throws an exception if it’s unacceptable.

But the current semantics of lvalue routines make that impossible: the code never gets to see what the caller is trying to store. Instead it must return merely an lvalue “location” into which Perl itself will store the caller&#8217;s data.

Given that, I’ve always treated lvalue routines as more trouble than they’re worth. The idea is wonderful, but the implementation has consequences which strike me as worse, in the general case, than accepting an inconvenient setter-method API.

### Comment by doomvox.myopenid.com on 2011-03-28 09:31:53 -0500
&#8220;My personal preference is name() and set_name()&#8221;

+1. The most common case should get the simplest usage. (And like Damien, I don&#8217;t like mutators much.)

### Comment by Jon Bjornstad on 2011-04-25 14:36:10 -0500
Has Damian (or Larry) ever expressed their opinion on  
the Moose revolution in Perl OO? They must have some  
interesting thoughts on this topic.

Or are they focusing their energies on Perl 6 instead?  
The Perl 6 object model borrowed and learned a lot from Ruby, Moose, etc, yes?

### Comment by Dave Rolsky on 2011-04-25 14:39:34 -0500
@Jon: It&#8217;s more like Moose borrowed a lot from Perl 6. Stevan worked on the Perl 6 OO design before creating Moose, and Moose embodies a lot of that work.

The Perl 6 OO design in turn draws on many sources, most notably CLOS, but also Smalltalk and other languages.

### Comment by Eric Strom on 2011-04-27 16:01:57 -0500
The general problem with lvalue subroutines is that they do not provide a hook for verifying or post-processing the assigned value. However, by combining tied scalars with lvalue subroutines, it is possible to get around this. I have encapsulated this functionality into the module Lvalue up on CPAN. The module allows you to wrap any object with lvalue functionality, while still using the original object&#8217;s getter and setter methods internally.

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
