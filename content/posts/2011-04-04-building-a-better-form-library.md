---
title: Building a Better Form Library
author: Dave Rolsky
type: post
date: 2011-04-04T15:46:38+00:00
url: /2011/04/04/building-a-better-form-library/
---

_(I'm still [looking for a new position][1]. Please [check out my resume][2] and [contact me][3] if
you're looking for a great Perl developer.)_

Perhaps I should title this entry "Building a Slightly Less Horrible Form Library." When I mentioned
form processing in the Moose IRC channel recently, [mst][4] said "form modules are ... satan". That
sounds about right.

I've looked at a number of form libraries over the years. Recently I started using
[HTML::FormHandler][5] (HFH) in an application I'm working on, but eventually I realized it just
didn't work for me.

I think there are a few fundamental problems with all the form libraries I've looked at. First,
they're not really sure what a form _is_. It's a set of user input widgets, it's a set of
validations and data types associated with names, it's a thing that can introspect your database,
it's a thing that can update your database. That's a lot of things to be!

This is actually two separate problems. First, the form library is trying to solve every
form-related problem possible, from rendering to validation to acting on the form input. But the
_real_ problem is that it tries to do this all in one class!

There's nothing wrong with trying to solve a lot of problems, but this is best done by building a
set of cooperating classes. I think the DateTime ecosystem, for all of its faults (faults I'm mostly
responsible for) really gets this right. The core [DateTime][6] library is all about representing
and manipulating a single date/time. If you want parsing, special formats, sets, incomplete
date/times, holidays, and more, then you can have it, but all of those features come from additional
packages.

This "ecosystem" approach forces us to create real APIs and think about how different libraries can
play nice together. It also helps us provided consistency across similar libraries. For example, all
of the DateTime parsing libraries have basically the same core API, as do event libraries, alternate
calendars, etc.

Building an ecosystem reduces the stuff you need to learn for any particular library. The DateTime
docs are already pretty huge, but imagine if they also had to cover parsing, alternate calendars,
holidays, and so on. It would be a true nightmare.

I think that nightmare is the state of form libraries today.

Enter my own form library, [Chloro][7]. This is actually my second attempt at writing Chloro. I
scrapped the first because it was becoming exactly the kind of does-everything-in-one Frankenstein's
monster that I'm complaining about!

This time around, I was able to focus on the pieces I really cared about. Specifically I want a tool
for taking user input, applying some validation, and getting the results in an easy to consume data
structure. "Getting the results" glosses over a pretty big task. The result needs to indicate
whether the submission was valid, and if it wasn't valid I need all the validation errors that were
found. If the result is valid, I want the data submitted by the user. Oh, and I want to do some
munging of that data along the way.

I **don't** care about rendering, mapping fields to a database, building forms _from_ a database, or
updating a database. (Actually, Chloro is designed so you can plug those sorts of things into it,
but it won't be part of the core.)

With Chloro, forms are defined as classes, and you won't be surprised to see that it looks like a
Moose class:

```perl
package MyApp::Form::Login;

use Moose;
use Chloro;

field username => (
    isa      => 'Str',
    required => 1,
);

field password => (
    isa      => 'Str',
    required => 1,
);

field remember => (
    isa     => 'Bool',
    default => 0,
);
```

You'll also notice that the field's type is defined as a Moose type. Remember, I don't care about
rendering, so I want to express field definitions in terms of the _back end_. The back end doesn't
care if the input came from a select, a text box, or a file upload. It just wants a string (or
positive integer, or an image file, or ...). Fields can also define custom extractors (a birth_date
field that builds itself from a year, month, and day input) and custom validators (end_date must be
greater than start_date). With Chloro, form objects are essentially immutable. When you process user
input, you get back a `Chloro::ResultSet` object. The form object itself is unaffected. Separating
the form from the results is just a cleaner design, and avoids the "form object as god object"
problem of many existing form libraries.

```perl
my $resultset = $form->process( params => $submitted_params );

if ( $resultset->is_valid() ) {
    # Log the user in
}
else {
    # Do something with errors
}
# Results can be associated with a field, and can also include overall form errors that span multiple fields (like "the two passwords must be the same").

# Errors that are not specific to just one field
my @form_errors = $resultset->form_errors();

# Errors keyed by specific field names
my %field_errors = $resultset->field_errors();
```

The `Chloro::ResultSet` object can give you back a simple hash reference of data, which you can use
to insert or update some data in your database.

```perl
my $login = $resultset->results_as_hash();
```

Chloro also supports the idea of "repeatable groups". For example, a contact might have multiple
phone numbers. Each phone number consists of a type (cell, home, work), a number, and an optional
note. We want to let the user submit 0-N phone numbers, each of which has the same fields. The
client side piece is up to you, and you can use some sort of Javascript to make this nice and
pretty. On the server side, I want to say "give me all the phone numbers that were submitted". I'm
also working on allowing custom ResultSet roles which can add more structure to the returned data,
beyond "give me a hash reference of all the submitted data". This will allow a form to say that its
resultset uses certain roles. These resultset roles can be defined on a per-app and per-form basis.
I've started converting an existing application over to Chloro, and I'm pretty happy with it. It's
definitely not Satan. Maybe Chloro is Satan's little sister Satana, but that's an improvement in my
eyes!

[1]: /2011/03/30/looking-for-a-new-position/
[2]: http://houseabsolute.com/resume.html
[3]: mailto:dave@houseabsolute.com
[4]: http://www.shadowcat.co.uk/blog/matt-s-trout/
[5]: http://search.cpan.org/dist/HTML-FormHandler
[6]: http://search.cpan.org/dist/DateTime
[7]: http://hg.urth.org/hg/Chloro

## Comments

**Robert 'phaylon' Sedlacek, on 2011-04-04 16:41, said:**  
I'm also trying to find a good way to solve this problem in ReUI
(<https://github.com/phaylon/ReUI>). The way I've gone is to have a UI widget tree (usually of the
fully page, but it could be the form alone). Validation happens as an event. The forms capture the
events and passes a result-collecting subevent on to it's children. Fields can populate results or
errors, and decide if and how the events should be passed on. The validation result is then used
when the tree is rendered to display errors. Form actions can happen via success callbacks or by
extending an action object (e.g. a Submit button) with a certain role (e.g. a (not-yet-implemented)
DBIC::Create).

**Sebastian Willert, on 2011-04-04 18:15, said:**  
I love this concept. It has everything I love about Data::FormValidator (or better: lacks everything
I hate about the competitors) and combines it with a nice helping of Modern Perl goodness. If Chloro
will also support or enable a concise way to programmatically create form classes (e.g. take base
form A and merge in these fields and rules), it might finally be the one form library to pry DFV
from my warm, living hands ;)

Thanks for your great work!

**Dave Rolsky, on 2011-04-04 18:57, said:**  
@Sebastian: Chloro already supports defining fields (and groups) in roles. You could create an
anonymous class that consumed a bunch of roles quite easily. I don't know that Chloro really needs
to provide any additional sugar.

**Dave Rolsky, on 2011-04-04 18:58, said:**  
@Sebastian: I should also clarify the field() sugar is just that, sugar. There's a metaclass API in
the background that you can use, just like how Moose works with has().

**Leo, on 2011-04-05 02:28, said:**  
You might be interested in <https://github.com/jjl/Spark-Form> - I've not used it yet - but sounded
interesting from a London.pm technical talk.

**Zbigniew Lukasiak, on 2011-04-05 02:34, said:**  
So I understand that Form is application scope - and Form::ResultSet is request scope. If someone
wants to write some custom processing of the parameters (like converting a few fields into a
DateTime) - would he put that additional code into a class in application scope or request scope?

**Dave Rolsky, on 2011-04-05 08:44, said:**  
@Zbigniew: Yes, the custom extraction code goes in the form class.

**Dave Rolsky, on 2011-04-05 08:45, said:**  
@Leo: I did look at Spark a little. It had pretty much all the same problems I've seen elsewhere.

**Zbigniew Lukasiak, on 2011-04-05 09:18, said:**  
In my opinion dealing with parameters is request scope work - that is it is convenient to write code
like
$self->day in all the calculations instead of passing $day as a method parameter everywhere.
That is the main difficulty in writing form handlers - if you have application scope, immutable
$form -
then you cannot have $form->day.

**Oliver Charles, on 2011-04-05 12:01, said:**  
I've only had a brief look, but it seems you're thoughts are inline with my thoughts that made me
write Data::TreeValidator -
<http://search.cpan.org/~cycles/Data-TreeValidator-0.03/lib/Data/TreeValidator.pm#WHY>?

**Phillip, on 2011-04-07 09:44, said:**  
When is it going to hit CPAN? :)

