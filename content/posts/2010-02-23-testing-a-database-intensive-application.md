---
title: Testing a Database-Intensive Application
author: Dave Rolsky
type: post
date: 2010-02-23T10:08:48+00:00
url: /2010/02/23/testing-a-database-intensive-application/
---
If you've been bitten by the testing bug, you've surely encountered the problem of testing a database-intensive application. The problem this presents isn't specific to SQL databases, nor is it just a database problem. Any data-driven application can be hard to test, regardless of how that data is stored and retrieved.

The problem is that in order to test your code, you need data that at least passably resembles data that the app would work with in reality. With a complex schema, that can be a lot of data spread out across many tables. I often find that trying to test each class in isolation becomes very difficult, since the data is not confined to one class.

For example, the app I'm working on now is a wiki. I'm trying to test the Page class, but that involves interactions with many tables. Pages have revisions, they have links to other pages, to files, and to not-yet-created pages. Pages also belong to a wiki, and are created by a user. To test page creation, I need to already have a wiki to add the page to, and a user to create the page.

There are a various solutions to this problem, all of which suck in different ways.

You can try mocking out the database entirely. I've used [DBD::Mock][1] for this, but I've never been happy with it. DBD::Mock has one of the most difficult to use APIs I've ever encountered. Also, DBD::Mock doesn't really solve the fundamental problem. I _still_ have to seed all the related data for a page. I'd even go so far as to say that DBD::Mock makes things worse. Because inserts don't actually go anywhere, I have to re-seed the mock handle for each test of a `SELECT`, and since a single method may make multiple `SELECT` calls, I have to work out in advance what each method will select and seed all the data in the right order!

My experience with DBD::Mock has largely been that the test code becomes so complex and fragile that maintaining it becomes a huge hassle. The test files become so full of setup and seeding that the actual tests are lost.

I wrote [Fey::ORM::Mock][2] to help deal with this, but it only goes so far. It partially solves the problem with DBD::Mock's API, but I still have to manage the data seeding, and that is still fragile and complicated.

The other option is to just use a real DBMS in your tests. This has the advantage of actually working like the application. It also helps expose bugs in my schema definition, and lets me test triggers, foreign keys, and so on. This approach has several huge downsides, though. I have to manage (re-)creating the schema each time the tests run, and it will be much harder for others to run my tests on their systems. Also, running the tests can be rather slow.

