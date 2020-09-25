---
title: My Move to Render is Complete
author: Dave Rolsky
type: post
date: 2020-09-25T12:57:00-05:00
url: /2020/09/25/my-move-to-render-is-complete/
---
I've now moved all of my sites from my Linode box to [Render](https://render.com). This includes:

* [This blog](/) - Uses Hugo. [Repo](https://github.com/autarch/blog.urth.org)
* [houseabsolute.com](https://houseabsolute.com/) - Contains my resume and links to conference slides. Also uses Hugo. [Repo](https://github.com/autarch/houseabsolute.com)
* presentations.houseabsolute.com - A new hostname for my slides. See below for more details. [Repo](https://github.com/autarch/presentations)
* [masonbook.houseabsolute.com](https://masonbook.houseabsolute.com/) - Just a static site. [Repo](https://github.com/autarch/masonbook.houseabsolute.com)
* [vegguide.org](https://vegguide.org/) - Just another static site. [Repo](https://github.com/autarch/vegguide.org)

I *really* like [Render](https://render.com/)! It's incredibly easy to use. All of the sites are static sites either using Hugo or are just raw HTML and CSS pages in a directory tree. The one exception is the presentations site, which took a bit of fiddling. Static sites are completely free on Render, so this lets me replace my $20/month Linode server with $0/month hosting. Of course, Render is a startup and might disappear or start charging, but they also have competitors like Netlify offering the same deal. And I can always move to [AWS Amplify](https://aws.amazon.com/amplify/) for a very low cost if needed.

Previously, I had served the [houseabsolute.com](https://houseabsolute.com/) domain using WordPress and Apache. Most of the site was WP, but the `/presentations` path was just a directory on disk. That directory contained a clone of [my presentations repo](https://github.com/autarch/presentations) that I would pull into as needed.

But with Render I needed to make the presentations repo part of the houseabsolute.com repo. My first thought was to use git submodules, but this didn't work. The problem is that the presentations dir has a ton of symlinks. Most of my presentations use [reveal.js](https://revealjs.com/) (v3 or v4). Instead of copying the JS and CSS from reveal to each presentation directory, I just have one copy of reveal.js in the repo (well, one v3 and one v4) and symlink into it from the directory contaning each presentation.

I tried getting Hugo to treat this all as static content, but it mostly (entirely?) skips symlinks. So that was a no go.

Next I tried getting Render to just treat the entire repo as a static site. But Render _also_ doesn't support symlinks. I'm guessing that it serves static content from S3 or something similar. So when it serves content there's no filesystem and therefore no symlinks.

Fortunately, with Render, you can specify a command to prepare a static site for publishing, and then a single directory that contains that site. So I wrote a fairly simple [`render.sh`](https://github.com/autarch/presentations/blob/master/render.sh) script to do that for my presentations repo. It first gets rid of any `node_modules` directories. These are only needed for the reveal.js local server mode, which I use when I give a presentation to open a separate speaker notes window. Then I use `rsync` to copy all the presentations to a subdirectory. Rsync has a very handy `--copy-links` option that essentially "delinkifies" the tree as it copies. So every symlink turns into a copy of the thing it links to. I found out about this through a Stack Overflow answer that I cannot find again right now.

This works nicely, though it ends up being bigger than is really needed because of all the copies of the reveal.js code. All told, it ends up at 107MB. And this is why my presentations have moved to their own hostname. Fortunately, Render lets you add redirects to static sites so any stray links to the old paths in the houseabsolute.com hostname will continue to work.

[Render](https://render.com) has a lot of other really nice features. When you set it up you specify the domain you are using for the site. Once it detects that you've updated DNS to point the domain at their servers, it automatically sets up SSL for that domain using [Let's Encrypt](https://letsencrypt.org/). When you first configure a new site, it sets itself up to rebuild your site on every push, which is a great default. If you wanted something more complex you can turn that off and hit a deploy hook URL that they provide for your site. You can also set it up to let you preview PRs of that repo.

Of course, all of this is just a loss leader for their real services, which let you deploy actual applications along with databases and persistent disks as needed. If I had an app I needed this for I would definitely try this out.

Overall, I'm really happy with this move. I much prefer editing Markdown files in Emacs. The WordPress editor is pretty good, but Markdown is just better for me. And the attack surface for this setup is much smaller than running an actual server on my own.

One impact from all of this is that I will no longer be on IRC. I was hosting [The Lounge](https://thelounge.chat/) on my server, but that server is going away soon. There are other web IRC options, but I realized that I barely use IRC these days. If you want to get in touch with me you can find me in the TPF Slack (I can invite you to the #perl channel there if you want) or just [email me](mailto:autarch@urth.org). TPF has discussed setting up a permanent community chat forum, and if that does happen I'll be there too.
