---
title: Discoverability in REST vs Providing an API
author: Dave Rolsky
type: post
date: 2008-11-01T15:20:09+00:00
url: /2008/11/01/discoverability-in-rest-vs-providing-an-api/
---

I'm still stuck on the whole problem of the requirement that URIs for REST APIs be discoverable, not
documented. It's not so much that making them discoverable is hard, it's that making them
discoverable makes them useless for some (common) purposes.

When [I last wrote about REST][1], I got [taken to task][2] and even called a traitor (ok, I didn't
take that very seriously ;) Aristotle Pagaltzis (and Matt Trout via IRC) told me to take a look at
[AtomPub][3].

I took a look, and it totally makes sense. It defines a bunch of document types, which along with
the original [Atom Syndication Format][4], would let you easily write a non-browser based client for
publishing to and reading from an Atom(Pub)-capable site. That's cool, but this is for a very
specific type of client. By specific I mean that the publishing tool is going to be interactive. The
user navigates the Atom workspaces, in the client finds the collection they're looking for, POSTs to
it, and they have a new document on the site.

But what about a non-interactive client? I just don't see how REST could work for this.

Let me provide a very specific example. I have this site [VegGuide.org][5]. It's a database of
veg-friendly restaurant, grocers, etc., organized in a tree of regions. At the root of the tree, we
have "The World". The leaves of that node are things like "North America", "Europe", etc. In turn
"North America" contains "Canada", "Mexico" and "USA". This continues until you find nodes which
only contain entries, not other regions, like "Chicago" and "Manhattan".

(There are also other ways to navigate this space, but none of them would be helpful for the problem
I'm about to outline.)

I'd like for VegGuide to have a proper REST API, and in fact its existing URIs are all designed to
work both for browsers and for clients which can do "proper" REST (and don't need HTML, just "raw"
data in some other form). I haven't actually gotten around to making the site produce non-HTML
output yet, but I could, just by looking at the Accept header a client sends.

Let's say that Jane Random wants to get all the entries for Chicago, maybe process them a bit, and
then republish them on her site. At a high level, what Jane wants is to have a cron job fetch the
entries for Chicago each night and then generate some HTML pages for her site based on that data.

How could she do this with a proper REST API? Remember, Jane is not allowed to _know_ that
http://www.vegguide.org/region/93 is Chicago's URI. Instead, her client must go to the site root and
somehow "discover" Chicago!

The site root will return a JSON document something like this:

```json
{ regions:
  [ { name: "North America",
      uri:  "http://www.vegguide.org/region/1" },
    { name: "South America",
      uri:  "http://www.vegguide.org/region/28" } }
  ]
}
```

Then her client can go to the URI for North America, which will return a similar JSON document:

```json
{ regions:
  [ { name: "Canada",
      uri:  "http://www.vegguide.org/region/19" },
    { name: "USA",
      uri:  "http://www.vegguide.org/region/2" } }
  ]
}
```

Her client can pick USA and so on until it finally gets to [the URI for Chicago][6], which returns:

```json
{
  "entries": [
    { "name": "Soul Vegetarian East", "uri": "http://www.vegguide.org/entry/46", "rating": 4.3 },
    { "name": "Chicago Diner", "uri": "http://www.vegguide.org/entry/56", "rating": 3.9 }
  ]
}
```

Now the client has the data it wants and can do its thing.

Here's the problem. How the hell is this automated client supposed to **know** how to navigate
through this hierarchy?

The only (non-AI) possibility I can see is that Jane must embed some sort of knowledge that she has
_as a human_ into the code. This knowledge simply isn't available in the information that the REST
documents provide.

Maybe Jane will browse the site and figure out that these regions exist, and hard-code the client to
follow them. Her client could have a list of names to look for in order: "North America", "USA",
"Illiinois", "Chicago".

If the names changed and the client couldn't find them in the REST documents, it could throw an
error and Jane could tweak the client. A sufficiently flexible client could allow her to set this
"name chain" in a config file. Or maybe the client could use regexes so that some possible changes
("USA" becomes "United States") are accounted for ahead of time.

Of course, if Jane is paying attention, she will quickly notice that the URIs in the JSON documents
happen to match the URIs in their browser, and she'll hardcode her client to just GET [the URI for
Chicago][6] and be done with it. And since sites should have Cool URIs, this will work for the life
of the site.

