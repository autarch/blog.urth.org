---
title: 'Cataclysm: DDA Launcher CLI'
author: Dave Rolsky
type: post
date: 2019-01-20T20:20:52+00:00
url: /2019/01/20/cataclysm-dda-launcher-cli/
categories:
  - Uncategorized

---
I&#8217;ve been playing the heck out of [Cataclysm: Dark Days Ahead][1] lately. It&#8217;s a fun and challenging open source post-apocalyptic roguelike turn-based game. It&#8217;s in active development but there aren&#8217;t regular releases so you need to track the repo&#8217;s HEAD if you want to play the latest version (or a recent version).

This has been a pain on Linux, and so I ended up just playing on my Windows machine using the excellent [CDDA Game Launcher][2] application. But I really wanted something that would work on Linux too.

So I wrote a little CLI tool in Go called [catalauncher][3]. I&#8217;ve been using it myself for a few weeks and it works well. It downloads the latest build from a Jenkins server set up by &#8230; someone (I assume some past or present CDDA developer). It also adds in some optional mods and a soundpack. Then it launches the game inside a Docker container (so I don&#8217;t have to worry about library conflicts). It also preserves your saves and config across game upgrades transparently (I hope).

I&#8217;ve just done the [first binary release][4] so I hope folks will give it a try. While there are binaries for macOS I have no idea if they will work. The way it launches Docker may only work on Linux because it needs to give the container access to the host&#8217;s video & sound setup. Patches to improve this on other OS&#8217;s (and other Linux distros/setups) are very much welcome.

 [1]: https://github.com/CleverRaven/Cataclysm-DDA/
 [2]: https://github.com/remyroy/CDDA-Game-Launcher
 [3]: https://github.com/houseabsolute/catalauncher
 [4]: https://github.com/houseabsolute/catalauncher/releases

## Comments

### Comment by Kevin Granade on 2019-01-20 20:48:50 -0600
Nice, I&#8217;ve been hoping someone would put together a launcher/update on linux.  
Let me know if you want a mention on cataclysmdda.org or the repository readme.