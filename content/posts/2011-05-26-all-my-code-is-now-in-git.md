---
title: All My Code is Now in Git
author: Dave Rolsky
type: post
date: 2011-05-26T17:12:42+00:00
url: /2011/05/26/all-my-code-is-now-in-git/
categories:
  - Uncategorized

---
Yesterday I converted all of my (many) Mercurial repos over to [Git][1]. The reason for this has very little to do with my preference. I&#8217;ve used both hg and git quite a bit over the past few years, and both are quite good. However, the (FOSS) Perl community as a whole seems to have settled on git, and people complained about having to use hg with my code.

Setting up git reminded me of why I chose hg a few years back. I really like how hg uses http as its native protocol. Setting up repo browsing and remote access is fairly trivial. In particular, you can configure remote access using standard http auth configuration. Since I already had apache running on my server, and I already knew how to use htpasswd2, this was simple.

Git, on the other hand, really prefers ssh, so I ended up setting up [gitolite][2] for access control and [Gitalist][3]. This was more work than setting up hg was.

On the plus side, gitolite is a really nice tool. It provides easy integration with git-daemon, automatic remote repo creation, and easy to manage access control. The downside of gitolite is that it&#8217;s possible to push a change to the config file that locks yourself out of gitolite! Ouch. This is probably recoverable, but I ended up just wiping my gitolite install out and trying again.

Gitalist is leaps and bounds nicer than gitweb or hgweb, both of which looks like &#8220;an app made by hackers&#8221;. Gitalist is really nice looking, and it&#8217;s a pleasure to use. However, if you&#8217;re not familiar with how Catalyst apps work, it&#8217;s probably not that simple to set up.

Overall, here&#8217;s my list of plusses and minuses for both hg and git:

Git:

  * &#43; Gitalist and gitolite beat anything available for hg
  * &#45; You really need something like gitolite to manage access control if you have lots of repos
  * &#43; The gitg program is way nicer than hgk (gah, Tk)
  * &#45; git&#8217;s UI (it&#8217;s command set, basically) can be really weird
  * &#43; git is infinitely flexible (rebase, squash, amend, &#8230;)
  * &#45; git is infinitely flexible (rebase, squash, amend, &#8230;)

Hg:

  * &#43; Much saner UI &#8211; I think hg is just better thought out
  * &#45; Having two types of branches really isn&#8217;t helpful &#8211; pick one, please
  * &#43; Hg&#8217;s help/docs is much better. The git docs seem to present things in an entirely random order, instead of helping you do learn common operations first. Compare &#8220;hg help pull&#8221; to &#8220;git help pull&#8221; some time.

Both are excellent tools, but for Perl work it&#8217;s probably best to just choose the one &#8220;everyone&#8221; is already using.

 [1]: http://git.urth.org
 [2]: https://github.com/sitaramc/gitolite
 [3]: http://www.gitalist.com/

## Comments

### Comment by Carey on 2011-05-26 23:14:20 -0500
I think you&#8217;re right that the Perl world seems to be crystallizing around Git, even though I too prefer the Mercurial command set. Have you considered using hg-git for interop? You could have public git repos but continue to use hg privately. I wonder how well it works in actual practice. Conceptually it seems like they would be quite compatible, but maybe some serious problems would emerge in actual use.

### Comment by Dave Rolsky on 2011-05-26 23:22:48 -0500
@Carey: I already use git a lot for other Perl projects (Moose and Catalyst are both in git) so I&#8217;m fairly comfortable with git at this point. Really, it&#8217;s easier now to only use git, it&#8217;s less to remember overall.

### Comment by jnareb on 2011-05-27 06:04:46 -0500
> Setting up git reminded me of why I chose hg a few years back. I really like how hg uses http as its native protocol. Setting up repo browsing and remote access is fairly trivial. In particular, you can configure remote access using standard http auth configuration. Since I already had apache running on my server, and I already knew how to use htpasswd2, this was simple. 

