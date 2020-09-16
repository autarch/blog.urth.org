---
title: 'Courriel: What and Why'
author: Dave Rolsky
type: post
date: 2011-06-06T16:40:22+00:00
url: /2011/06/06/courriel-what-and-why/
---
I recently released new distribution on CPAN called [Courriel][1]. The word "courriel" is the official French word for email. I chose it because the Mail and Email namespaces are already very crowded, and there's really no good namespaces left there.

This gets to the why. Courriel is a distribution for processing and creating **modern** email. What's modern? In ye olde dayes of RFC822 email, an email was a bunch of headers followed by a message for the recipient. Ye olde days are long gone. In these modern times, multipart emails are extremely common, and they're a lot more complicated than the emails of olde.

It's quite common nowadays to receive email consisting of nested multipart messages. The top level part will be multipart/mixed, which in turn contains a multipart/alternative part as well as a bunch of attachments (spreadsheet, image, etc.). That multipart/alternative part will typically contain both text/plain and text/html parts. These are two versions of the "body" of the message, the part that's intended to be read by the recipient in their mail client.

Here's a diagram:

<pre class="highlight:false">multipart/mixed
  |
  |-- multipart/alternative
  |     |
  |     |-- text/plain (disposition = inline)
  |     |-- text/html  (disposition = inline)
  |
  |-- application/vnd.ms-excel (disposition = attachment)
  |-- image/png                (disposition = attachment)
</pre>

It can actually be even more complicated. If the HTML body has references to images or CSS, you might get something more like this:

<pre class="highlight:false">multipart/mixed
  |
  |-- multipart/alternative
  |     |
  |     |-- text/plain (disposition = inline)
  |     |-- multipart/related
  |           |
  |           |-- text/html  (disposition = inline)
  |           |-- image/jpeg (disposition = attachment, Content-ID = image1)
  |           |-- image/jpeg (disposition = attachment, Content-ID = image2)
  |
  |-- application/vnd.ms-excel (disposition = attachment)
  |-- image/png                (disposition = attachment)
</pre>

That's quite a structure!

If you just wanted to _generate_ these sorts of emails, the existing options were acceptable(ish). Between [Email::Stuff][2] and [Email::MIME::CreateHTML][3], you could get by. But if you wanted to _process_ this email as part of an application, you were really stuck.

The [Perl Email Project][4] was started way back in 2004 with the release of [Email::Simple][5] by Simon Cozens. I was excited when this happened, as I was really hoping for something like the Perl DateTime Project, a powerful ecosystem of modules backed by a usable, feature-rich core implementation.

Unfortunately, Email::Simple and its companion module [Email::MIME][6] never really did what I wanted. While simple is good, the project never really advanced beyond simple to provide a featureful, user-friendly API.

The fundamental problems with these modules are several fold.

First, the internals of the modules are way too chummy. Rather than building clear APIs between components, the modules simply step all over each other's guts.

Second, the internals of the modules are all about strings. When you add a part to a MIME message, internally that part will be immediately serialized as a string and tacked onto the existing body as a string. This problem manifests in many other ways (when dealing with headers, content types, content disposition, and elsewhere). This makes building higher level APIs much more complicated than it should be.

Finally, the fact that Email::MIME treats all parts as equal is really problematic. While in theory an email is simply a nested set of identical things (MIME parts), in practice some parts are more important than others. The headers attached to the top level part are different (in content) from headers attached to "internal" parts, as that's where you'll find things like the From header, Subject, and so on. Other parts have their own important roles, like providing a message body or being an attachment. The Email project doesn't provide any convenient APIs for getting this type of data.

Courriel aims to address these problems. It's built with Moose, which makes it easier to build clean APIs across multiple modules. The internals aren't perfect though, as I still ended up calling private methods on another class's object in a couple spots. Patches are definitely welcome!

Internally, Courriel is all about objects. It's happy to accept strings through various parsing methods, but internally parts are objects, and it won't rebuild the stringified representation as state changes. Instead, it only builds the fully stringified form when you ask for it.

As an aside, Courriel is a lot less mutable than Email::MIME. While you can mutate the headers of a part, you can't really change anything else about it. If you wanted to add or remove parts, you must make a new object with the old one's parts, plus or minus something.

Courriel provides a low-level API where all parts are equal and a high-level API on top of it that helps you get stuff done. You can write code like this:

<pre class="lang:perl">my $courriel = Courriel->parse( text => $raw_email );

print $courriel->subject(), "\n\n", $courriel->plain_body()->content();
</pre>

Doing this same sort of thing with Email::MIME requires a **lot** more code.

Finally, it provides a simplified email creation module called [Courriel::Builder][7].

I've already found Courriel useful in simplifying and improving my own code, and I hope others find it useful. I'm sure it has lots of bugs, misfeatures, and missing features, of course. The repository is on my git server and you can clone it anonymously from git://git.urth.org/Courriel.git.

 [1]: http://beta.metacpan.org/release/Courriel
 [2]: http://beta.metacpan.org/release/Email-Stuff
 [3]: http://beta.metacpan.org/release/Email-MIME-CreateHTML
 [4]: http://emailproject.perl.org/
 [5]: http://beta.metacpan.org/release/Email-Simple
 [6]: http://beta.metacpan.org/release/Email-MIME
 [7]: http://beta.metacpan.org/module/Courriel::Builder

## Comments

**sartak.org, on 2011-06-06 18:50, said:**  
<pre>Courriel-&gt;parse( text =&gt; \$raw_email );</pre>

In 2011, is this really the appropriate default to use in documentation and blog posts? I understand that it's there to avoid unnecessary string copying of gigantic email text, but is that really a bottleneck that most, if any, of your users need to care about? Especially when such an API requires caveats like:

> The scalar underlying the reference _will_ be modified, so don't pass in something you don't want modified.

It just jumps out at me as premature optimization.

**Dave Rolsky, on 2011-06-06 19:20, said:**  
@sartak: That's a good point. I should probably change the docs to default to safer, simpler form. It's nice that reference is there as option.

(I'll be changing the blog post, so your comment might be confusing soon ;)

**Zbigniew Lukasiak, on 2011-06-07 08:21, said:**  
One question about the decoded/encoded content - how transport encoding fits there? I understand that $part->content() is a Perl character string - while $part->encoded_content() is a binary string - is it also transport encoded?

**Dave Rolsky, on 2011-06-07 09:46, said:**  
@Zbigniew: The value of $part->encoded_content() is the raw content of the part with its transfer encoding. Maybe "encoded" isn't the best word to use, since it's a little ambiguous, but it's referring the transfer encoding, not a character set.

**Zbigniew Lukasiak, on 2011-06-28 04:57, said:**  
I think the name is OK - it just needs an explanation in the docs.

**Dave Rolsky, on 2011-07-14 15:35, said:**  
@Zbigniew: This seems like a good case of TIAS ;)

I'm using it for some projects I'm working, but nothing serious. It seems to work okay so far.

**Zbigniew Lukasiak, on 2011-08-30 03:19, said:**  
One more question - the headers we get from 'get' in <a href="http://search.cpan.org/~drolsky/Courriel-0.19/lib/Courriel/Headers.pm" rel="nofollow ugc">http://search.cpan.org/~drolsky/Courriel-0.19/lib/Courriel/Headers.pm</a> (and transitively in 'subject' on the main object) are generally byte strings (in the sense that we need to do `Encode::decode('MIME-Header', $email->subject());` - this is different from the 'content' where we get characters. I think in most cases what is needed is the decoded character data - so this probably should be automatic, plus maybe a 'get_encoded' accessor for the bytes. What do you think?