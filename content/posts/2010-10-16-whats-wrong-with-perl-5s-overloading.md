---
title: What’s Wrong With Perl 5’s Overloading?
author: Dave Rolsky
type: post
date: 2010-10-16T12:17:31+00:00
url: /2010/10/16/whats-wrong-with-perl-5s-overloading/
---
If I were being accurate, this entry would actually be titled "What's Wrong With Perl 5's Overloading for People Who Care About Defensive Programming?" If you _don't_ care about defensive programming, then Perl 5's overloading is perfect, and you can stop reading now. Also, please let me know so I can avoid working on code with you, thanks.

Defensive programming, for the purposes of this entry, can be defined as "checking sub/method arguments for sanity". Yes, there's more to it, but that's where Perl 5's overloading fails so badly.

Let's say I'm writing an API that wants to take a filename as argument. What types of things might I expect? Well, obviously, I'd expect a string. More specifically, I'd expect a non-empty string, since `q{}` isn't a valid filename. I could go further and even require a valid filename for my file system, but a non-empty string is a good baseline.

Enter [`Path::Class`][1]. This is a very handy module that gives you objects to represent directory and file names. It also uses Perl 5's overloading to stringify when it's used as a string. Genius, that's exactly what I want.

So how exactly can I allow both strings and `Path::Class::File` objects as an argument? Well, I can start by checking if the argument has a string value. How do I do that, you ask? Well, you can't, and that's the problem! _Everything_ in Perl stringifies, so if I pass any object, or any reference, or even `undef`, they will all turn into a string when used in a string context, although with `undef` I might get a warning.

In an ideal world, string-ishness would be represented as a method on an object, like `as_string()`. Unfortunately, Perl's builtin types are not objects, so that's right out. The only way that I know of to check if something can act as a string _intentionally_ is the following hideous bit of code:

```perl
if (
    defined $val
    && ( !ref $val
        || ( blessed $val && overload::Method( $val, q{""} ) ) )
    ) {
    ...;
}
```

That's a disgusting mouthful of gibberish. The turd cherry on top of that shit sundae of code is that the only way to accomodate overloading is to explicitly check for it. This completely violates the purpose of overloading, making things transparently act like builtin types!

There are alternatives. For example, I could check for a `Path::Class::File` object and use Moose's coercion feature (along with [`MooseX::Params::Validate`][2] to coerce a bare string to an object. But if there's some other class of object that stringifies as a file name then we have to coerce that explicitly, or use a union type.

This broken-ness really only applies to certain builtin operations, like stringification, numification, comparison, etc. The underlying problem is that _all_ of Perl's builtin types "work" with these operations. Other types of overloading, like overloading array dereferencing, are just fine. I can just write `eval { @{ $val } }` and if it works I know I have something that acts like an array reference.

This is, I think, fixed in Perl 6. It has an explicit API for typecasting so if a class wants to support stringification, it implements a `Str()` method. From what I can see, builtins like Array and Hash _don't_ implement this typecasting (yay). Good job Perl 6 team!

For now, I guess I'm stuck with the nastiness up above, or just throwing up my hands and saying "stringify your arguments your own damn self".

 [1]: http://search.cpan.org/dist/Path-Class
 [2]: http://search.cpan.org/dist/MooseX-Params-Validate

## Comments

**Adam Kennedy, on 2010-10-17 00:56, said:**  
Params::Util::_SCALARLIKE

**Dave Rolsky, on 2010-10-17 08:34, said:**  
Yes, this would be very useful, but looking at the docs it doesn't seem to exist.

**phaylon, on 2010-10-17 10:45, said:**  
If overloaded objects and autobox'ed values would get something like ->DOES('Perl::Stringify') it could also make things easier. There's probably some disadvantage about that as well, besides the speed hit.

**Cd-MaN, on 2010-10-18 00:19, said:**  
I would like to preface my comment with that statement that I'm not an expert Perl user.

This said, couldn't the case described above (and most of the cases) be treated by "just doing it" (like in the Nike commercial :-)). Ie. you try to open the file (using of course the three parameter version :-)) and if it blows up, you propagate the error up (or do whatever you think is necessary) and if it works fine, everything is honky-dory.

While I see some value in checking the values of the input parameters, especially at the "public boundary" of an API, when such a check is dependent on an external entity (like the filesystem, the OS), it is inherently fraught with race-conditions. For example: you would like to start a server listening on port X. You check that port X is available by creating and then destroying a socket on it, but it is possible that just after you've destroyed the socket and other program comes along and binds itself to it, resulting in the failure of the server startup. So you need to handle the failure of the server startup process anyway, why introduce an other level of complexity with the pre-check?

The best kind of code is the one you don't have to write.

Best regards.

**Dave Rolsky, on 2010-10-18 08:20, said:**  
@Cd-MaN: What if the filename is the name of the file to write? In that case, pretty much anything will work on Unix (modulo file system permissions).

Also, even in the read case, it's better error out as soon as possible. What if the filename is a parameter for object construction, and the actual reading of the file takes place later? It's much better to give an error when building the object.

**David Yingling, on 2010-10-18 17:31, said:**  
The easiest fix is to simply turn that crazy code into a function that you'd call instead. Or maybe a CPAN module EXPORT_OKing such a function, or as a patch adding the function to an existing module like Scalar::Util.

From:

```perl
if ( defined $val
    && ( !ref $val || ( blessed $val && overload::Method( $val, q{""} ) ) ) )
{
    ...;
}
```

To something like:

```perl
if ( is_stringish( $val ) )
{
    ...;
}

sub is_stringish {
    my $val = shift;

    if ( defined $val
        && ( !ref $val || ( blessed $val && overload::Method( $val, q{""} ) ) ) )
    {
        return 'Is Stringish';
    }
    else 
    {
        return;
    }
}
```

If you'd do this, then after using such a function, you won't have to worry or care about the crazy code you have to write to make this happen.

**Dave, on 2011-01-28 13:40, said:**  
defensive programming is about protecting your resources; not defending against general bad programming. if the developer using your API passes a HASH that doesn't stringify to a filename he needs to debug his program. you just have to see that passing in a nasty object won't give the developer access to something that can damage the system. first: decide what you will do if the filename is bad and put it in the documentation. second: use an operation to trigger stringification early on so that you aren't carrying around stray objects:

```perl
my $filename = shift . ";
```

thats a good idea in many cases because it doesn't hold the object for the life of your new object. it also prevents the user from being able to change the filename, the filename becoming invalid later on or memory being tied down where it is not needed.
