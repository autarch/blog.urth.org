---
title: My Way of the Webapp
author: Dave Rolsky
type: post
date: 2009-07-27T10:39:31+00:00
url: /2009/07/27/my-way-of-the-webapp/
categories:
  - Uncategorized

---
I&#8217;ve been working on web applications for a long time, and over the years I&#8217;ve developed a specific approach to structuring web application code. In the past few years, this has been strongly influenced by [REST concepts][1].

My approach leads me to make use of some existing concepts, like cookies and sessions, in an idiosyncratic way. Sometimes in discussions about web application I&#8217;ll refer to these idiosyncrasies, but seen in isolation they may make no sense to anyone but me.

This entry will attempt to explain both my philosophical approach, and the practical consequences of that approach. This will _not_ be a start-to-finish guide to building a web app (not even close).

## Each Action Does One Thing

In this context, an action is a Catalyst action. In non-Catalyst speak, it&#8217;s a method that handles the response for a request. With REST, a request is identified by both its URI _and_ its method, so we distinguish between a GET and POST to the same URI.

So what is one thing? That one thing can be one or more related database changes, some other non-database task (sending an email), or generating output for the client (HTML or something else).

An importance consequence of this &#8220;one thing&#8221; rule is that an action can either change some state on the server _or_ return data to the client. An action never does both (ignoring side effects like logging or stats tracking). For a browser, this means that all non-GET requests are followed by a redirect to a GET.

I cannot abide an application that receives a POST, updates the database, and then returns some HTML. Inevitably, this produces crufty code filled with conditionals.

The worst examples of this are applications that have a single URI that displays a form, and then on a successful form submission display a different page at the same URI. This is a huge violation of REST, and makes the code even more crufty with conditionals.

