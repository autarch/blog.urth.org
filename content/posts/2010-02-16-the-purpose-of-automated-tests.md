---
title: The Purpose of Automated Tests
author: Dave Rolsky
type: post
date: 2010-02-16T10:54:53+00:00
url: /2010/02/16/the-purpose-of-automated-tests/
categories:
  - Uncategorized

---
Recently, there was a [question on stackoverflow][1] that asked whether or not one should test that Moose generates accessors correctly.

Here&#8217;s an example class:

<pre class="lang:perl">package Process;

use Moose;
has pid => (
    is       => 'ro',
    isa      => 'Int',
    required => 1,
);
has stdout => (
    is  => 'rw',
    isa => 'FileHandle',
);
</pre>

Given that class definition, is there any value to writing tests like this?

<pre class="lang:perl">can_ok( Process, 'new' );
can_ok( Process, 'pid' );
can_ok( Process, 'stdout' );
throws_ok { Process->new() } qr/.../, 'Process requires a pid';
</pre>

Let&#8217;s look at why automated tests are useful.

First, they give us some assurance that the code we wrote does what we expect.

Second, tests protect us from breaking code as we change it. As we refactor, fix bugs, or add new features, we want to make sure that all the existing code continues to work.

Third, the tests can provide some hints to future readers of our code about the APIs of the code base.

So back to our original question, do we need to test Moose-generated code?

The tests seen above add absolutely nothing that isn&#8217;t already tested by Moose itself.

If the tests don&#8217;t test anything new, then they can&#8217;t be giving us any assurance about our code. Instead, they&#8217;re giving us assurance about Moose itself.

Let&#8217;s assume that Moose is itself well-tested. If it isn&#8217;t, why are you using it? There is no point in adopting a dependency on fragile code that you don&#8217;t trust. If you want to improve Moose&#8217;s reliability, the way to do that is by _working on Moose itself_, not by testing Moose in your application&#8217;s test suite.

Do these tests protect us from breaking code? Not really. If we change the Process class so that it no longer has the `stdout` attribute, the test will fail. But if we made that change, surely it was intentional. So now our tests are failing because we made an intentional change.

But what if other code in our code base expects the `stdout` attribute to exist? As long as that code is tested, we will find this problem quickly enough. If the `stdout` attribute is only ever referenced in the test up above, then what purpose does it serve?

Finally, the test above provides no guidance to future readers. The code in `Process` package provides more documentation than the test code, and if the module also has POD, that will provide even more documentation. The test doesn&#8217;t show how the code is _used_, it just provides another way to describe what the module _is_, a way that&#8217;s inferior to the Moose-based declarations or POD.

However, don&#8217;t confuse the tests above with testing code that _you_ write. For example, if you create a new type with a custom constraint and coercion, you should definitely test that type. The Moose test suite obviously doesn&#8217;t test your specific type, it just tests that new types can be created.

So the answer is no, don&#8217;t bother with tests like the ones above. Test new code you create, not Moose is doing what you asked it to do.

 [1]: http://stackoverflow.com/questions/2269478/how-much-do-i-need-to-test-moose-and-moosexfollowpbp-generated-methods/2270518

## Comments

### Comment by https://me.yahoo.com/moleculasdevida#fea03 on 2010-02-16 17:14:22 -0600
Dear Dave,

Thank you very much for your blog. I am a big fan of Moose. I apologize if my question seemed to cast doubt on Moose&#8217;s reliability. I was just trying to figure out how to do Test-Driven-Development (TDD) with Moose. 

At least one TDD tutorial that I came across showed creating &#8220;can\_ok&#8221; tests for Moose-generated methods. I believe this was because it was part of the &#8220;Red-Green-Refactor&#8221; rhythm of TDD. They add the &#8220;can\_ok&#8221; test for an attribute&#8217;s accessor/mutator before creating the attribute itself. They aren&#8217;t testing Moose so much as they are implementing the next part of their code.

However, I can also see that having &#8220;can_ok&#8221; tests for Moose-generated methods in an automated test suite would needlessly take up the installing user&#8217;s time. More regrettably, it could also unintentionally imply that Moose were somehow unreliable. 

As a compromise, I would suggest that those that feel that such tests are necessary in order to do TDD, should at least make them &#8220;author-only&#8221; before releasing their code. Refactoring them away as development progresses would be even better.

Thank you for your work on Moose and for helping me (and others) understand this issue more clearly.

