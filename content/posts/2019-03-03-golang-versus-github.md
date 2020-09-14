---
title: Golang Versus GitHub
author: Dave Rolsky
type: post
date: 2019-03-03T19:01:18+00:00
url: /2019/03/03/golang-versus-github/
categories:
  - Uncategorized

---
This is a story of how Go&#8217;s package management system and GitHub fought a war, and how the war was lost (by me).

Go references packages by a repository name, so if you want to important a package you write something like `import "github.com/volatiletech/sqlboiler/queries/qm"`. It&#8217;s simple, right? Yes, it is.

When you want to submit a proposed patch to a repo on GitHub, you fork, make a new branch (because you&#8217;re not a monster who makes a PR from master), and then you submit a PR. When you fork you copy the repo to a new user/org. So when I wanted to make some tweaks to sqlboiler for $work at ActiveState I ended up with a new repo at `github.com/ActiveState/sqlboiler`. It&#8217;s simple, right? Yes, it is.

But wait, I import the code by referring to the repo name. That means if I want to test my local changes in some $work code I have to change the import to use my new forked repo. So in my work code I replace all uses of `import "github.com/volatiletech/sqlboiler/queries/qm"` with `import "github.com/ActiveState/sqlboiler/queries/qm"`. It&#8217;s a little annoying but it&#8217;s just a quick `grep -rl github.com/ActiveState | xargs perl -pi -e 's{github.com/volatiletech/sqlboiler}{github.com/ActiveState/sqlboiler}g'`. It&#8217;s simple, right? Yes, it is.

Wait, no, it&#8217;s **not** simple. Because if you [look inside the `qm` package][1] I&#8217;m importing, you&#8217;ll see that it imports `github.com/volatiletech/sqlboiler/queries/qmhelper`. That means that even though I might be importing my forked repo, that forked repo is still importing from the original repo. So if I need to change both the `qm` and `qmhelper` packages, my changed `qm` will not see my changes to `qmhelper`. So I need to go into my forked repo and change all `volatiletech/sqlboiler` references to `ActiveState/sqlboiler`!

And I need to **commit and push** that change to GitHub because we&#8217;re using dep for package management, which will always fetch the referenced code from its repo. I can point dep at a branch, which is great, but I need to point it at a branch where I&#8217;ve renamed all those imports or else it will end up vendoring both my fork and the original repo for sqlboiler.

So now I have a branch that has all my bug fixes **plus** import renaming. But I cannot submit this branch as a PR. The maintainer doesn&#8217;t want to change all the imports. I only had to do that so I could use my forked repo locally. So now I have to maintain one branch per bug fix plus an integration branch that includes all my bug fixes **and** the import renaming.

I&#8217;ve been using Go for several years now, and the longer I use it the less I like it. It&#8217;s &#8220;simple&#8221; design choices consistently cause me pain because they&#8217;re too simple. I think there&#8217;s a good reason that every other language&#8217;s package system has a layer of indirection between the name of the import and the loading of that code.

Will Go modules fix this? Not as far as I can tell. The module names are still repo names, which means I&#8217;d have to do the same renaming dance if a repo&#8217;s module imports another module from the same repo.

And that&#8217;s the story of the war between Go and GitHub, where the only loser was me and anybody else trying to test their fixes to someone else&#8217;s Go package.

 [1]: https://github.com/volatiletech/sqlboiler/blob/master/queries/qm/query_mods.go

## Comments

### Comment by Greg on 2019-03-03 17:51:03 -0600
Go modules provides a replace directive that solves this, <a href="https://github.com/golang/go/wiki/Modules#when-should-i-use-the-replace-directive" rel="nofollow ugc">https://github.com/golang/go/wiki/Modules#when-should-i-use-the-replace-directive</a>.

### Comment by Greg on 2019-03-03 17:53:13 -0600
Actually, dep also provides this functionality with a &#8220;source&#8221; option.

### Comment by Dave Rolsky on 2019-03-03 19:15:25 -0600
I knew about dep&#8217;s source option but I don&#8217;t think it will handle the naming issue. I&#8217;d still have to change the actual import statements. It looks like go module replace directive does take care of the entire problem though, which is good.

### Comment by Gautam Dey on 2019-03-03 21:49:10 -0600
The best way to do this I have found is to use a new remote that points to your repository. 

On github fork like usual. 

On you computer go to the original repo that has been checked out. 

In that repo add a new remote that points to your repository. 

Branch and make changes as usual. 

But now push the branch to the remote instread of the origin. 

No need to change import paths.

### Comment by Dave Rolsky on 2019-03-03 22:00:30 -0600
That&#8217;s a clever solution!

### Comment by Kjell on 2019-03-04 00:53:32 -0600
That is a good solution. Here is giteas docs regarding forking

<a href="https://docs.gitea.io/en-us/hacking-on-gitea/" rel="nofollow ugc">https://docs.gitea.io/en-us/hacking-on-gitea/</a>

### Comment by Matthew Persico on 2019-03-04 16:37:47 -0600
The best thing to do is to STOP USING GITHUB AS A FREAKING PACKAGING SYSTEM!. Not directed at you, obviously, but really, can we teach all these whipper snappers that the Internet should be used as a REFERENCE, not as a resource in the critcal path of execution?

### Comment by Dave Rolsky on 2019-03-04 17:23:36 -0600
Well, yeah, but that&#8217;s Go for you. And I don&#8217;t think Rob Pike or Ken Thompson really qualify as young whippersnappers.