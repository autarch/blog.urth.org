---
title: Compact “with-ish” statement for CoffeeScript
author: Dave Rolsky
type: post
date: 2011-12-11T10:57:41+00:00
url: /2011/12/11/compact-with-ish-statement-for-coffeescript/
categories:
  - Uncategorized

---
I&#8217;ve been playing with [CoffeeScript][1] (CS) lately, and I really like it. JavaScript (JS) is full of annoyances that make coding more tedious and error-prone that it needs to be. CofeeScript does a good job of fixing many of those annoyances.

CS doesn&#8217;t provide anything like JS&#8217;s `with` block. That makes sense, because `with` in JS is completely insane and broken. But sometimes you want to be able to say &#8220;given this object, call a bunch of methods on it&#8221;. You can of course write something like this:

<pre class="lang:javascript">foo = new Foo
foo.bar(42)
foo.baz(84, "x")
</pre>

Or in CS:

<pre class="highlight:false">foo = new Foo
foo.bar 42
foo.baz 84, "x"
</pre>

If you want a more Dee Ess Ell style, you can reach for this in JS:

<pre class="lang:javascript">foo = new Foo
with (foo) {
    bar(42)
    baz(84, "x")
}
</pre>

In typical JS fashion, `with` is a nightmare. Douglas Crockford has a [good write up on why it&#8217;s broken][2].

The other alternative in JS is to use method chaining:

<pre class="lang:javascript">foo = new Foo
foo
    .bar(42)
    .baz(84, "x")
</pre>

Unfortunately, because of CS&#8217;s parsing rules, method chaining is kind of fugly, requiring explicit parentheses. Also, method chaining requires explicit cooperation from the methods being called.

So I came up with this alternative in CS:

<pre class="highlight:false">foo = new Foo
(->
  @bar 42
  @baz 84, "x"
).call foo
</pre>

This creates an anonymous function and then invokes the `Function.call` method on it. The `call` method takes its first argument and makes it the method&#8217;s invocant, so inside the function `this` is now equal to that argument (`foo` in the example above).

I think this syntax could make for a nice alternative to method chaining when you want to call methods on the same object repeatedly. The only thing I don&#8217;t like is that the invocant ends up at the end of the block. I really wish I could write something like this:

<pre class="highlight:false">foo = new Foo
using foo ->
  @bar 42
  @baz 84, "x"
</pre>

I could get pretty close by defining my own `using` function:

<pre class="highlight:false">using = (invocant, method) -> method.call invocant

foo = new Foo
using foo, ->
  @bar 42
  @baz 84, "x"
</pre>

But then I need to have that function around everywhere I want to use it, which is a hassle. For now, I think I&#8217;ll try using the `(anon).call` version and see how I like it.

 [1]: http://jashkenas.github.com/coffee-script
 [2]: http://www.yuiblog.com/blog/2006/04/11/with-statement-considered-harmful/

## Comments

### Comment by Aristotle Pagaltzis on 2011-12-11 14:59:39 -0600
The cure is far worse than the disease in this case, if you ask me.

### Comment by Dave Rolsky on 2011-12-11 15:07:55 -0600
@Aristotle: Care to elaborate? I think the anon function version is fairly clear, and if it was an idiom you used repeatedly, it&#8217;d be easy enough to read.

Think of Perl&#8217;s map or grep. They&#8217;re weird at first, and I&#8217;ve even heard some folks say that we shouldn&#8217;t use them because they&#8217;re too confusing to noobs, but experienced Perl programmers will find that map or grep is much easier to read and write for many uses.

### Comment by Aristotle Pagaltzis on 2011-12-12 01:23:32 -0600
It’s not about understandability but about æsthetics. The punctuation pile-up looks awful and nothing much lines up – a visual jumble. With longer blocks that would be less of an issue, but those are inadvisable for another reason: the reader is forced to mentally keep the delimitation open while reading. (To use your example, think of how readability suffers as you stretch a “`map`” block across a few lines, and then even more so as you stretch it further. C.f. _The Awful German Language_.)

The version with “`using`” OTOH is entirely tolerable.