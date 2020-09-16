---
title: Is Anyone Using Silki?
author: Dave Rolsky
type: post
date: 2010-07-03T12:20:36+00:00
url: /2010/07/03/is-anyone-using-silki/
---
I realized that the migrations I wrote were very buggy. Now I've written a test system to help me test future migrations, but the existing releases are problematic.

I can create a set of schema changes to fixup a schema which has been migrated, but the changes will have to be applied manually.

Note that if you're comfortable wiping your existing schema because you're just playing with Silki then this is a non-issue.

Please [email me][1] if you are using Silki.

 [1]: mailto:autarch@urth.org