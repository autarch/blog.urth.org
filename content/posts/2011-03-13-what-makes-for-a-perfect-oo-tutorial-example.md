---
title: What Makes for a Perfect OO Tutorial Example?
author: Dave Rolsky
type: post
date: 2011-03-13T14:32:44+00:00
url: /2011/03/13/what-makes-for-a-perfect-oo-tutorial-example/
---
Recently I've been working on revising the Perl 5 core OO documentation, starting with a new OO tutorial.

My first draft used Person and Employee as my example classes, where Employee is a subclass of Person. After I posted the first draft, several people objected to these particular classes. I realized that I agreed with their objections, but I wasn't able to come up with anything better.

I brought this up on the #moose IRC channel, and we had a really interesting discussion. Mostly it consisted of people coming up with various ideas and me shooting them down. The rejected suggestions included:

* Person/Employee
* Number/Integer
* Real/Complex (numbers)
* Window/ScrollableWindow
* Animal/Moose
* CD/Single
* Assessment/Survey (in the context of teaching assessments)
* Others I'm probably forgetting

Let's go through my criteria and talk about why each of these examples was rejected.

## No Abstract Base Classes

The base class must be meaningful on its own. It must be something you might instantiate. This ruled out Animal/Moose, we don't want instantiate a generic Animal. Our understanding of animals is always more specific. At the very least, we recognize them as Birds, Mammals, Fish, and so on, if not as specific species.

Instead, Animal is really more of a role. In fact, thinking back to high school biology, deciding whether something is an animal is based entirely on its behavior (its interface).

If the parent class is better as a role, the suggestion doesn't work.

The other suggestions all passed this test.

## Must Not Be Too Domain Specific

The example classes should not require domain knowledge to understand. The Real/Complex and Assessment/Survey suggestions are clearly too domain specific. The Window/ScrollableWindow suggestion may also fail this. Yes, everyone knows that some windows scroll and some don't, but very few people would know how that's implemented.

The example needs to be something that any programmer can be expected to understand.

## Must Lend Itself to Example Methods

I need an example that lends itself well to writing small example methods. The Window/ScrollableWindow suggestion fails this criterion. The actual implementation of a windowing toolkit is quite complex, and _extremely_ domain-specific.

## The Subclass's Specialization Must Be Intrinsic to Its Nature

This one is best explained through an example that doesn't pass the test, Person/Employee. Being a Person is intrinsic to the class. However, when a person is an Employee, that's not really intrinsic to the Employee, it's just something a Person does. A Person can also be a spouse, a parent, a child, etc.

In other words, these are all _roles_ that a Person plays. Clearly, this example is better implemented through roles.

## Must Not Be Useless

The classic shapes example used in so many books falls into this category. It's really hard for me to imagine a program where I need to model Ellipse and Circle classes. I suppose I might do this if I were writing MS Paint.

The shapes example is useful for illustrating some technical ideas, but it's too abstract for a good tutorial.

## Must Not Raise the Idea of Specialization By Constraint

[Specialization by constraint][1] is an object orientation concept defined by Chris Date and Hugh Darwen in their book [_The Third Manifesto_][2].

This is a complex idea perhaps best illustrated by an example:

```perl
my $number = Number->new(3.9);
$number->add(0.1);
```

Under the system proposed by Date and Darwen, the `$number` object would automatically become an Integer object when that is appropriate.

This is a fascinating idea, but something that's best left out of a basic OO tutorial.

As an aside, if you're interested in DBMS theory and design, you should really read _The Third Manifesto_, which I think has now been renamed as _Databases, Types and the Relational Model_ (their website is horrible and confusing).

## The Subclass Should Add Attributes and Behavior

The Number/Integer suggestion fails in this regard because the subclass _takes away_ an attribute.

## The Subclass Should Not Be Better As an Attribute

The CD/Single suggestion fails this criterion, since there's really no behavior or attribute difference between a CD and a Single. Instead, "single-ness" is better modeled as a simple attribute on a CD class.

## The Winner

So after a lot of discussion, Jesse Luehrs (doy) suggested File/File::MP3. This example satisfies (almost) every criteria.

The File/File::MP3 example works really well in a number of ways:

  * The base class is not abstract.
  * A generic File makes perfect sense.
  * We can expect every programmer to understand the nature of the classes.
  * It lends itself well to simple example methods.
  * The subclass's nature is intrinsic. Files have one specific type, or we don't know their type. Yes, I know it's possible to have a file that satisfies multiple format requirements, but that's a bizarre special case.
  * It is clearly not useless, and is in fact something you might find yourself writing in real world code.
  * The subclass adds behavior (track title attribute, `play()` method, etc.).
  * The subclass is clearly not better modeled as an attribute.

The only negative is that this example does bring up the idea of specialization by constraint. In a real world implementation, you might have a File factory that looked at the file's contents and returned an appropriate File subclass.

There's no perfect example, but this one is significantly better than Person/Employee, and it's what I'll be using in my work on the core docs.

Thanks, Jesse!

 [1]: http://c2.com/cgi/wiki?SpecializationByConstraint
 [2]: http://www.thethirdmanifesto.com/

## Comments

**Darren Duncan, on 2011-03-13 18:16, said:**  
Speaking as someone very familiar with The Third Manifesto and currently implementing it: I think that "Specialization by Constraint" works somewhat differently than you think it does.

Creating a subtype by SbC never takes away functionality, attributes, or methods; you still have all of the ones you started with and the subtype can also have extra that the parent type didn't. Integer would have every attribute that Number has, and Integer may have more (though any that Integer adds would be virtual and map to Number attributes); if you think otherwise, give an example.

This said, you nailed SbC on the head with one of its main features which is that you should be able to use the parent class constructor to declare objects of all of its subclasses also, and that the objects assume the subclass automatically as applicable.

This is like Moose's or Perl 6's "subtype Foo of Bar where ..." type declarations; this is an example of (simplified) SbC in modern Perl; you use the Bar constructor typically but applicable objects are automatically considered to be of class Foo. With SbC, every object of a subclass "is a" object of the parent class.

**Zbigniew Lukasiak, on 2011-03-14 11:02, said:**  
One more rule - the inheritance should be useful for showing examples with polimophism. I guess this could be somehow implied by your rules though :)