**alex.hartmaier, on 2011-04-10 12:46, said:**  
HFH can also split the result from the form, you have to use $form->run instead of process but as
this was added later than process the docs still point at process.  
And yes this is an endless source of bugs.  
Aside from that I really like HFH because even hard things where possible when I converted custom
form code that used DFV to it in one of my Catalyst apps.

Why is 'use Moose' in addition to 'use Chloro' needed?

**Zbigniew Lukasiak, on 2011-04-11 02:30, said:**  
@alex - yeah HFH did the split, just not at the right point. I know I was around at that time and I
did not suggest anything better - it took me a lot of time to think it over.

**Dave Rolsky, on 2011-04-11 09:06, said:**  
@Alex: You need to use Moose in addition to Chloro so that Chloro can be used in roles as well as
classes.

**mason, on 2012-05-24 09:19, said:**  
Did you take a look at Rose::HTML::Form? It gets a lot of stuff right. First of all, each field has
a 'type' which maps to Perl class which is a subclass of Rose::HTML::Form::Field. This sets up a
pattern wherein the chief work of form building is building up a library of reusable field classes,
which is definitely where you want to be in form development. RHTML Forms are nestable. It doesn't
suffer from the problem of doing too much. It doesn't render, except for providing a very
rudimentary serialization which is suitable for scaffolding. It doesn't touch the database. The form
object is capable of generating `<input />` tags just from field declarations. You teach it how to
initialize itself from your application object(s). It knows how to parse request parameters and
doesn't need any help. You teach it how to go from its parse back to an application object(s). It's
feature complete, but of course it is based on the obsolete Rose::Object system.
