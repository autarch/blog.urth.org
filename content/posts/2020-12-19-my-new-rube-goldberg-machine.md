---
title: My New Rube Goldberg Machine
author: Dave Rolsky
type: post
date: 2020-12-19T22:30:10-06:00
url: /2020/12/19/the-covid-urth-org-rube-goldberg-machine
---

My last post was about my [local COVID tracker tool]({{< relref
"2020-12-12-my-local-covid-stats-tracker" >}}). While it worked well, I found having to re-run the
`report.pl` script every time I wanted an update annoying. Plus, I wanted to share this on Facebook,
but I have non-technical friends who would not be able to run it for themselves.

So I decided to put up a hosted version, but I challenged myself. I wanted it to run entirely on
someone else's machines. And I didn't want to pay for it.

So how to do it?

Well, the hosting is simple. I've been using [Render](https://render.com/) for this blog, as well as
[my professional site](https://www.houseabsolute.com/) and some other static sites[^3]. And while my
COVID tracker does require updated data to stay relevant, the data is just a simple JSON file and
the chart is generated entirely in the browser.

So the trick was to make the data file available in a way that let me deploy it with Render every
time there are updates.

Enter my Rube Goldberg machine.

The data source I'm using, [covid-api.com](https://covid-api.com/), only updates their data daily,
so I only need to run this once a day to stay relevant. This sounds like a job for cron. But not on
my desktop machine (even though that would be _way_ simpler).

Instead, I used [GitHub Actions](https://github.com/features/actions). It supports scheduled jobs as
well as running on every push to [the repo](https://github.com/houseabsolute/local-covid-tracker/).
But the trick is to then make the data available after each run. And then the trickier trick is to
get that data as part of running the deploy job on Render. Oh, and every time the GitHub Action
runs, I want to have the Render site deploy again.

This turned out to be not that hard.

[My GitHub Actions workflow](https://github.com/houseabsolute/local-covid-tracker/blob/master/.github/workflows/update.yml)
runs the `report.pl` script, which generates a `summary.json` file. Then the workflow
[uploads that file as a build artifact](https://github.com/marketplace/actions/upload-a-build-artifact).
This is all incredibly trivial, and by [using caching](https://github.com/actions/cache) for both my
Perl prereqs and the intermediate data files, I can make it quite fast. When the cache is warm, a
run takes less than a minute. When it finishes, it hits a webhook provided by Render to trigger a
deploy.

Of course, GitHub has
[an API for artifacts](https://docs.github.com/en/free-pro-team@latest/rest/reference/actions#artifacts)
like the `summary.json` file. So all I need to do in the Render deploy script is use the API to find
the latest artifact, then download that and deploy it along with my `index.html` and `chart.js`
files. With a little experimentation, I was able to create a
[Bash script](https://github.com/houseabsolute/local-covid-tracker/blob/master/deploy.sh) to do
exactly that. I could have written this in Perl, but the combination of `curl`, `jq`, and `zcat`
(artifact files are always zipped) actually made this much simpler to do in Bash than Perl[^1]. I
had to use `sed`, which always seems weird when I know Perl, but doing this in Perl requires at
least a few more characters.

The hardest part was figuring out how to
[securely store](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets)
the Render webhook URL in GitHub and then
[access it in my workflow](https://docs.github.com/en/free-pro-team@latest/actions/reference/encrypted-secrets).
I had to store a GitHub token in Render[^2] as well.

And so I present to you [covid.urth.org](https://covid.urth.org/).

Also, you might note that the chart has changed a little since last time. I made the past 7-day
average line thicker and the daily numbers line thinner. The average is much more indicative of
trends then the actual daily numbers, which jump around quite a bit.

[^1]: This happens every once in a while.

[^2]:
    I guess I didn't _have_ to, but the GitHub limit on unauthenticated requests is so low that I
    figured it was best to use authentication instead.

[^3]:
    See my [previous writeup]({{< relref
    "2020-09-25-my-move-to-render-is-complete" >}}) on moving all my sites to Render.
