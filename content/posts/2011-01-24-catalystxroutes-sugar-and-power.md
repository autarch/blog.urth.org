---
title: CatalystX::Routes, Sugar and Power
author: Dave Rolsky
type: post
date: 2011-01-24T16:14:06+00:00
url: /2011/01/24/catalystxroutes-sugar-and-power/
---

I've just released a new module, [CatalystX::Routes][1], which adds a layer of sugar for declaring
Catalyst actions (aka URI mapping, routes, etc).

Route declarations work together with the [Catalyst::Action::REST][2] distribution to make it
trivial to declare RESTful actions in your controllers.

I'm very excited about this module for several reasons. First, Catalyst's sub attribute-based action
declaration is hideous. I cringe every time I look at it. The syntax is also un-Perlishly picky. For
example, these two things are not the same:

```perl
sub foo : Chained ('/') : Args (0) { }
sub foo : Chained('/') : Args(0) { }
```

The difference? Well, the first one is a syntax error. Yes, that's right, attributes don't allow
spaces before their parameters.

So here's what some code looks like when converted from "plain old Catalyst controller" to
`CatalystX::Routes`:

```perl
sub _set_contact : Chained('/account/_set_account')
                 : PathPart('contact') : CaptureArgs(1) { ... }
```

becomes ...

```perl
chain_point _set_contact
    => chained '/account/_set_account'
    => path_part 'contact'
    => capture_args 1
    => sub { ... };
```

RESTful end points become even cleaner. Now we can get rid of the ugly combination of `foo`,
`foo_GET`, and `foo_POST` subs.

```perl
sub contact : Chained('_set_contact') : PathPart('')
            : Args(0) : ActionClass('+R2::Action::REST') { }
sub contact_GET : Private { ... }
```

becomes ...

```
get q{}
    => chained '_set_contact'
    => args 0
    => sub { ... };
```

We are able to entirely eliminate the do-nothing sub that was needed just to declare a RESTful URI.
When you declare a method for an HTTP action, `CatalystX::Routes` makes sure all the necessary bits
are declared behing the scene.

(That `get q{}` is used to declare a chain end point with the same URI as the mid point it chains
from.)

`CatalystX::Routes` also provides special sugar for providing HTML responses to browsers along with
`Catalyst::Action::REST::ForBrowsers`, so we can write:

```
get_html q{}
    => chained '_set_contact'
    => args 0
    => sub { ... };
```

Now when a browser makes a `GET` request for this URI, we will dispatch to the `get_html` action.

The real power of `CatalystX::Routes` goes well beyond making things prettier. Subroutine attributes
are parsed by Perl at compile time, and are an entirely separate piece of syntax from other Perl
code. In other words, you can't write this:

```perl
BEGIN {
    my $chain = '_set_contact';
    sub contact : Chained($chain) : Args(0) { ... }
}
```

Well, you _can_ write this, but what happens is that Perl simply parses the Chained attribute as
containing the string `'$chain'`. You cannot use variables in attributes.

With `CatalystX::Routes`, you declare actions using regular Perl code, which means you can use
variables, loops, and so on to make it easy to generate actions.

For example, in one of my controllers, I had several RESTful entities with a very similar set of
actions (view a collection, view an individual entity, `POST` a new entitiy, `PUT` an update, etc.)

```perl
for my $type ( qw( donation note ) ) {
    my $plural = PL_N($type);
    my $entity_chain_point = "_set_$type";
    chain_point $entity_chain_point
        => chained '_set_contact'
        => path_part $type
        => capture_args 1
        => sub {
            my $self = shift;
            my $c    = shift;
            my $id   = shift;
            my $entity = $class->new( $id_col => $id );
            $c->stash()->{$type} = $entity;
        };
    put q{}
        => chained $entity_chain_point
        => args 0
        => sub {
            my $self = shift;
            my $c    = shift;
            my $contact = $c->stash()->{contact};
            $self->_check_authz( ... );
            my $entity = $c->stash()->{$type};
            eval { $entity->update( ... ); };
            if ( my $e = $@ ) { ... }
            $c->redirect_and_detach( ... );
        };
}
```

That's a mouthful, but there are a few key takeaways. First, I was able to define the mid-point of
my chain in a variable named `$entity_chain_point`, and then use that variable to declare actions:

```perl
chain_point $entity_chain_point ...
    put q{}
        => chained $entity_chain_point ...
```

I was also able to do the same thing with the path part for the chain mid-point:

```perl
chain_point $entity_chain_point
    => chained '_set_contact'
    => path_part $type ...
```

And because the subroutines for each action are closures, I'm able to reuse the same subroutine
bodies for different entities.

Generating actions programmatically is an incredibly powerful tool for code reuse. I've just been
using `CatalystX::Routes` for a day or so, so I've really only scratched the surface, but I'm quite
excited about the possibilities.

Let me end with a caveat. This is new code, and I've only made one release. The API may change
without warning, at least for now. And for all I know, this will all turn out to have been a
horrible idea, and three months from now I'll be using subroutine attributes again.

But I doubt it.

[1]: http://frepan.org/~drolsky/CatalystX-Routes-0.01/lib/CatalystX/Routes.pm
[2]: http://search.cpan.org/dist/Catalyst-Action-REST
