---
title: How I Use Catalyst
author: Dave Rolsky
type: post
date: 2009-08-02T09:50:50+00:00
url: /2009/08/02/how-i-use-catalyst/
---

Now that I've written about [My Way of the Webapp][1] and [what Catalyst really is][2], I'll explain
what I don't like about Catalyst.

I'm _not_ going to talk about things I know the Catalyst developers are aware of. In particular, the
use of subroutine attributes for dispatching is horrible, and they know it. I'm excited to see
[CatalystX::Declare][3], since something like that should be the future of Catalyst controllers.
Another well-known misfeature is the rampant use of subclassing for plugins and the lack of
well-defined APIs. [Yuval Kogman explained why this is so problematic][4] very nicely already.

Instead, I'm going to focus on what I consider "Catalyst Worst Practices", in particular misfeatures
of Catalyst (and/or plugins) that many people use.

## Configuration File (Mis)Handling

[Catalyst::Plugin::ConfigLoader][5] loads a config file and merges it into the application config
set via `MyApp->config(...)`. "Wonderful", you say, "I'm sick of dealing with config files". Me too!
Unfortunately, if you embrace this style of config handling you're setting yourself up for problems
later.

It is **absolutely crucial** that your configuration file be available **outside of a web
environment**. Yes, we're writing webapps, but any sufficiently complex web application _will_
expand to include a cron job or job queue or some sort of asynchronous task. Usually this will
involve sending email.

Unfortunately, ConfigLoader's config handling is very tightly integrated into its web components.
First, it gets things conceptually wrong by combining all sorts of config into one massive hash.
When you call `$c->config` you can find configuration items for ...

- Configuration info from your config file
- Configuration info set in a call to `MyApp->config(...)`
- Configuration info for the current controller and its parents

When you use ConfigLoader, your config file can contain both non-web things like database
connections, as well configuration specific to your app, and configuration for plugins you use.

All of this gets jumbled together into one simplistic API. This API just gives you back the config
info as a giant data structure, with no opportunity to add _logic_ to the mix. Worse it's only
available from inside an instantiated webapp via `$c->config`. This is wrong, wrong, wrong.

### How I Do It Instead

I always write my own app-specific config module. This module will use a CPAN module for the actualy
reading of files. I like to stick with a simple format, so [Config::INI][6] works nicely, but that's
a small detail.

The configuration file contains the _most minimal_ set of things it can in order to bootstrap the
application. Typically, this will include database connection info and not much else. Maybe it also
includes a hostname for the application, which may sometimes be necessary.

This module also includes _logic_ for determining various application configuration values. Note
that it does not allow (or require) the end user to configure these things. The fact that
PluginLoader lets you configure _everything_ from a configuration file is a nightmare. A
configuration file is something that non-developers see, and should have a well-defined, _small_ set
of options.

I then use this module to generate configuration data for various parts of my application. In my
webapp class, I use it to feed configuration data into Catalyst. That looks something like this:

```perl
package R2;

use R2::Config;

use Moose;

my $Config;

BEGIN {
    extends 'Catalyst';

    $Config = R2::Config->new();

    Catalyst->import( @{ $Config->catalyst_imports() } );
}

__PACKAGE__->config(
    name => 'R2',
    %{ $Config->catalyst_config() },
);
```

Most of the configuration passed to Catalyst is not user-settable. For example, I don't want people
installing an app to have control over how the Catalyst Session plugin is configured! This is part
of the application internals, and users have no business messing with it.

This `R2::Config` module just works both inside Catalyst and outside of it. When I need
application-wide config I simply need to write `R2::Config->new()->share_dir()` and it works. This
means I can take advantage of my configuration in any context, not just inside a web request. This
makes writing cron jobs and other non-web pieces trivially easy, although there is a bigger
investment up front in designing the configuration module's API.

BTW, the "R2" example comes from [a real app in progress][7].

## The Maleficent "Model"

Have you ever looked in a Catalyst class and seen something like
`$c->model('DBIC::Person')->find(...)`? What is it doing? Well, not much, but it's just enough to
make a mess.

A good example is the [MojoMojo][8] source, which I've been hacking on recently. If you look at the
source tree, you'll see that the model code lives under `MojoMojo::Schema::ResultSet::*` and
`MojoMojo::Schema::Result::*`. The `MojoMojo::Schema` class ties this all together. In any sane
world you'd be writing `$schema->resultset('Person')->find(...)`. But this is not a sane world.

You might argue that the Model bit is solving a problem, which is that we need to instantiate a
schema object before we can get at the database. That _is_ a problem that needs solving, but the
model API adds nothing to this.

What is wrong with something like this?

```perl
package MojoMojo;

has schema => (
    is      => 'ro',
    lazy    => 1,
    default => sub { MojoMojo::Schema->connect() },
);
```

Then later in our controllers we can write:

```perl
$c->schema()->resultset('Person')->find(...);
```

If we've done our work on configuration handling as I described above, then `MojoMojo::Schema` knows
just where to look for connection info. All that the model API adds is a useless layer of
redirection (aka confusion) and a useless 'DBIC::' prefix to our resultset names.

(Nosy readers might point out that the R2 code does have a Model class. That was an experiment which
must die.)

## `$c->uri_for`? Not for Me!

Here comes my ultimate heresy. I never use `$c->uri_for`. I _always_ write application-specific
logic for generating URIs. Once again, this comes back to being able to use my application outside
of a web environment. For example, I may want to generate email from a cron job that includes
application URIs. If I rely on `$c->uri_for` I would then need to duplicate its logic outside of
Catalyst.