Maybe the answer is that I'm trying to use REST for something inherently outside the scope of REST.
Maybe REST just isn't for non-interactive clients that want to get a small part of some site's
content.

That'd be sad, because non-interactive clients which interact with just part of a site are
fantastically useful, and much easier to write than full-fledged interactive clients which can
interact with the entire site (the latter is commonly called a web browser!).

REST's discoverability requirement is very much opposed to my personal concept of an API. An API is
_not_ discoverable, it's documented.

Imagine if I released a Perl module and said, "my classes use Moose, which provides a standard
metaclass API (see RFC124945). Use this metaclass API to discover the methods and attributes of each
class."

You, as an API consumer, could do this, but I doubt you'd consider this a "real" API.

So as I said before, I suspect I'll end up writing something that's only sort of REST-like. I _will_
provide well-documented document types (as opposed to JSON blobs), and those document types _will_
all include hyperlinks. However, I'm also going to document my site's URI space so that people can
write non-interactive clients.

[1]: /2008/10/21/but-i-like-docs-roy/
[2]: http://use.perl.org/comments.pl?sid=41350
[3]: http://tools.ietf.org/html/rfc5023
[4]: http://www.ietf.org/rfc/rfc4287
[5]: http://www.vegguide.org
[6]: http://www.vegguide.org/region/93

## Comments

**Gerry, on 2009-07-29 18:46, said:**  
I think you misinterpreted the most important REST principle. The media type descriptions are the
only contracts between client and server. So the client does know ahead of time how to process the
different types of resources it will receive. Those types should be well documented, including their
format/syntax.

What is discoverable is the next state of the application, the set of reachable resources. At any
time the server can decide to change what resource(s) is reachable when responding to the client.

The methods that a resource supports are also discoverable with the OPTIONS method. At any time the
server can decide to change which method is supported by a resource.

I think you need to consult the Yahoo REST mailing0list. You will find all your REST answers there.

**Dave Rolsky, on 2009-07-29 19:55, said:**  
Gerry, what exactly did I misinterpret. I understand what you explained, and my point was that
enforcing discoverability makes providing a documented, stable API impossible.

Since one of the goals of having a REST-like interface (documented media types, Cool Uris, etc) is
to provide an API, I think it's useful to be mostly RESTful, but still document one's URI space.

**Simon Dean, on 2010-06-03 14:41, said:**  
Is there anything wrong with a RESTful service having Cool URIs? After all, Cool URIs are just
another part of the "web's architecture". If the REST service gets rid of
<http://www.vegguide.org/region/93> then it can be a good web citizen and return a 301 to the new
location or a 404 in the worst case. The client could hard code (aka bookmark) the
<http://www.vegguide.org/region/93> URI into its logic and when (as time passes) it starts to get a
301 or 404 status code back, it can act accordingly - e.g. follow the 301 or notify a human in the
case of the 404.

Perhaps there are two sides to REST service discoverability? One side is about making it easy for
humans to understand your service and discover new features without having to trawl through
documentation (a good thing in my book). The other side would be avoiding constructing URLs in the
client by having the client walk the REST URLs from some known entry point (e.g.
<http://www.vegguide.org/region/>) - is that second point even about discoverability?

In your example, URLs like <http://www.vegguide.org/region/chicago> might be more useful.

**Julian, on 2010-12-02 06:23, said:**  
In your example, a query by place (maybe even using Flickr's Places API) would probably make the
most sense. A fully automated client would pick the most likely candidate based on geolocation,
locale, and popularity of results. I guess the question is — is a search interface also too
undiscoverable?

I think it's difficult to expect complete discoverability without more semantic information
available to clients. I came here while looking for any debate on the discoverability of PUT URIs. I
mean, if you look at Amazon S3's REST API, it has relatively undiscoverable PUT operations, but it's
a nice API. So I think some degree of documentation instead of discovery is probably acceptable, but
the idea of complete discoverability is attractive.
