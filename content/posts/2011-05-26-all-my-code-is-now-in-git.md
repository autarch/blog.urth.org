---
title: All My Code is Now in Git
author: Dave Rolsky
type: post
date: 2011-05-26T17:12:42+00:00
url: /2011/05/26/all-my-code-is-now-in-git/
---
Yesterday I converted all of my (many) Mercurial repos over to [Git][1]. The reason for this has very little to do with my preference. I've used both hg and git quite a bit over the past few years, and both are quite good. However, the (FOSS) Perl community as a whole seems to have settled on git, and people complained about having to use hg with my code.

Setting up git reminded me of why I chose hg a few years back. I really like how hg uses http as its native protocol. Setting up repo browsing and remote access is fairly trivial. In particular, you can configure remote access using standard http auth configuration. Since I already had apache running on my server, and I already knew how to use htpasswd2, this was simple.

Git, on the other hand, really prefers ssh, so I ended up setting up [gitolite][2] for access control and [Gitalist][3]. This was more work than setting up hg was.

On the plus side, gitolite is a really nice tool. It provides easy integration with git-daemon, automatic remote repo creation, and easy to manage access control. The downside of gitolite is that it's possible to push a change to the config file that locks yourself out of gitolite! Ouch. This is probably recoverable, but I ended up just wiping my gitolite install out and trying again.

Gitalist is leaps and bounds nicer than gitweb or hgweb, both of which looks like "an app made by hackers". Gitalist is really nice looking, and it's a pleasure to use. However, if you're not familiar with how Catalyst apps work, it's probably not that simple to set up.

Overall, here's my list of plusses and minuses for both hg and git:

Git:

  * + Gitalist and gitolite beat anything available for hg
  * - You really need something like gitolite to manage access control if you have lots of repos
  * + The gitg program is way nicer than hgk (gah, Tk)
  * - git's UI (it's command set, basically) can be really weird
  * + git is infinitely flexible (rebase, squash, amend, ...)
  * - git is infinitely flexible (rebase, squash, amend, ...)

Hg:

  * + Much saner UI - I think hg is just better thought out
  * - Having two types of branches really isn't helpful - pick one, please
  * + Hg's help/docs is much better. The git docs seem to present things in an entirely random order, instead of helping you do learn common operations first. Compare "hg help pull" to "git help pull" some time.

Both are excellent tools, but for Perl work it's probably best to just choose the one "everyone" is already using.

 [1]: http://git.urth.org
 [2]: https://github.com/sitaramc/gitolite
 [3]: http://www.gitalist.com/

## Comments

**Carey, on 2011-05-26 23:14, said:**  
I think you're right that the Perl world seems to be crystallizing around Git, even though I too prefer the Mercurial command set. Have you considered using hg-git for interop? You could have public git repos but continue to use hg privately. I wonder how well it works in actual practice. Conceptually it seems like they would be quite compatible, but maybe some serious problems would emerge in actual use.

**Dave Rolsky, on 2011-05-26 23:22, said:**  
@Carey: I already use git a lot for other Perl projects (Moose and Catalyst are both in git) so I'm fairly comfortable with git at this point. Really, it's easier now to only use git, it's less to remember overall.

**jnareb, on 2011-05-27 06:04, said:**  
> Setting up git reminded me of why I chose hg a few years back. I really like how hg uses http as its native protocol. Setting up repo browsing and remote access is fairly trivial. In particular, you can configure remote access using standard http auth configuration. Since I already had apache running on my server, and I already knew how to use htpasswd2, this was simple. 

When using "dumb" HTTPS transport, git uses WebDAV and standard HTTP access control... but "dumb" (walker) HTTP transport is quite inefficient.

I don't know how access control is managed for "smart" HTTP transport (i.e. the one using git-http-backend).



> + Much saner UI - I think hg is just better _thought out_ 

Well, truth to be said much of Git UI was grown rather than designed; Git is an example of application which was build bottoms-up, starting from simple model of/for repository... and unfortunately it shows in some places as hard edges.

**Mark Dominus, on 2011-05-27 18:24, said:**  
Have you seen this? <http://t-a-w.blogspot.com/2010/02/could-mercurial-please-die-already.html>

"Neither git nor Mercurial are sufficiently better from the other to win on merits alone, and there's really no point in having them both.

"Right now git is significantly more popular. So what should happen? Mercurial should die."

**Dave Rolsky, on 2011-05-27 19:22, said:**  
@mjd: I think things like hg-git git-hg could potentially make this less of an issue. Also, just because the two are equivalent-ish now doesn't mean they will always be so. It seems little too soon to ask for one or the other to go away.

**jnareb, on 2011-05-28 04:44, said:**  
@mjd: We have KDE, Gnome, XFCE. We have Eclipse and NetBeans. We have Emacs and Vim. Why shouldn't we have Git, Mercurial and Bazaar?

**Tomáš Znamenáček, on 2011-05-28 06:10, said:**  
Did you consider using GitHub? If yes, what were the arguments against it?

**Benoit, on 2011-05-28 07:05, said:**  
Just a side comment: hgk is ugly and unmaintained since a very long time (we might even remove it from the mercurial repo). People usually use hgtk (tortoisehg, gtk version), or the new version of tortoisehg (uses qt, supposedly much better on OSX).

I never used gitg so I don't know how it compares, but listing hgk as a minus is not very fair ;)

**Dave Rolsky, on 2011-05-28 09:55, said:**  
@Tomáš: I didn't really consider github because I like to host my own stuff. I'm just a little paranoid, I guess.

@Benoit: I didn't realize there were better alternatives to hgk. The gitg program is available as an ubuntu package, hgtk isn't, which is probably why I didn't notice it.

**curtis, on 2011-05-30 22:34, said:**  
Personally, I just moved my code to Mercurial myself from svn (as opposed to git.) [http://hg.curtisjewell.name is where my stuff lives.]

Yes, I like to host, too (and I'm going to write myself a user/repository-maintenance tool to help me in about a week.) [http://hg.curtisjewell.name is where my stuff lives.]

The big reason I chose Hg? I work on Windows for 90+% of my Perl projects, and Git on Windows is just painful, IMO! Yes, I use Git for other people's projects, but I deliberately keep it out of my path so that it's version of Perl does not mess my system up, and I only keep it on one machine!

When git becomes as good on Windows as it is everywhere else (meaning it does not need either Cygwin or its own version of Perl named 'perl' to come along with in order to be sane) THEN I'll think about converting over.

To @mjd specifically: monocultures are BAD. That's how we got Windows and its pains! :) (I shouldn't complain, I work in it.)

**Mark Dominus, on 2011-06-01 12:01, said:**  
Please RTFA.

**asjo.koldfront.dk, on 2011-06-20 11:37, said:**  
How does Gitalist compare to [cgit](http://hjemli.net/git/cgit/)? I find cgit nicer than gitweb.

(I tried the Example tab on the Gitalist website, but it times out for me currently.)