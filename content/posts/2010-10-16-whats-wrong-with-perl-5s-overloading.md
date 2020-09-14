---
title: What’s Wrong With Perl 5’s Overloading?
author: Dave Rolsky
type: post
date: 2010-10-16T12:17:31+00:00
url: /2010/10/16/whats-wrong-with-perl-5s-overloading/
categories:
  - Uncategorized

---
If I were being accurate, this entry would actually be titled &#8220;What&#8217;s Wrong With Perl 5&#8217;s Overloading for People Who Care About Defensive Programming?&#8221; If you _don&#8217;t_ care about defensive programming, then Perl 5&#8217;s overloading is perfect, and you can stop reading now. Also, please let me know so I can avoid working on code with you, thanks.

Defensive programming, for the purposes of this entry, can be defined as &#8220;checking sub/method arguments for sanity&#8221;. Yes, there&#8217;s more to it, but that&#8217;s where Perl 5&#8217;s overloading fails so badly.

Let&#8217;s say I&#8217;m writing an API that wants to take a filename as argument. What types of things might I expect? Well, obviously, I&#8217;d expect a string. More specifically, I&#8217;d expect a non-empty string, since `q{}` isn&#8217;t a valid filename. I could go further and even require a valid filename for my file system, but a non-empty string is a good baseline.

Enter [`Path::Class`][1]. This is a very handy module that gives you objects to represent directory and file names. It also uses Perl 5&#8217;s overloading to stringify when it&#8217;s used as a string. Genius, that&#8217;s exactly what I want.

So how exactly can I allow both strings and `Path::Class::File` objects as an argument? Well, I can start by checking if the argument has a string value. How do I do that, you ask? Well, you can&#8217;t, and that&#8217;s the problem! _Everything_ in Perl stringifies, so if I pass any object, or any reference, or even `undef`, they will all turn into a string when used in a string context, although with `undef` I might get a warning.

In an ideal world, string-ishness would be represented as a method on an object, like `as_string()`. Unfortunately, Perl&#8217;s builtin types are not objects, so that&#8217;s right out. The only way that I know of to check if something can act as a string _intentionally_ is the following hideous bit of code:

    if (
        defined $val
        && ( !ref $val
            || ( blessed $val && overload::Method( $val, q{""} ) ) )
        ) {
        ...;
    }
    

That&#8217;s a disgusting mouthful of gibberish. The turd cherry on top of that shit sundae of code is that the only way to accomodate overloading is to explicitly check for it. This completely violates the purpose of overloading, making things transparently act like builtin types!

There are alternatives. For example, I could check for a `Path::Class::File` object and use Moose&#8217;s coercion feature (along with [`MooseX::Params::Validate`][2] to coerce a bare string to an object. But if there&#8217;s some other class of object that stringifies as a file name then we have to coerce that explicitly, or use a union type.

This broken-ness really only applies to certain builtin operations, like stringification, numification, comparison, etc. The underlying problem is that _all_ of Perl&#8217;s builtin types &#8220;work&#8221; with these operations. Other types of overloading, like overloading array dereferencing, are just fine. I can just write `eval { @{ $val } }` and if it works I know I have something that acts like an array reference.

This is, I think, fixed in Perl 6. It has an explicit API for typecasting so if a class wants to support stringification, it implements a `Str()` method. From what I can see, builtins like Array and Hash _don&#8217;t_ implement this typecasting (yay). Good job Perl 6 team!

For now, I guess I&#8217;m stuck with the nastiness up above, or just throwing up my hands and saying &#8220;stringify your arguments your own damn self&#8221;.

 [1]: http://search.cpan.org/dist/Path-Class
 [2]: http://search.cpan.org/dist/MooseX-Params-Validate

## Comments

### Comment by Adam Kennedy on 2010-10-17 00:56:43 -0500
Params::Util::_SCALARLIKE

### Comment by Dave Rolsky on 2010-10-17 08:34:55 -0500
Yes, this would be very useful, but looking at the docs it doesn&#8217;t seem to exist.

### Comment by phaylon on 2010-10-17 10:45:42 -0500
If overloaded objects and autobox&#8217;ed values would get something like ->DOES(&#8216;Perl::Stringify&#8217;) it could also make things easier. There&#8217;s probably some disadvantage about that as well, besides the speed hit.

### Comment by Cd-MaN on 2010-10-18 00:19:53 -0500
I would like to preface my comment with that statement that I&#8217;m not an expert Perl user.

This said, couldn&#8217;t the case described above (and most of the cases) be treated by &#8220;just doing it&#8221; (like in the Nike commercial :-)). Ie. you try to open the file (using of course the three parameter version :-)) and if it blows up, you propagate the error up (or do whatever you think is necessary) and if it works fine, everything is honky-dory.

While I see some value in checking the values of the input parameters, especially at the &#8220;public boundary&#8221; of an API, when such a check is dependent on an external entity (like the filesystem, the OS), it is inherently fraught with race-conditions. For example: you would like to start a server listening on port X. You check that port X is available by creating and then destroying a socket on it, but it is possible that just after you&#8217;ve destroyed the socket and other program comes along and binds itself to it, resulting in the failure of the server startup. So you need to handle the failure of the server startup process anyway, why introduce an other level of complexity with the pre-check?

The best kind of code is the one you don&#8217;t have to write.

Best regards.

### Comment by Dave Rolsky on 2010-10-18 08:20:43 -0500
@Cd-MaN: What if the filename is the name of the file to write? In that case, pretty much anything will work on Unix (modulo file system permissions).

Also, even in the read case, it&#8217;s better error out as soon as possible. What if the filename is a parameter for object construction, and the actual reading of the file takes place later? It&#8217;s much better to give an error when building the object.

### Comment by David Yingling on 2010-10-18 17:31:27 -0500
The easiest fix is to simply turn that crazy code into a function that you&#8217;d call instead. Or maybe a CPAN module EXPORT_OKing such a function, or as a patch adding the function to an existing module like Scalar::Util.

From:

    if ( defined $val
        && ( !ref $val || ( blessed $val && overload::Method( $val, q{""} ) ) ) )
    {
        ...;
    }
    

To something like:

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
    

If you&#8217;d do this, then after using such a function, you won&#8217;t have to worry or care about the crazy code you have to write to make this happen.

### Comment by Dave on 2011-01-28 13:40:23 -0600
defensive programming is about protecting your resources; not defending against general bad programming. if the developer using your API passes a HASH that doesn&#8217;t stringify to a filename he needs to debug his program. you just have to see that passing in a nasty object won&#8217;t give the developer access to something that can damage the system. first: decide what you will do if the filename is bad and put it in the documentation. second: use an operation to trigger stringification early on so that you aren&#8217;t carrying around stray objects:

my $filename = shift . &#8221;;

thats a good idea in many cases because it doesn&#8217;t hold the object for the life of your new object. it also prevents the user from being able to change the filename, the filename becoming invalid later on or memory being tied down where it is not needed.