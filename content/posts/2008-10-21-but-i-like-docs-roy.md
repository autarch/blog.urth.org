---
title: But I Like Docs, Roy!
author: Dave Rolsky
type: post
date: 2008-10-21T16:59:11+00:00
url: /2008/10/21/but-i-like-docs-roy/
---

Roy Fielding, the inventor of REST, wrote a blog post recently titled [REST APIs must be
hypertext-driven][1]. It's quite hard to understand, being written in pure academese, but I think I
get the gist.

The gist is that for an API to be properly RESTful it must be discoverable. Specifically, you should
be able to point a client at the root URI (/) and have it find all the resources that the API
exposes. This is a cool idea, in theory, but very problematic in practice.

A consequence of this restriction is that any sort of documentation that contains a list of URIs (or
URI templates, more likely) and documentation on accepted parameters is verboten.

Presumably, if I had a sufficiently smart client that understood the media types used in the
application, I'd point it at the root URI, it'd discover all the URIs, and I could manipulate and
fetch data along the way.

That's a nice theory, but has very little with how people want to use these APIs. For a simple
example, let's take Netflix. Let's assume that I want to use the Netflix API to search for a movie,
get a list of results and present it back for a human to pick from, and add something from that list
to my queue.

Without prior documentation on what the URIs are, how would I implement my client? How do I get
those search results? Does my little client appgo to the root URI and then looks at the returned
data for a URI somehow "labeled" as the search URI? How does my client _know_ which URI is which
without manual intervention?

If I understand correctly this would somehow all be encoded in the definition of the media types for
the API. Rather than define a bunch of URI templates up front, I might have a media type of
x-netflix/resource-listing, which is maybe a JSON document containing label/URI/media type triplet.
One of those label/URI pairs may be "Search/http://...". Then my client POSTS that URI using the
x-netflix/movie-search media type. It gets back a x-netflix/movie-listing entity, which contains a
list of movies, each of which consists of a title and URI. I GET each movie URI, which returns an
x-netflix/movie document, which contains a URI template for posting to a queue? Okay, I'm lost on
that last bit. I can't even figure this out.

Resource creation and modification seems even worse. To create or modify resources, we would have a
media type to describe each resource's parameters and type constraints, but figuring out how to
create one would involve traversing the URI space (somehow) until you found the right URI to which
to POST.

Of course, this all "just works" with a web browser, but the whole point of having a web API is to
allow someone to build tools that can be used outside of a
human-clicks-on-things-they're-interested-in interface. We want to automate tasks without requiring
any human interaction. If it requires human intervention and intelligence at each step, we might as
well use a web browser.

I can sort of imagine how all this would work in theory, but I have trouble imagining this not being
horribly resource-intensive (gotta make 10 requests before I figure out where I can POST), and very
complicated to code against.

Worse, it makes casual use of the API much harder, since the docs basically would say something like
this ...

"Here's all my media types. Here's my root URI. Build a client capable of understanding _all_ of
these media types, then point it at the root URI and eventually the client will find the URI of the
thing you're interested in."

Compare this with the Pseudo-REST API Fielding says is wrong, which says "here is how you get
information on a single Person. GET a URI like this ..."

Fielding's REST basically rules out casual implementers and users, since you have to build a
complete implementation of all the media types in advance. Compare this to the pseudo-REST API he
points out. You can easily build a client which only handles a very small subset of the APIs URIs.
Imagine if your client had to handle every URI properly before it could do anything!

In the comments in his blog, Fielding throws in something that _really_ makes me wonder if REST is
feasible. He says,

> A truly RESTful API looks like hypertext. Every addressable unit of information carries an
> address, either explicitly (e.g., link and id attributes) or implicitly (e.g., derived from the
> media type definition and representation structure). Query results are represented by a list of
> links with summary information, not by arrays of object representations (query is not a substitute
> for identification of resources).

Look at last sentence carefully. A "truly RESTful API", in response to a search query, responds not
with the information asked for, but a list of links! So if I do a search for movies and I get a
hundred movies back, what I really get is a summary (title and short description, maybe) and a bunch
of links. Then if I want to learn more about each movie **I have to request each of 100 different
URIs separately!**

It's quite possible that I've completely misunderstood Fielding's blog post, but I don't think so,
especially based on what he said in the comments.

I'm not going argue that REST is something other than what Fielding says, because he's the expert,
but I'm not so sure I really want to create true REST APIs any more. Maybe from now I'll be creating
"APIs which share some characteristics with REST but are not quite REST".

[1]: http://roy.gbiv.com/untangled/2008/rest-apis-must-be-hypertext-driven
