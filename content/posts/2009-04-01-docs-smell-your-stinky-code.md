---
title: Docs Smell Your Stinky Code
author: Dave Rolsky
type: post
date: 2009-04-01T14:13:03+00:00
url: /2009/04/01/docs-smell-your-stinky-code/
categories:
  - Uncategorized

---
Working on the Moose and Class::MOP API documentation recently has once again reinforced the importance of writing documentation. Writing docs _hugely_ improves your APIs. Conversely, not writing docs makes it much easier to write really bad APIs.

I&#8217;m hoping that going forward, all new Moose and Class::MOP work will require API docs for all public APIs. This will help us catch bad designs before they&#8217;re released.

Here&#8217;s some code smells I think docs help catch &#8230;

## The Parameter of Many Names

For example, &#8220;package&#95;name&#8221; and &#8220;class&#95;name&#8221;. Which one takes precedence if both are passed? Or is that an error? Bite the bullet and deprecate a name right now. Add a big fat warning if the deprecated name is used.

## Parameter Co-dependency

This shows up as complicated inter-parameter dependencies or exclusions. Your API allows various mutually exclusive sets of parameters, or some parameters always exclude others. For example, you can pass A and B, _or_ B, C, and D, _or_, C, E, and F. But if you mix sets you get an error. The fix for this is usually to split the one method into several, one per valid set of parameters.

## Who the Hell Are You?

Inconsistent naming is painful. Moose and Class::MOP have some real problems with this, for example we use &#8220;class&#8221; and &#8220;metaclass&#8221; to refer to the same thing (a metaclass object).

## What the Hell Are You?

Inconsistent concepts are also really painful. Another problem for Moose and CMOP. This problem manifests when similar APIs take slightly different sets of parameters. For example, sometimes we take a class _name_, and sometimes we take a metaclass _object_, and sometimes we even take both! Considering that with CMOP, we can convert from a metaclass object to a name and vice versa, we need to just pick one thing we want and stick with it.

## State of Madness

This is a whole subcategory of smells. They manifest in documentation with phrases like &#8220;you need to call methods X and Y before calling Z&#8221; or &#8220;if you have already called X, then Y returns a foo, otherwise it returns a bar&#8221;.

When your docs have this sort of information, you are pushing way too much information about internal object state into the minds of your API users. Hide this stuff. This often can be done by making some methods private and simply calling them as needed when the (fewer) public methods are called.

If a method has multiple return values depending on internal state, you probably need multiple methods, each of which returns the appropriate piece of information.

If you have a lot of methods that will die absent some piece of state, then you may be best served by adding some required parameters to the constructor, and/or some good defaults. A good API has a constructor that returns a fully usable object. Bad APIs have a constructor that gives you an object that requires you to call five more methods before it&#8217;s useful.

Fortunately, this isn&#8217;t too much of a problem for Moose and CMOP. For the most part, internal state is not exposed in a way that leads to weird complications. The biggest exception was Class::MOP::Immutable, which I refactored before documenting for exactly this reason.

## Conclusion

Write docs before you release an API. If you find the docs hard to write, revisit your APIs until the docs flow naturally. If you don&#8217;t you&#8217;ll pay for it later, when you do write docs and realize you now need to go through some painful and annoying deprecation cycles.

## Comments

### Comment by David McLaughlin on 2009-04-24 08:00:03 -0500
Great post. 

I would go one step further than writing docs before releasing an API &#8211; write the docs before writing an API! You can design your API, document it for other developers and also create a bunch of code to blug into unit tests later on &#8211; all in one fell swoop. Documentation driven development. 

I really think that is why Test Driven Development became so popular &#8211; it&#8217;s less about testing and much more about the design flaws that get exposed as you start to write out what you imagine the API will look like.