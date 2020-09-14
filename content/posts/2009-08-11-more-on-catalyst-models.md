---
title: More on Catalyst Models
author: Dave Rolsky
type: post
date: 2009-08-11T10:58:35+00:00
url: /2009/08/11/more-on-catalyst-models/
categories:
  - Uncategorized

---
[Marcus Ramberg responded to my post][1] on [How I Use Catalyst][2], and I&#8217;d like to respond to a few points he made.

Marcus wrote:

> _I disagree that $schema->resultset(&#8216;Person&#8217;) is a significant improvement on $c->model(&#8216;DBIC::Person&#8217;)._

Me too! I don&#8217;t think the former is a _significant_ improvement over the latter. They are, after all, more or less the same. The one big problem is that the latter version uses a nonexisting `DBIC::Person` namespace. There are no `DBIC` classes anywhere in the app. I think the model version would be much better if it was just written as `$c->model('Person')`.

Marcus also points out that the model layer lets you configure multiple models and access them in a unified way. That is indeed nice. Unfortunately, that has the problem of tying yourself to Catalyst&#8217;s config, which is problematic for reasons I already described. Similarly, the unified layer _only_ exists inside Catalyst, which is really only accessible during a web request. So now we&#8217;re stuck with recreating all of this if we need to access our models outside of a web request.

The long-term Catalyst roadmap includes the much-talked-about application/context split. Once this is done, presumably you will be able to access the application, which I take to mean config and models, outside of the context (of a web request). Once that is in place, I think many of my objections will go away. Unfortunately, for now I have to write my own application/context splitting code.

 [1]: http://marcus.nordaaker.com/model-adaptors-for-catalyst/
 [2]: /2009/08/02/how-i-use-catalyst/