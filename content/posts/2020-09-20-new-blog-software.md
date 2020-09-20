---
title: New Blog Software
author: Dave Rolsky
type: post
date: 2020-09-20T15:32:12+00:00
url: /2020/09/20/new-blog-software/
---
Many, many years ago, in the flower of my youth (June, 1999), I registered the urth.org domain. I can't remember when I started hosting my own email, but it was around that time. For many years after, I had a server in my home that hosted my email, various websites, and some web applications. Eventually VPS's became cheap and powerful enough that I ditched the home server and moved everything to the cloud ([Linode](https://www.linode.com/), specifically).

Linode has been great, and has only gotten cheaper and better over time. But I've been doing less and less with my VPS over the years. I moved my mail to Gmail years ago because maintaining deliverability was too much work. I stopped hosting things like wikis and other webapps as cheap or free SaaS offerings became available.

Now the server is doing very little. It runs WordPress for my blog and [my resume/portfolio site](https://www.houseabsolute.com/), hosts a few static sites, and it runs [The Lounge](https://thelounge.chat/) for IRC. But do I really need WordPress for a blog? No, not really. Static site generators like [Hugo](https://gohugo.io/) are extremely powerful and require much less maintenance. They also have a much smaller security footprint. I don't spend much time on IRC, and there are hosted solutions available for free or very low cost.

So I concluded that I really don't need a server any more. This blog is now running with Hugo, as the footer states. I'm using [Render](https://render.com/) for hosting, which is a really nice service. It's free(!) for static sites like this one, and configuring it for a Hugo site is incredibly easy. My one concern about Render is that they're a startup, and I'm always nervous about startup longevity. On the other hand, there are a number of competitors, including [Netlify](https://www.netlify.com/) and [AWS Amplify](https://gohugo.io/hosting-and-deployment/hosting-on-aws-amplify/). But I hope Render sticks around, and I encourage you to [check it out](https://render.com/docs).

The one big change is that this new site no longer support comments. I looked at a few different options for this, but nothing seemed great. There's Disqus, but no. Just no.

There are also a number of FOSS options, but most require running a persistent service somewhere. There are also some clever serverless options like [utterances](https://utteranc.es/). But that uses the GitHub API in anonymous mode, which has extremely low rate limits. In testing I found it was easy to exceed those limits, which causes the comments to disappear from the blog until the limit resets. Each person/IP/browser (not sure how GH counts this) has its own limit, but just browsing through the archives is enough to trigger the per-hour limit. I really didn't like the idea of a heisencomments system.

There are also a few paid options that aren't creepy, but even the cheapest would run about $2 per month. Given that I write less than 20 posts a year, and most posts don't get any comments, that seems like a poor use of money.

Instead, I encourage people to submit a blog post to [Hacker News](http://news.ycombinator.com/) or [an appropriate subreddit](https://www.reddit.com/subreddits/a-1/) and start a discussion there. You can also [email me](mailto:autarch@urth.org). And if you find a typo in a post, you can just [submit a PR on GitHub directly](https://github.com/autarch/blog.urth.org/)!