Sincerely,  
Christopher Bottoms (molecules)

p.s. I changed the title of the question to emphasize TDD more than Moose itself.

### Comment by Dave Rolsky on 2010-02-16 18:28:28 -0600
Christopher, there&#8217;s nothing to apologize for.

Your question is one that I think is probably shared by many others. I was just trying to answer it in detail here on my blog.

### Comment by schwern.myopenid.com on 2010-02-16 21:04:22 -0600
While I agree that those automated tests are of low value, there&#8217;s a few things you say that throw red flags.

&#8220;The tests seen above add absolutely nothing that isn&#8217;t already tested by Moose itself.&#8221;

Moose does not test that you declared the right attributes. And should you switch away from Moose, you want to guarantee that new() still blows up nicely.

&#8220;But if we made that change, surely it was intentional.&#8221;

Famous last words. Especially on projects that don&#8217;t do a good job of recording what&#8217;s public and what&#8217;s private. Your argument that something else in the code or test suite (assuming good coverage) is going to reference that method is better.

That said, I have found from experience that the rest of your argument holds up. Tests full of can_ok()s don&#8217;t offer much value, and they can prove harmful by making it \*look\* like you have a test suite. When they may prove useful is when you have poor coverage and just need to get something in place.

### Comment by Dave Rolsky on 2010-02-16 21:22:52 -0600
When I said that the change (to remove an attribute) would be intentional, what I meant was that there are two cases.

One, you really did remove it on purpose. In that case, the fact that this test now fails tells you nothing useful, and time spent &#8220;fixing&#8221; it is time wasted. You already need to go change any code that uses this API anyway.

If you didn&#8217;t do it on purpose, then if you have useful tests then something is actually using this attribute.

If you don&#8217;t have useful tests I&#8217;d suggest working on writing those first!

### Comment by Sid Burn on 2010-02-18 07:31:53 -0600
I can&#8217;t agree with Dave said.

If you do a test with &#8220;can_ok()&#8221; you don&#8217;t test if Moose set up the subroutine correctly, you test if your class has the right and correct interface.

Saying you don&#8217;t need &#8220;can_ok()&#8221; because you should trust Moose that it does the right thing is just wrong. With this explanation you also can say that you don&#8217;t need to test a self written &#8220;sub foo {}&#8221; because you should trust Perl that it sets up the function correctly. 

All these tests don&#8217;t test the implementation if a subroutine/method was created it test the interface. And Moose or Perl don&#8217;t know anything how your interface sould look like.

And you should even test if an attribute does only allow the value you want, if it does coercion etc.

All these tests are not there to test the implementation, these tests are there to tests if your class that you have written does the correct thing that you want. If i delete &#8220;coerce => 1&#8221; accidentally then the test should fail. Then i knew if i introduce a new bug. And if i really wanted this change, then i need to change the test, but i knew then i break backward compatibility.

Also these test are really important, because if i just have a class i didn&#8217;t knew if an attribute is correct defined. I only knew it when it is documented or when a test is written for it.

Test should reduce the fear to change something. If someone don&#8217;t test it and someone can just delete a method without breaking the test suite then the test suite is worthless.

### Comment by https://me.yahoo.com/moleculasdevida#fea03 on 2010-02-22 10:54:56 -0600
As an update on my previous comment, I&#8217;ve come to the following conclusions:

1. I totally agree that Moose itself doesn&#8217;t need any extra testing. It is totally pointless for someone to test their dependencies.

2. At the same time, as a programmer new to Test-Driven Development, I feel much more comfortable explicitly testing my interface. I&#8217;m not testing Moose per se; I&#8217;m simply testing that _I, myself,_ correctly asked Moose to do what I wanted it to do.

Thanks again for your blog and comments. You have really helped me understand the issue. 

And I can&#8217;t thank you enough for your many hours of hard work on Moose.

### Comment by Szymon Guz on 2010-04-26 05:28:45 -0500
Well, that&#8217;s true that Moose doesn&#8217;t need more testing. If I were to test Moose then I&#8217;d add the tests into some Moose package, not mine.

But when I create my own package, I have to test what I wrote, and maybe creating the pid field as required is a good idea, but maybe not. Why not to test it even if it is some code used by Moose, or anything else?

What&#8217;s more using TDD means writing tests before code. I create some tests for the &#8216;pid&#8217; field and later create the field itself. So due to TDD the code has to be tested although it is some code using Moose.