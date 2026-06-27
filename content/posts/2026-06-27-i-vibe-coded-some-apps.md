---
title: "I Vibe-Coded Some Apps"
author: Dave Rolsky
type: post
date: 2026-06-27T10:28:08-05:00
url: /2026/06/27/i-vibe-coded-some-apps
---

Recently, I've been using Claude to build some apps that I've always wanted, but which were too much work to do myself.

The first is [a bass guitar practice exercise app](https://beisi5000.urth.org/), which I've called "BèiSī 5000". The "BèiSī" is the Mandarin for bass, 貝斯. Claude is very good at building webapps, and it was able to do the music presentation part with [AlphaTab](https://alphatab.net/).

![screenshot of BèiSī 5000](/image/beisi5000.png)

But trying to get it to pick the right fret choices for each exercise was ... interesting. I think there are two problems here. First, there are not many applications that deal with this already, so there's probably not much data in the training set related to this problem. Second, LLMs work with _text_, and this isn't something that's easy to write about. I was struggling to try to explain why a certain exercise should use a specific set of fretting choices, based on things like whether we start a scale with the pinky or index finger. I can reliably pick the right fret without thinking about it, but I translating that into instructions for an LLM was really hard. My bass teacher referred to different fretting patterns as "front hand" (index), "mid hand" (middle and ring), and "back hand" (pinky), based on the starting finger for an exercise. This makes a lot of sense to me, but trying to explain this to Claude was tough, as I don't think these are widely used terms, and Claude doesn't have hands.

Claude ended up with a sort of constraint-based rules engine to decide when to stay on a string for the next note versus switch. It mostly works, but it still makes weird choices sometimes. This doesn't really bother me that much, since I prefer to _not_ use tab when playing. I think it's better to build the mental association between an actual pitch and where my hand goes, versus thinking of things in terms of fret numbers (in other words, G, not 3).

[The app is on GitHub](https://github.com/houseabsolute/beisi5000). If you try it out, feel free to report issues and I'll see if Claude can fix them.

The other app I had it build I called [olivier](https://github.com/houseabsolute/olivier) (after [the composer Olivier Messiaen](https://en.wikipedia.org/wiki/Olivier_Messiaen)). This is an MP3 player.

Why yet another MP3 player? I have a lot of non-English music in my MP3 collections, mostly Japanese with a bit of Chinese. I've always wanted a player that would show me both the original artist names and titles along with both a reading (how to pronounce it) and translation (when relevant). I've been using Rhythmbox for many years, but it does not have any sort of multilingual display (AFAIK).

So why not build a player just for me? Claude picked Flutter for the frontend with a Rust backend, in part because I want this to work on desktop and my phone. It uses [the fantastic MusicBrainz](https://musicbrainz.org/) database to get the reading and translation data, storing it all locally in SQLite.

It doesn't have a ton of features, but so far it has the features I care about.

![screenshot of Olivier](/image/olivier.png)

In both of these cases, I haven't really looked at the code Claude produced. The goal here wasn't to produce excellent code, it was to produce some totally custom tools for one user, and that worked quite well. Both of the projects took a fair bit of back and forth. For the bass practice app, I started with a fairly detailed spec, and then had Claude build it one feature at a time. There was a _lot_ of back and forth on the music display and fret choices. For the music player, I started with a much smaller spec, assuming that since there was so much prior art in this space, Claude would make reasonable choices. There was still a fair amount of back and forth to fine tune parts of the UI and fix various bugs.

Time-wise, both projects took over many days. I haven't given Claude a ton of freedom to execute commands, so it asked for permission quite often. If I wasn't around, it was stuck waiting for approval. It would be interesting to try building something in a sandbox so I could give the agent more freedom and see how independently it could operate.

Having also used Claude at work, it's clear to me that software developers are still needed to operate these tools. I don't know that someone without any coding experience could give Claude sufficiently clear instructions to arrive at a finished product. This is especially true for a real software product intended to be deployed outside one user's system. But who knows where these tools will be 6-12 months from now.
