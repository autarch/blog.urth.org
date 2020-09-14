---
title: Moose Grant _This_ Close to Done!
author: Dave Rolsky
type: post
date: 2009-04-01T14:07:00+00:00
url: /2009/04/01/moose-grant-this-close-to-done/
categories:
  - Uncategorized

---
I&#8217;m just inches away from declaring the grant done.

Last week, I released new versions of Class::MOP and Moose which feature (mostly) complete API docs. I say mostly because some things are _intentionally_ being left undocumented for now. These are methods with public names (no leading underscore) that I think should be made private, or in a few cases entire classes with really weird APIs that need some rethinking. I think the API docs are done enough to satisfy the grant requirements.

Some of this rethinking has already happened, and doing this doc work let to some refactoring and deprecations, with hopefully more to come.

In the area of Moose Cookbook recipes, I&#8217;m one recipe away from done-ness. New recipes cover custom meta-instance and meta-method classes. Back in mid-February I released recipes for using BUILD and BUILDARGS, and applying roles to an object instance.

I expect to have the last recipe finished sometime by mid-April.