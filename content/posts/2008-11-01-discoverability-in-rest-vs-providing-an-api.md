---
title: Discoverability in REST vs Providing an API
author: Dave Rolsky
type: post
date: 2008-11-01T15:20:09+00:00
url: /2008/11/01/discoverability-in-rest-vs-providing-an-api/
categories:
  - Uncategorized

---
I&#8217;m still stuck on the whole problem of the requirement that URIs for REST APIs be discoverable, not documented. It&#8217;s not so much that making them discoverable is hard, it&#8217;s that making them discoverable makes them useless for some (common) purposes.

When [I last wrote about REST][1], I got [taken to task][2] and even called a traitor (ok, I didn&#8217;t take that very seriously ;) Aristotle Pagaltzis (and Matt Trout via IRC) told me to take a look at [AtomPub][3].

I took a look, and it totally makes sense. It defines a bunch of document types, which along with the original [Atom Syndication Format][4], would let you easily write a non-browser based client for publishing to and reading from an Atom(Pub)-capable site. That&#8217;s cool, but this is for a very specific type of client. By specific I mean that the publishing tool is going to be interactive. The user navigates the Atom workspaces, in the client finds the collection they&#8217;re looking for, POSTs to it, and they have a new document on the site.

But what about a non-interactive client? I just don&#8217;t see how REST could work for this.

Let me provide a very specific example. I have this site [VegGuide.org][5]. It&#8217;s a database of veg-friendly restaurant, grocers, etc., organized in a tree of regions. At the root of the tree, we have &#8220;The World&#8221;. The leaves of that node are things like &#8220;North America&#8221;, &#8220;Europe&#8221;, etc. In turn &#8220;North America&#8221; contains &#8220;Canada&#8221;, &#8220;Mexico&#8221; and &#8220;USA&#8221;. This continues until you find nodes which only contain entries, not other regions, like &#8220;Chicago&#8221; and &#8220;Manhattan&#8221;.

(There are also other ways to navigate this space, but none of them would be helpful for the problem I&#8217;m about to outline.)

I&#8217;d like for VegGuide to have a proper REST API, and in fact its existing URIs are all designed to work both for browsers and for clients which can do &#8220;proper&#8221; REST (and don&#8217;t need HTML, just &#8220;raw&#8221; data in some other form). I haven&#8217;t actually gotten around to making the site produce non-HTML output yet, but I could, just by looking at the Accept header a client sends.

Let&#8217;s say that Jane Random wants to get all the entries for Chicago, maybe process them a bit, and then republish them on her site. At a high level, what Jane wants is to have a cron job fetch the entries for Chicago each night and then generate some HTML pages for her site based on that data.

How could she do this with a proper REST API? Remember, Jane is not allowed to _know_ that http://www.vegguide.org/region/93 is Chicago&#8217;s URI. Instead, her client must go to the site root and somehow &#8220;discover&#8221; Chicago!

The site root will return a JSON document something like this:

<pre class="lang:js">{ regions:
  [ { name: "North America",
      uri:  "http://www.vegguide.org/region/1" },
    { name: "South America",
      uri:  "http://www.vegguide.org/region/28" } }
  ]
}
</pre>

Then her client can go to the URI for North America, which will return a similar JSON document:

<pre class="lang:js">{ regions:
  [ { name: "Canada",
      uri:  "http://www.vegguide.org/region/19" },
    { name: "USA",
      uri:  "http://www.vegguide.org/region/2" } }
  ]
}
</pre>

Her client can pick USA and so on until it finally gets to [the URI for Chicago][6], which returns:

<pre class="lang:js">{ entries:
  [ { name: "Soul Vegetarian East",
      uri:  "http://www.vegguide.org/entry/46",
      rating: 4.3 },
    { name: "Chicago Diner",
    uri:  "http://www.vegguide.org/entry/56",
    rating: 3.9 },
  ]
}
</pre>

Now the client has the data it wants and can do its thing.

Here&#8217;s the problem. How the hell is this automated client supposed to **know** how to navigate through this hierarchy?

The only (non-AI) possibility I can see is that Jane must embed some sort of knowledge that she has _as a human_ into the code. This knowledge simply isn&#8217;t available in the information that the REST documents provide.

Maybe Jane will browse the site and figure out that these regions exist, and hard-code the client to follow them. Her client could have a list of names to look for in order: &#8220;North America&#8221;, &#8220;USA&#8221;, &#8220;Illiinois&#8221;, &#8220;Chicago&#8221;.

If the names changed and the client couldn&#8217;t find them in the REST documents, it could throw an error and Jane could tweak the client. A sufficiently flexible client could allow her to set this &#8220;name chain&#8221; in a config file. Or maybe the client could use regexes so that some possible changes (&#8220;USA&#8221; becomes &#8220;United States&#8221;) are accounted for ahead of time.

