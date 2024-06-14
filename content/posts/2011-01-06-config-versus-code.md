---
title: Config Versus Code
author: Dave Rolsky
type: post
date: 2011-01-06T14:19:26+00:00
url: /2011/01/06/config-versus-code/
---

I was looking at some $WORK code recently. It had a lot of "stuff" in configuration. This seemed
wrong to me, but I wasn't sure why it bugged me. Thinking about it more, I realized that I had
developed a set of unarticulated rules that guide my thinking about configuration.

These guidelines are applicable to more than configuration. A setting can be exposed to
non-developers through a configuration file, command line switches, environment variables, etc.
However, it seems like configuration files are the most common developer error.

Why does this matter? First, moving behavior into configuration increases the complexity of the
code. It's one more thing for someone working on the code to understand. It requires them to
understand your configuration format, and how the code translates that configuration into data and
acts on that data. A complex configuration file is essentially another piece of code.

Second, it is a potential support burden. Once you've exposed something via an external interface,
it becomes more difficult to take back. This parallels the notion that a module's API should be as
small and narrow as possible.

Finally, configuration can make it more difficult for a developer to get things running at all.

Here are my guidelines for when to expose a setting to the user:

**Ideally, code should be runnable from a source control checkout.**

Catalyst provides a good example. Its built-in server is perfect for development, and even builds in
useful debugging options. It's not appropriate for most production setups, but it works great for
development.

**If a configuration change requires an accompanying code change, it's not configuration.**

In the $WORK code I looked at, there is a version number defined in the configuration. This code
builds an XML file, and the version in the configuration defines the version of the associated XML
Schema for that XML file. However, if the schema were to change, the code generating the XML would
also have to change. Bumping the version in the configuration file without changing the code would
mean that the generated XML has the wrong version. The version should be defined as a constant in
the code.

Conversely, if this is data that the developer _cannot know_ the right value of when coding, then it
should be externally settable. An obvious example is the ip address a daemon should listen on. Note
that this doesn't _necessarily_ require a configuration file. In the daemon case, a command line
switch may be sufficient.

**If the configuration item is essentially a data structure only the developer understands, it's not
configuration.**

Again, back to the $WORK example. The config file defines a massive mapping from database columns to
XML attribute names. While in theory this could be configurable, in practice it is so complicated
that no one but a developer working on the code has any use for it. This might as well be a constant
data structure in the application code.

**Avoid configuration. If you're an expert, then avoid configuration, mostly.**

Ultimately, configuration is just another API that someone has to maintain. It adds complexity and
bulk to the code. Avoid it whenever you can.

## Comments

**Zbigniew Lukasiak, on 2011-01-07 03:12, said:**  
I like to think about this as a range of solutions. The main thing here is about removing part of
code that changes more frequently then the surrounding. This part of code can be a literal, or it
can be more complex like a regex or even a full object. The target place where you are moving it can
be completely external like a program parameter or environment variable - this is only suitable for
the most simple values, it can be a config file using a simplified syntax (like JASON, YAML, XML or
.INI)- this can be suitable for more complex stuff depending on the syntax used or it can be just an
additional file in the program written in the same language as the main program where the
configuration can be really complex - like setting up callbacks. In the extreme the config written
in the main programming language can be an Dependency Injection container that builds all the
objects used in the main scope of the application (there can be more such containers if the
application uses more scopes). But I've heard that some DI containers use XML even for this.

For big systems I think the optimal solution would be a simple config file using simplified syntax
that could be changed by the admins plus a DI container that would use this simplified config and
which would be only touched by developers.

**jcookster, on 2011-01-08 14:31, said:**  
Jason syntax? You mean JSON?

**Jonathan Rochkind, on 2011-01-09 09:41, said:**  
Working in ruby, I've come to think that the difference between 'configuration' and 'code' is really
nothing more than the difference between 'declerative' code and 'imperative' code.

Doing it declerative/configured IS a higher level of abstraction - and you have to be careful about
higher levels of abstraction when not actually needed, as they DO add complexity. But the solution
to over-complex code is not insisting that you should always program at the lowest level of
abstraction possible - that's just trading one kind of complexity for another.

That be said, even when a higher level of abstraction for declerative/configured code is
appropriate - you can still do it well or poorly. The downsides of configuration in that article are
really examples of how not to do configuration, not arguments against configuration. Some languages
and environments do make doing configuration right easier than others - I tend to agree with some
that XML sadly does not encourage good configuration language practices, despite being the
default/easiest way to do configuration in certain languages/environments.

The point of configuration is letting you concisely and decleratively express your intentions in a
higher level of abstraction - if you have configuration that requires just as much detail as the
code would, you don't really have configuration at all, you've got imperative code, just in a very
inconvenient language for writing imperative code, the worst of both worlds.

**Dave Rolsky, on 2011-01-09 09:57, said:**  
@Jonathan: I think all you've done is redefine configuration for your own purposes, and then say
"configuration is fine". Indeed, as you define it, configuration is just fine.

As a Moose user and developer, it should be obvious I have nothing against declarative code.
Declarative code is in many ways the holy grail of programming, since it frees you from worrying
about "how" and lets you focus on "what".

However, declarative code is not the same as configuration, at least as I've defined it. My blog
entry is about how to decide when to expose some piece of the program via an external interface.
Whether you do that through some very high-level declarative code masquerading as a config file, or
whether it's done through a big pile of XML, it still adds complexity which may not be needed.

**artsrc, on 2011-01-09 14:23, said:**  
There are two separate problems:

1. How do you specialize the behavior of a component?
2. What is the best way to express simple declarative information?

**choy.rim, on 2011-01-10 06:05, said:**  
although we're arguing about the evils of configuration, the real issue is usability. if i read the
author correctly, the underlying theme in his guidelines is a deeper law like, "it should be easy to
do the right thing."

configuration is part of the "user interface" to your code base. too much configuration obfuscates
in the same way that too many parameters does. like the Norman door, you'll end up increasing user
error by affording him/her many ways of doing stuff incorrectly.

it's not about how to vary or how to specialize. it's about whether specializing is even a valid use
case for your code.

i suspect that the author is against dependency injection (DI) frameworks since they tend to provide
"plenty of rope". personally, i prefer to use DI frameworks and putting things in configuration. i
want to ensure testability and DI tends to help reduce singletons and globals. but a lot of my peers
have valid complaints about it. at some point, the configuration has way too much "hard code" -
static structures, conventions and constraints that should be in code. and it makes it much harder
to figure out what is going on.