For the [app I'm working on][3] I've decided to mostly go the real DBMS route. At least this way the tests will be very useful to _me_, and anyone else seriously hacking on the application. I can isolate the minimal data seeding in a helper module, and the test files themselves will be largely free of cruft. Making it easier to write tests also means that I'll write more of them. When I was using DBD::Mock, I found myself avoiding testing simply because it was such a hassle!

Some people might want to point out fixtures as a solution. I know about those, and that's basically what I'm using now, except that there's only one fixture for now, a minimally populated database. And of course, fixtures still don't fix the problems that come with the tests needing to talk to a real DBMS.

I _am_ going to make sure that tests which don't hit the database at all can be run without connecting to a DBMS. That way, at least a subset of the tests can be run everywhere.

Are there any better solutions? I often feel like programming involves spending an inordinate amount of time solving non-essential problems. Where's my silver bullet?

 [1]: http://search.cpan.org/dist/DBD-Mock
 [2]: http://search.cpan.org/dist/Fey-ORM-Mock
 [3]: http://hg.urth.org/hg/Silki

## Comments

**adamkennedybackup, on 2010-02-23 10:58, said:**  
I look after the testing methodology for our application, which has 130 tables, 150gig of data, a dozen Oracle PL/SQL packages, and a bunch of other errata.

Mocking at this scale is basically impossible.

Our alternative approach has been to allow each test to essentially data-mine a copy of the production database to identify the class of rows or objects that are suitable for the test, and then select one (or ten, or a hundred) at random to use in the test script.

If you destroy the row in the process is isn't a huge deal, because the next time through they won't match any more, and you'll select another one (or ten, or a hundred).

**publius-ovidius, on 2010-02-23 11:57, said:**  
That's why I take a different approach. I'm using PostgreSQL for a personal project and <tt>Test::Class::Most</tt> to drive the test suite. I have a testing package [that handles my test database for me](http://blogs.perl.org/users/ovid/2010/02/sanity-checking-my-postgresql-tests.html). I never have to think about it. I call the constructor and I'm guaranteed to have a clean database every time because it truncates every changed table. I've also tried "mocking up database interaction" and it's been far too painful for me.

In fact, with <tt>Test::Class::Most</tt>, my base test class looks (sort of) like:

<tt>package Test::Class::Veure;<br /> use Test::Class::Most;<br /> use Testing::Veure;</p> 

<p>
  sub setup : Tests(setup) {<br /> &nbsp;&nbsp;&nbsp;&nbsp;my $test = shift;<br /> &nbsp;&nbsp;&nbsp;&nbsp;$test->{__veure__} = Testing::Veure->new;<br /> }</tt>
</p>

<p>
  My actual test classes then just look like this:
</p>

<p>
  <tt>package Tests::For::Veure::Schema::Result::User;<br /> use Test::Class::Most parent => 'Test::Class::Veure';</p> 
  
  <p>
    sub start_testing : Tests {<br /> &nbsp;&nbsp;&nbsp;&nbsp;# bunch 'o tests<br /> }</tt>
  </p>
  
  <p>
    With that, I get all of my tests functions, strict, warnings, and a clean database every test. So far, testing has been an absolute breeze with this strategy. So far I've worked on many large code bases and I've yet to find one which extensively mocks up the database interaction. It takes more time to get the core db testing class working, but it's worth the effort.
  </p>
  
  <p>
    Cheers,<br /> Ovid
  </p>

**groditi, on 2010-02-23 13:16, said:**  
I have run into this issue many a times too. Generally, I am one for the fixtures camp, but my solution has so far been slightly mixed, allow me to explain:

I maintain a couple of different tests. The most basic of the tests usually target a SQLite database, if possible. While limited, SQLite does support a fair number of features which allow for unit-testing without the necessity of a live DBMS.

Additionally, I keep tests that need a live DBMS to run, but those are skipped if certain ENV variables are not set. It allows me to run the test suite anywhere without having to worry about DBMS settings, and if I \*do\* want to run those tests, well, a couple of '$ export TESTDB_DSB=...' calls are really not a big deal.

I am as big of a proponent of testing as anyone else, but we keep testing, staging and production environments for a reason, and while it's nice to aim for all testing to be automated, there's something to be said for running an application on a production-like environment and actually \*using\* it to make sure it all works well. That way, any time you find an issue by hand, you can just make a new test to cover the case. 

I guess it comes down to having different screwdrivers for different size screws

**Dave Rolsky, on 2010-02-23 14:03, said:**  
@groditi: I'm all for QA and staging too. Automated testing is a great first step, but it's not even close to sufficient for ensuring a good, usable, does-what-it's-supposed-to application.

**Jon Jensen, on 2010-02-23 14:53, said:**  
Over time I've decided it makes no sense to use mock data for most of the things I do. Instead, I always use a complete copy of the production database for all development and testing.

With large databases, that can be a pain, of course. What I've done is to make atomic filesystem snapshots of the database using LVM2, NetApp, etc., and then build writeable snapshots based on the snapshot which the development or test environment uses.

That's fast and doesn't use much disk space, since only the changes take up room. It's easy to refresh once you automate it, so you can keep your test database current. And there's no more guessing about how things will work against the production database, because in most ways except hardware, it _is_ the production database. (That includes table and index bloat, statistics, everything, which you don't get when doing an SQL-level dump & import.)

With some co-workers and a few of our clients we have an open source project called [DevCamps](http://www.devcamps.org/) that's centered on this idea of using the "real deal" in development and testing. It's been working well for us.

I hate to sound like an infomercial here, but for our use cases, the problem you describe is solved and what a relief it's been.

**Ethan Rowe, on 2010-02-23 15:40, said:**  
Jon Jensen: the snapshot of production notion has some delightful benefits (as somebody who has worked with you on this stuff), but it flies in the face of the conventional TDD practice (when working with a real DB as opposed to mock DB objects) of starting every test against a pristine, known test DB state (typically the bare schema populated with fixtures).

For one of our clients, some years back, I dealt with this issue and asked the question "how do I do TDD in this environment that has devcamps (meaning copies of production DB for development) but no test database?" My pragmatic answer is probably highly offensive to TDD traditionalists, but nevertheless worked out very well:  
* for read-oriented tests, implement logic used by the test to find test candidate data in the existing data; the data is coming from production and in this case had thousands upon thousands of products, orders, users, etc. from which to choose; skip the test cases for which candidate data doesn't exist, but for a real production app with a significant DB, you'll find candidate data.  
* for write-oriented tests, I accepted that I would write data to the database and that I Did Not Care. Craft the keys for that data to be specific to the running of the test, and move on.

There are trade-offs with this approach, obviously, and it's quite different from the usual. But from a pragmatic standpoint it worked very well, and it means not dealing with fixtures, making up junk data, etc. You're always working with the real deal, which for a real, long-lived application is hard to beat.