Of course, if Jane is paying attention, she will quickly notice that the URIs in the JSON documents happen to match the URIs in their browser, and she&#8217;ll hardcode her client to just GET [the URI for Chicago][6] and be done with it. And since sites should have Cool URIs, this will work for the life of the site.

Maybe the answer is that I&#8217;m trying to use REST for something inherently outside the scope of REST. Maybe REST just isn&#8217;t for non-interactive clients that want to get a small part of some site&#8217;s content.

That&#8217;d be sad, because non-interactive clients which interact with just part of a site are fantastically useful, and much easier to write than full-fledged interactive clients which can interact with the entire site (the latter is commonly called a web browser!).

REST&#8217;s discoverability requirement is very much opposed to my personal concept of an API. An API is _not_ discoverable, it&#8217;s documented.

Imagine if I released a Perl module and said, &#8220;my classes use Moose, which provides a standard metaclass API (see RFC124945). Use this metaclass API to discover the methods and attributes of each class.&#8221;

You, as an API consumer, could do this, but I doubt you&#8217;d consider this a &#8220;real&#8221; API.

So as I said before, I suspect I&#8217;ll end up writing something that&#8217;s only sort of REST-like. I _will_ provide well-documented document types (as opposed to JSON blobs), and those document types _will_ all include hyperlinks. However, I&#8217;m also going to document my site&#8217;s URI space so that people can write non-interactive clients.

 [1]: /2008/10/21/but-i-like-docs-roy/
 [2]: http://use.perl.org/comments.pl?sid=41350
 [3]: http://tools.ietf.org/html/rfc5023
 [4]: http://www.ietf.org/rfc/rfc4287
 [5]: http://www.vegguide.org
 [6]: http://www.vegguide.org/region/93

## Comments

### Comment by Gerry on 2009-07-29 18:46:02 -0500
I think you misinterpreted the most important REST principle. The media type descriptions are the only contracts between client and server. So the client does know ahead of time how to process the different types of resources it will receive. Those types should be well documented, including their format/syntax.

What is discoverable is the next state of the application, the set of reachable resources. At any time the server can decide to change what resource(s) is reachable when responding to the client. 

The methods that a resource supports are also discoverable with the OPTIONS method. At any time the server can decide to change which method is supported by a resource.

I think you need to consult the Yahoo REST mailing0list. You will find all your REST answers there.

### Comment by Dave Rolsky on 2009-07-29 19:55:30 -0500
Gerry, what exactly did I misinterpret. I understand what you explained, and my point was that enforcing discoverability makes providing a documented, stable API impossible.

Since one of the goals of having a REST-like interface (documented media types, Cool Uris, etc) is to provide an API, I think it&#8217;s useful to be mostly RESTful, but still document one&#8217;s URI space.

### Comment by Simon Dean on 2010-06-03 14:41:11 -0500
Is there anything wrong with a RESTful service having Cool URIs? After all, Cool URIs are just another part of the &#8220;web&#8217;s architecture&#8221;. If the REST service gets rid of <a href="http://www.vegguide.org/region/93" rel="nofollow ugc">http://www.vegguide.org/region/93</a> then it can be a good web citizen and return a 301 to the new location or a 404 in the worst case. The client could hard code (aka bookmark) the <a href="http://www.vegguide.org/region/93" rel="nofollow ugc">http://www.vegguide.org/region/93</a> URI into its logic and when (as time passes) it starts to get a 301 or 404 status code back, it can act accordingly &#8211; e.g. follow the 301 or notify a human in the case of the 404. 

Perhaps there are two sides to REST service discoverability? One side is about making it easy for humans to understand your service and discover new features without having to trawl through documentation (a good thing in my book). The other side would be avoiding constructing URLs in the client by having the client walk the REST URLs from some known entry point (e.g. <a href="http://www.vegguide.org/region/" rel="nofollow ugc">http://www.vegguide.org/region/</a>) &#8211; is that second point even about discoverability? 

In your example, URLs like <a href="http://www.vegguide.org/region/chicago" rel="nofollow ugc">http://www.vegguide.org/region/chicago</a> might be more useful.

### Comment by Julian on 2010-12-02 06:23:22 -0600
In your example, a query by place (maybe even using Flickr&#8217;s Places API) would probably make the most sense. A fully automated client would pick the most likely candidate based on geolocation, locale, and popularity of results. I guess the question is — is a search interface also too undiscoverable?

I think it&#8217;s difficult to expect complete discoverability without more semantic information available to clients. I came here while looking for any debate on the discoverability of PUT URIs. I mean, if you look at Amazon S3&#8217;s REST API, it has relatively undiscoverable PUT operations, but it&#8217;s a nice API. So I think some degree of documentation instead of discovery is probably acceptable, but the idea of complete discoverability is attractive.