My current approach is to simply make generating URIs a responsibility of each object in the system.
I don't love this, because it inflicts "web-ness" on my model, but I can rationalize this by
considering the URI a persistent unique identifier. In the age of REST that actually makes sense.

This also lets me do things like install the application under a path prefix like "/r2". If the
application supports adding an arbitrary prefix to all outgoing paths, this works nicely. I can
strip the prefix before any controllers see it, so it requires very little code to support, just
some configuration.

This approach is especially handy when an application is designed to be served from multiple
hostnames. If you're doing this, you need to account for this in the above-mentioned emails. With
R2, each Account (a group of Users) is associated with a Domain. A domain can have separate web and
email hostnames, and those hostnames are always used when generating URIs for anything associated
with the account.

If I used `$c->uri_for` I'd _still_ need a way to go from a web hostname to an email hostname.

## Summary

I encourage you to think twice before adopting every feature you see someone else use in a Catalyst
app. Catalyst is great, but not everything about it supports long-term maintainable applications.

Some of its features make getting started with small apps really easy, but they will bite you in the
ass as your app grows. With a little more work up front, you can build a cleaner app that won't
require major hacks or rewriting later.

[1]: /2009/07/27/my-way-of-the-webapp/
[2]: /2009/07/02/what-is-catalyst-really/
[3]: http://search.cpan.org/CatalystX-Declare
[4]: http://blog.woobling.org/2009/07/reducing-scope.html
[5]: http://search.cpan.org/dist/Catalyst-Plugin-ConfigLoader
[6]: http://search.cpan.org/dist/Config-INI
[7]: http://hg.urth.org/hg/R2
[8]: http://search.cpan.org/dist/MojoMojo

## Comments

**Zbigniew Lukasiak, on 2009-08-02 13:40, said:**  
I cannot agree more - on all of your points here. Catalyst has a huge cargo cult baggage.

**Zbigniew Lukasiak, on 2009-08-03 02:29, said:**  
After sleep some more comments. First - the view is another case nearly identical to the model -
empty class used only for holding some config params. Second is related to what you stated at IRC -
that this is your way of using Catalyst - and that it works with the current Cat so everything is
OK. That is not entirely so when you try some higher level modules - like the authentication
plugin - for example the DBIC one assumes you are using the DBIC model not just have a schema
accessor.

**Dave Rolsky, on 2009-08-03 02:32, said:**  
Well, yes, that's why it's called the _DBIC_ authentication plugin. The issue of the pluggability of
plugins really has little to do with Catalyst. In this case, the authentication plugin has its own
modular design. FWIW, I don't really like the main authentication plugin. It's extremely complex,
and I can't figure out why.

But you'll note that I was able to easily write my own authentication plugin (AuthenCookie) and it
does exactly what I need. How would Mojo have helped here?

**Zbigniew Lukasiak, on 2009-08-04 01:50, said:**  
Don't count me as a Mojo expert - I am still waiting for the promised docs to take a deeper jump.

What I want to do is to write higher level code - really I've seen enough login pages (and boxes)
and account registration pages. I know how to code them, I am bored by coding them again and again
and I would like to code them once and for ever (I mean for a while at least) - and go on to writing
the really interesting stuff. It is not hard in itself - it just needs a stable base. With Catalyst
we have it now more or less. The problem is that that base is far from being perfect (as you show
here) - and the problem with not perfect is that it means that sooner or later people will change
it, so it is not really stable.

**devin.austin, on 2009-08-06 18:39, said:**  
Thanks for the interesting and certainly impartial review of Catalyst.

I think this kind of thing helps keep in mind our need to be uncoupling components from our web
applications and have each entity remain in good standing with best practices.

We love our web apps, but they are multi-functional, multi-tiered, and each part has it's own bit it
needs to adhere to.

**Dan Dascalescu, on 2009-08-07 07:50, said:**  
The configuration file mishandling is what makes it so awkward to use something like
[DBICx::TestDatabase](http://search.cpan.org/perldoc?DBICx::TestDatabase) with a Catalyst app. You
have to use Catalyst::Test and get the context object via `ctx_request('/')`, then set the model
with `$c->model('DBIC')->schema(DBICx::TestDatabase->new('MyApp::Schema'))`.
[This](http://wiki.dandascalescu.com/howtos/catalyst/using_dbicx::testdatabase_with_catalyst), of
course, fires up the entire web server stack, which you really don't need if you just want to test
your model with a temporary test database.

**Wolfgang, on 2009-08-08 04:09, said:**  
I just started learning about catalyst a short time ago in a partially completed application. I
needed only a short time to stumble right into the traps you mentioned. Now I'm trying to find my
way out.

Good to know there are more people on that road.

Wolfgang

PS: Part of my problem is/was that the documentation of catalyst does not tell my mind what it needs
to know. But don't ask me whether this is a fault of my mind or of catalyst :-)

**Zbigniew Lukasiak, on 2009-11-27 12:33, said:**  
A propos recent developments - have you played with Plack? From the list in your previous post:
"controllers, a request/response abstraction, deployment agnosticism, and a great dev environment"
it has all the elements. It lacks the dispatcher part, which from your previous words in that essay
you also like - but nothings perfect :) It not a framework - so it is very light on forcing you to
do things in a particular way.
