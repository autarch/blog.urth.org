---
title: How Should Log::Dispatch 3.0 Work?
author: Dave Rolsky
type: post
date: 2014-08-24T16:26:17+00:00
url: /2014/08/24/how-should-logdispatch-3-0-work/
---

I've been playing with the idea of making a new version of Log::Dispatch that breaks some things.

There are a few changes I'd like to make ...

First, I want to trim back the core distro to only include a few outputs. This would just be those
outputs which are truly cross-platform and don't require extra dependencies. Right now that would be
the Code, File, Handle, Null, and Screen outputs. I might also borg rjbs's
[Log::Dispatch::Array][1], since it's so darn useful for testing.

Here's my plan for the other outputs:

- Syslog - release it and maintain it myself
- File::Locked - release it once and look for another maintainer
- ApacheLog - up for grabs
- Email outputs - up for grabs, but maybe I'd do a single release of the Email::Sender based output
  and look for a new maintainer

FWIW, I no longer have my programs send email directly. I log to syslog and use a separate log
monitoring system to summarize errors and email me that summary.

I'd also like to change how newline appending is done so this has more sensible defaults. This means
defaulting to appending a newline for the File & Screen outputs, but not for others like Code or
Syslog.

As far as core API changes, while I think the core `->log()` and `->debug()/info()/etc()` methods
would stay the same, I might want to make changes to some of the other methods.

I also plan to move to Moo internally, just to clean things up.

So given all this, what's the best course of action? Should I just go ahead and release
Log::Dispatch 3.0, along with Log::Dispatch::Syslog 3.0, etc.? Or should I actually rename the
distro to Log::Dispatch3 or something like that so that the two can co-exist on CPAN? I'm leaning
towards the latter right now.

Finally, if anyone has any other suggestions for improvements to Log::Dispatch I'd love to hear
them.

[1]: https://metacpan.org/release/Log-Dispatch-Array

## Comments

**dams, on 2014-08-25 11:21, said:**  
FWIW, we asked ourselves the same question with Dancer. Granted, it's a completely different
project, but they share some similarities: Log::Dispatch has a core + core extensions, and then
extensions as seperate modules maintained by the author, then external extensions maintained by the
community. Dancer has the same things with Plugins, serializer, etc.

The conclusion is : you \*really\* want to go with Log::Dispatch3.

It'll allow existing extensions to either be migrated to support both versions, or exist in 2
incarnations, for each version of Log::Dispatch. And if they are not updated, they'll stay copatible
with old Log::Dispatch.

It also allows you to break more things, and do dev-releases and normal releases eventhough
extensions are not compatible with the new version, etc.

just my 2 cents
