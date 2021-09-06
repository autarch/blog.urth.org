---
title: API Design and the Recent IP Address Module Issues
author: Dave Rolsky
type: post
date: 2021-04-03T11:01:20-05:00
url: /2021/04/03/api-design-and-the-recent-ip-address-module-issues
discuss:
    - site: "/r/perl"
      uri: "https://www.reddit.com/r/perl/comments/mjcxq7/api_design_and_the_recent_ip_address_module_issues/"
    - site: "/r/programming"
      uri: "https://www.reddit.com/r/programming/comments/mjcy1t/api_design_and_the_recent_ip_address_module_issues/"
---

Earlier this week, I wrote about [security issues in Perl IP address
distros]({{< relref "2021-03-29-security-issues-in-perl-ip-address-distros"
>}}). I started thinking about _why_ these issues showed up in so many
distros, which got me thinking about how an API can make these types of
problems harder or easier.

Specifically, I'd like to talk about
[`Data::Validate::IP`](https://metacpan.org/pod/Data::Validate::IP).

Let's look at two functions exported by this module, `is_ipv4` and
`is_private_ipv4`.

On the surface, these sure look like they're the same general thing. They take
a string and return a boolean. But thinking about their semantics, these are
very much _not_ the same general thing.

The `is_ipv4` function is **validating that a string is an IPv4 address**.

```perl
is_ipv4('1.2.3.4'); # true
is_ipv4('feed::3e'); # false
is_ipv4('not even an IP address'); # false
```

As an aside, it actually returns the string you give it for a true value, but
that will always be treated as a true value by Perl.

And it also returns false when given `010.0.0.1`. This is (maybe) technically
incorrect, but as we saw from this week's security issue, it's probably better
than returning true. If an attacker can somehow supply this IP address to an
application, or if someone just makes a typo in a config file, this address
can be treated as either `10.0.0.1` or `8.0.0.1`, depending on the code in
question.

This all seems great so far. So what's the problem?

Well, let's think about `is_private_ipv4`. Here's what it returns for some
inputs:

```perl
is_private_ipv4('10.0.0.1'); # true
is_private_ipv4('010.0.0.1'); # false
is_private_ipv4('1.2.3.4'); # false
is_private_ipv4('feed::3e'); # false
is_private_ipv4('not even an IP address'); # false
```

So what is this function doing? Well, it's obviously doing IPv4 address
validation, since it returns false for things like `feed::3e` or `not even an
IP address`. But **it's also doing categorization**, because it returns false
for a valid IP address like `1.2.3.4`, while `10.0.0.1`, also a valid IPv4
address, returns true.

So this function does two things, validation _and_ categorization, but the
return value lumps these things together. You cannot tell by its return value
whether the address was invalid or if it was valid but not private.

The `is_public_ipv4` function has the same problem. It does both validation
and categorization in one call.

This is a very subtle point, and it's easy to miss when you're using this
module. It would be very easy to introduce a security issue with this
code[^1]:

```perl
if ( !is_public_ipv4($some_addr) ) {
    send_private_data($some_addr);
} else {
    send_public_data($some_addr);
}
```

If `is_public_ipv4` is given `010.0.0.1` it returns false, which means we send
private data. So how should this be written? We need to validate first:

```perl
die "Invalid IPv4: $some_addr"
    unless is_ipv4($some_addr);

if ( !is_public_ipv4($some_addr) ) {
    send_private_data($some_addr);
} else {
    send_public_data($some_addr);
}
```

Perhaps elsewhere in this code we might want to call `is_linklocal_ipv4()` or
`is_loopback_ipv4($ip)`. But we need to remember to add an `is_ipv4` check
before _every_ `is_*_ipv4` call. Will we remember? Probably not.

While I've used this module for years, and I've even been its primary
maintainer for some time, I didn't think about the implications of its API
until earlier this week!

So if the maintainer didn't think about it, we can probably assume that most
of its other users didn't either.

What would a better API look like? We need to separate validation and
categorization, and we need to _force_ users to go through validation before
doing categorization.

There are various ways to do this, but an OO interface makes this trivial:

```perl
if ( !IPv4->new($some_addr)->is_public ) {
    send_private_data($some_addr);
} else {
    send_public_data($some_addr);
}
```

If the `IPv4->new` call throws an exception on invalid data, then this code is
perfectly safe[^2]. There is no way to use this API to categorize invalid
data. So even the person who wrote this terrible logic ("if not public send
private?" WTF?!) will be prevented from doing more damage.

Another approach would be to have `is_private_ipv4` throw an exception if
given invalid data. That way it has three "return values", true (valid and
private), false (valid but not private), and exception (invalid).

Data validation is important for correctness, and correctness is important for
security. Don't design APIs that put the validation burden on the user. Make
it as hard as you can to do the wrong thing with your API[^3].

[^1]: Yes, this code is bad, but that's kind of the point. Is all the code
    you've ever worked with well thought out and clearly structured?  Did it
    always handle all the corner cases properly? Was it always free from
    obvious logic errors? I can wait for you to stop laughing before we
    continue.

[^2]: At least it's safe if every address that's _not_ public is private. This
    isn't true for IPv4 (or IPv6), but sending private data to a link-local or
    loopback address is probably(?) okay.

[^3]: Though nothing can stop the truly clueless developer. Someone could
    still write this:

    ```perl
    if ( !eval { IPv4->new($some_addr)->is_public } ) {
        send_private_data($some_addr);
    } else {
        send_public_data($some_addr);
    }
    ```

    But if you write code that intentionally ignores exceptions that _you should
    not ignore_ I give up.