When using &#8220;dumb&#8221; HTTPS transport, git uses WebDAV and standard HTTP access control&#8230; but &#8220;dumb&#8221; (walker) HTTP transport is quite inefficient.

I don&#8217;t know how access control is managed for &#8220;smart&#8221; HTTP transport (i.e. the one using git-http-backend).



> + Much saner UI &#8211; I think hg is just better _thought out_ 

Well, truth to be said much of Git UI was grown rather than designed; Git is an example of application which was build bottoms-up, starting from simple model of/for repository&#8230; and unfortunately it shows in some places as hard edges.

### Comment by Mark Dominus on 2011-05-27 18:24:04 -0500
Have you seen this? <a href="http://t-a-w.blogspot.com/2010/02/could-mercurial-please-die-already.html" rel="nofollow ugc">http://t-a-w.blogspot.com/2010/02/could-mercurial-please-die-already.html</a>

&#8220;Neither git nor Mercurial are sufficiently better from the other to win on merits alone, and there&#8217;s really no point in having them both.

&#8220;Right now git is significantly more popular. So what should happen? Mercurial should die.&#8221;

### Comment by Dave Rolsky on 2011-05-27 19:22:03 -0500
@mjd: I think things like hg-git git-hg could potentially make this less of an issue. Also, just because the two are equivalent-ish now doesn&#8217;t mean they will always be so. It seems little too soon to ask for one or the other to go away.

### Comment by jnareb on 2011-05-28 04:44:25 -0500
@mjd: We have KDE, Gnome, XFCE. We have Eclipse and NetBeans. We have Emacs and Vim. Why shouldn&#8217;t we have Git, Mercurial and Bazaar?

### Comment by Tomáš Znamenáček on 2011-05-28 06:10:51 -0500
Did you consider using GitHub? If yes, what were the arguments against it?

### Comment by Benoit on 2011-05-28 07:05:58 -0500
Just a side comment: hgk is ugly and unmaintained since a very long time (we might even remove it from the mercurial repo). People usually use hgtk (tortoisehg, gtk version), or the new version of tortoisehg (uses qt, supposedly much better on OSX).

I never used gitg so I don&#8217;t know how it compares, but listing hgk as a minus is not very fair ;)

### Comment by Dave Rolsky on 2011-05-28 09:55:12 -0500
@Tomáš: I didn&#8217;t really consider github because I like to host my own stuff. I&#8217;m just a little paranoid, I guess.

@Benoit: I didn&#8217;t realize there were better alternatives to hgk. The gitg program is available as an ubuntu package, hgtk isn&#8217;t, which is probably why I didn&#8217;t notice it.

### Comment by curtis on 2011-05-30 22:34:36 -0500
Personally, I just moved my code to Mercurial myself from svn (as opposed to git.) [http://hg.curtisjewell.name is where my stuff lives.]

Yes, I like to host, too (and I&#8217;m going to write myself a user/repository-maintenance tool to help me in about a week.) [http://hg.curtisjewell.name is where my stuff lives.]

The big reason I chose Hg? I work on Windows for 90+% of my Perl projects, and Git on Windows is just painful, IMO! Yes, I use Git for other people&#8217;s projects, but I deliberately keep it out of my path so that it&#8217;s version of Perl does not mess my system up, and I only keep it on one machine!

When git becomes as good on Windows as it is everywhere else (meaning it does not need either Cygwin or its own version of Perl named &#8216;perl&#8217; to come along with in order to be sane) THEN I&#8217;ll think about converting over.

To @mjd specifically: monocultures are BAD. That&#8217;s how we got Windows and its pains! :) (I shouldn&#8217;t complain, I work in it.)

### Comment by Mark Dominus on 2011-06-01 12:01:25 -0500
Please RTFA.

### Comment by asjo.koldfront.dk on 2011-06-20 11:37:44 -0500
How does Gitalist compare to <a href="http://hjemli.net/git/cgit/" rel="nofollow">cgit</a>? I find cgit nicer than gitweb.

(I tried the Example tab on the Gitalist website, but it times out for me currently.)