I think the main reason people like to combine POST/PUT/DELETE handling and HTML generation is to make it easier to give feedback to the user. If the submission is unsuccessful, we want to show the same form to the user with some error messages (&#8220;password is required&#8221;). When the submisson is successful we want to give them feedback about that (&#8220;your comment has been accepted and is pending review&#8221;).

Of course, providing clear feedback to users is absolutely crucial in building a usable application, but we can have our RESTful, well-designed cake and eat it too.

## RESTful, Minimal Sessions

Contrary to some of what you might read online, you can have sessions with REST. The key is that the URI must describe the whole item being requested, _including the session_. That means putting the session in the URI.

But putting sessions in the URI has all sorts of well-known problems. First, it makes for ugly URIs. Second, it means you have to carry that session URI throughout the application. Third, it makes session-jacking much easier.

The second problem is easy to address. Just don&#8217;t carry the session URI throughout the application! A properly built web application does not need a session for every request. If you just use the session to carry a response to a POST/PUT/DELETE, you can limit the scope of the session. I only need to include a session in the URI as part of a redirect, so my HTML pages never include links with a session.

To that end, I keep my sessions extremely minimal. There are only three things I put in a session:

  1. Error messages &#8211; these can be either general messages like &#8220;you don&#8217;t have access to edit comments&#8221; or specific to a form field like &#8220;this is not a valid email address&#8221;.
  2. Feedback messages &#8211; &#8220;your comment has been submitted for review&#8221;
  3. Form data &#8211; when a form submission results in an error, you show the form to the user again, and always make sure to repopulate it with the data they submitted.

All of this data shares the quality of being _transient_. It only needs to be used on a single URI. Once the user leaves the page in question, we no longer need the session.

This helps address the ugly URI problem. Most URIs just don&#8217;t have a session, so we limit the scope of our ugliness.

This also helps address the session-jacking problem. Again, the data is transient, and is only needed on one page. Since I don&#8217;t store authentication information in the session, you still need to authenticate to see the relevant page. This means that if the user gives the URI with a session to someone else, it doesn&#8217;t matter.

In my applications, sessions expire after five minutes. If a user tries to go back to an old URI with a session, then the application simply redirects them to the session-less URI, which is always valid, because my applications have [Cool, RESTful URIs][2], except for the session piece.

Taken together, this lets me have RESTful sessions with no security risk and minimal ugliness.

As a bonus, keeping sessions minimal helps force me to think clearly about application workflow, rather than just jamming tons of data into a session and using it all over the application.

## RESTful Cookie Authentication

Much of the literature on REST suggests that in order to be properly RESTful, you need to use HTTP authentication. Of course, anyone who&#8217;s ever worked on a real web application knows that HTTP authentication is a horrible, horrible thing to deal with. You have no control over the UI, it&#8217;s impossible to logout except with insane hacks, and it makes for an overall horrible user experience.

Realistically, if your client is a web browser, you have to use a cookie for authentication. Many applications, however, use a _session_ cookie. _Every_ request involves a session lookup, and the user id is stored in the session. This is bad and wrong. First, it requires that we have a session on every page, which I don&#8217;t like. Second, it egregiously violates RESTful principles by passing around an opaque token with unclear semantics.

For me, using an authentication-only cookie is close enough to REST. With an authentication cookie, we get an effect very similar to HTTP authentication. Every request includes the authentication information, and the server checks this on every request. There is no hidden state, and while this is still technically opaque, the opaque piece is as minimal as possible.

This still isn&#8217;t really RESTful, but I just don&#8217;t care. I&#8217;m all for doing things in an architecturally proper manner, but only if I can provide a great user experience too. Mostly, REST and a great experience are compatible, but when it comes to authentication, HTTP auth is simply not tenable.

However, I can at least minimize the degree to which I compromise, and using the cookie for authentication and authentication only is as minimal as I can get.

## Practical Consequences

These approaches, taken together, have led me to write several Catalyst plugins and/or adopt others. First of all, I use [Catalyst::Action::REST][3]. I&#8217;m primarily interested in using it to let me dispatch GET, PUT, POST, and DELETE to different controller methods internally, and it does this very cleanly.

I also use my own [Catalyst::Request::REST::ForBrowsers][4] module. This lets me define all of my internal code in terms of the four HTTP methods mentioned above, but yet still work with browsers. Browsers have two problems. First, they don&#8217;t accept arbitrary document types, so I can&#8217;t return a well-defined document type of my choosing, I have to return HTML, and that HTML needs to include (by reference) information about styling (CSS) and client-side behavior (Javascript). This is fundamentally unlike a notional smart REST client. Second, browsers do not support PUT or DELETE, so I &#8220;tunnel&#8221; that through a POST.

I also use the [Catalyst Session plugin][5], along with [Catalyst::Plugin::Session::State::URI][6]. I make sure to configure the URI state plugin to only rewrite redirects, as mentioned earlier.

Yesterday, I released [Catalyst::Plugin::Session::AsObject][7]. THis enforces session discipline by providing the session as an object, not a hash reference. Instead of writing `$c->session()->{errors}`, I write `$c->session_object()->errors()`. This makes it easy to limit what data can go in the session, and gives me a _much_ nicer API for pulling data back out. Note that all the plugin does is let you configure the class name of the session object. You can provide your own class on a per-application basis, meaning you can use it for any session data you want, not just my three items.

For authentication, I use my own [Catalyst::Plugin::AuthenCookie][8]. When I wrote this, the dominant [Catalyst Authentication plugin][9] required that the user authentication be stored in a session. Since I did not want a session on every request, I ended up writing my own plugin. Since that time, the original Authentication plugin has made use of the session has optional, but I still find it dauntingly complex for common use, so I&#8217;ll stick with my own plugin.

So that&#8217;s a slice of my approach to web applications. Hopefully this was interesting, and less confusing than hearing about it piecemeal. It may also help explain why I&#8217;ve written some of my modules, in case anyone was wondering &#8220;what use is X&#8221;.

 [1]: http://en.wikipedia.org/wiki/Representational_State_Transfer
 [2]: http://www.w3.org/Provider/Style/URI
 [3]: http://search.cpan.org/dist/Catalyst-Action-REST
 [4]: http://search.cpan.org/dist/Catalyst-Request-REST-ForBrowsers
 [5]: http://search.cpan.org/dist/Catalyst-Plugin-Session
 [6]: http://search.cpan.org/dist/Catalyst-Plugin-Session-State-URI
 [7]: http://search.cpan.org/dist/Catalyst-Plugin-Session-AsObject
 [8]: http://search.cpan.org/dist/Catalyst-Plugin-AuthenCookie
 [9]: http://search.cpan.org/dist/Catalyst-Plugin-Authentication

## Comments

### Comment by Zbigniew Lukasiak on 2009-07-27 14:42:19 -0500
So for displaying errors in a form after a POST you put them on the session object, redirect to a GET request (with the session in the URI) and retrieve them there? Is that correct?

### Comment by Dave Rolsky on 2009-07-27 14:58:10 -0500
Zbigniew, yes, that is exactly how I do it.

### Comment by Pedro Melo on 2009-07-27 16:36:16 -0500
Hi,

apart of having all of that nicely wrapped in Catalyst:: classes, you are not alone. I&#8217;ve been using most of what you do over the years on many sites. The redirect-after-non-get was one of the first things I started doing, much cleaner code.

Moving to REST is a more recent undertaking, mostly inspired by O&#8217;Reilly book about RESTfull interfaces.

Nice article.

### Comment by Dave Rolsky on 2009-07-27 18:05:02 -0500
Pedro,

I didn&#8217;t think I was necessarily alone, but the style I describe is not universally accepted either. I&#8217;ve seen all too many webapps that still don&#8217;t redirect after a POST, and it still drives me nuts.

I think the way I use sessions, and the reasoning behind using an authentication cookie, are a little more unusual than the redirect after POST decision.

### Comment by Vince Veselosky on 2009-08-01 10:20:16 -0500
Dave,

Sorry I could not get to this until the weekend. This is a great article, singing the same Gospel I have been spreading at my company.

I especially find your approach to sessions interesting. In fact, I would not describe this as a &#8220;session&#8221; at all. I would describe it as creating a new (temporary) resource and then redirecting to that resource, which is perfectly RESTful.

Also, I don&#8217;t believe cookie-based authentication is a violation of REST constraints (e.g. it requires no server state), it just isn&#8217;t compliant with the HTTP spec. But I agree with you, it&#8217;s the &#8220;right&#8221; thing to do, and it&#8217;s what I recommend to others, too. 

Possibly the only point where I disagree with you is a relatively small one related to form submissions. I too have developed the pattern of redirecting successful POST to a new URI to indicate success. However, when the POST does not succeed, I always return the form, repopulated, with a 400 status code as the HTTP spec indicates, rather than redirect to the same form. 

I have never had any practical problems with this procedure, and have seen at least one significant benefit. A successful POST results in a 302, 200 series of responses. If a failure also does this, then automated software cannot know the POST failed without parsing the response document (and knowing how to look for errors in it). 

OTOH, if a POST failure returns 400, it is easy for my web robot to tell that its POST failed and trigger an exception. Web browsers handle this pattern just as well, and the client response is marginally faster on errors because the browser does not have to follow the redirect.

I&#8217;m still using Mason solo for my production apps, so I have not had a chance to try out your Catalyst modules, but I&#8217;ll definitely give your &#8220;minimal session&#8221; concept a try in my next project, it seems much smarter than what I&#8217;m currently doing.

Thanks for sharing this with us, you&#8217;re helping to make the world smarter! :)

-Vince

### Comment by Larry Leszczynski on 2009-08-15 20:49:45 -0500
Vince said:

> I too have developed the pattern of redirecting successful POST to a new URI to indicate success. However, when the POST does not succeed, I always return the form, repopulated, with a 400 status code as the HTTP spec indicates, rather than redirect to the same form. 

I like the idea of returning the user to the still-populated form in case of error. But I think your approach takes too much liberty with the 400 error code, which is intended to mean that the client sent a malformed HTTP request, not that the user e.g. left a form field empty or mistyped their username.

Dave, how do you handle form repopulation in that case (if at all)?

### Comment by Dave Rolsky on 2009-08-15 20:53:03 -0500
Larry, in what case?

In my apps, form repopulation is always done by sticking the form data in the short-lived session, then redirecting to the form&#8217;s URI and putting the session id in the URI, something like &#8220;/user/login_form/-/long-session-id&#8221;.

I have a Mason filter component that I wrap all my forms in which looks for appropriate form data in the session and uses HTML::FillInForm + my own home brewed bits to repopulate the form, mark fields which had errors, etc.

### Comment by Larry Leszczynski on 2009-08-19 08:44:46 -0500
Dave said:

> Larry, in what case?

In the case of e.g. a user fills out a form but leaves one field blank, but you want to retain the other info they supplied. Which is handled well by what you describe.

Larry