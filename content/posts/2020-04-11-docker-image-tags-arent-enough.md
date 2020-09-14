---
title: Docker Image Tags Aren’t Enough
author: Dave Rolsky
type: post
date: 2020-04-11T17:50:24+00:00
url: /2020/04/11/docker-image-tags-arent-enough/
categories:
  - Uncategorized

---
As part of [my ci-perl-helpers project][1] I generate a whole bunch of Docker images. Specifically, every time I push to a branch (including master) or a tag, I make 96 images. There is one base image and then one image for each specific version of Perl (5.8.9, 5.10.1, 5.12.0, etc.) plus a blead image. For each version of Perl I build a perl binary with and without threads. Obviously the number of images will only grow over time.

I tag these images with the version of Perl, whether it has threads, and _also_ with an indicator of the branch or tag of my project that I&#8217;ve built. So for example when I push to master I build an image tagged `5.30.1-master` and another tagged `5.24.1-threads-master` and so on. If the commit also has a Git tag I push the image again with an image tag including the Git tag instead of the branch, for example `5.24.1-threads-v0.1.5`.

I&#8217;m effectively putting three independent variables into a single string. I have information about the Perl version, about the perl binary&#8217;s compilation options, and about the version of the helpers code in the image.

Right now all of these images are built using `ubuntu:bionic` as the base but I was thinking that it would be nice to also build some images with other bases. So then I&#8217;d have tags like `5.30.1-ubuntu-bionic-master` and `5.18.3-threads-centos-7-v0.1.5`.

This just feels gross. Of course, I could also add `LABEL` lines to the Dockerfiles for each image to add this metadata but that doesn&#8217;t achieve much. When I look at my repository on Docker Hub I can only search by tag. I can&#8217;t use the labels when I run `docker pull` either. Docker Hub doesn&#8217;t even _show_ the labels in its web UI!

I see this sort of pattern all over Docker Hub. People encode lots of information in tags, leading to hard to remember and hard to read tagging schemes. The [perl Docker repo][2] is a great example. The tags encode the version of Perl, whether it has threads, and an indication of the Debian base image used for the image.

I think the solution is simple, conceptually. Encourage people to use consistent `LABEL` schemes and make it possible to search and pull images based on those schemes. It&#8217;s easy for me to say that, but I&#8217;m sure there are lots of usability issues to be discovered with this idea.

But surely there must be a better way to provide this sort of information than these ridiculously overloaded tags.

 [1]: https://github.com/houseabsolute/ci-perl-helpers/
 [2]: https://hub.docker.com/_/perl

## Comments

### Comment by Flavio Poletti on 2020-04-13 04:37:06 -0500
One of the uses of multiple tags for the same image is that they provide flexibility in the selection process. Even when you don&#8217;t provide one, there&#8217;s an implied \`latest\`, so the tag is always there.

This gives people the freedom to choose the level of trust they have in the image producer. As an example, a pattern I use is to tag the same image as \`1\`, \`1.3\`, and \`1.3.2\`, as well as with the git SHA1 short tag. The next patch would become \`1\`, \`1.3\` (overriding the other one) and \`1.3.3\` (new tag) as well as a new git SHA1.

In this way, a user can say &#8220;Whatever is the latest major version 1 is fine for me&#8221;, or pinpoint an exact patchlevel to avoid any kind of variation problem. They might even go paranoid with the SHA1 and freeze the exact environment. Having multiple aliases, some of which are fixed in time and others change at different speeds, give people choice.

The itch you&#8217;re talking about deals a lot with \*finding\* the right image depending on the conditions, and making it easy for humans to quickly arrive to their needs. At the end of the day, anyway, the underlying machinery will need to get one single image. I see a few possibilities here:

&#8211; you assign one or more &#8220;talking&#8221; identifiers, encoded as tags, to each alternative. This allows using the lower-level machinery exactly as it is, i.e. provide an image name and tag to the \`docker\` command (or in a Kubernetes Pod spec, &#8230;). The re-encoding in the tag is a matter of readability: the next person doing troubleshooting (i.e. future you) will be grateful to quickly understand at a glance what&#8217;s inside the image being used;

&#8211; you change the lower-level tools to perform image selection based on labels too. This keeps the readability, and moves onto the tool the burden to figure out the right image, much in the spirit of what labels do in selecting declared-state-change targets in Kubernetes. This might lead to brittle environments though. Suppose the image producer adds a new label to an existing image, with multiple possible values: you cannot load this image in your environment without updating all selectors related to this image, otherwise you risk to end up with multiple choices left after filtering things with the previous set of labels.

### Comment by Dave Rolsky on 2020-04-13 20:16:35 -0500
I am doing multiple tags for the images. For the latest patch release in each minor series, I have a moving tag like `5.30-v0.1.5` in addition to a `5.30.2-v0.1.5` tag. When 5.30.3 comes out the `5.30-v0.1.5` tag moves to that release&#8217;s image.

### Comment by Dave Rolsky on 2020-04-13 20:20:49 -0500
To address the other things you noted. I mostly just wish there was a more readable way to encode the relevant information (Perl version, threads or not, tag/branch of the ci-perl-helpers). These three things can vary independently so jamming them all into the tag makes it hard for humans to interpret. Adding more information to the tag, like the OS of the base image, will only make this worse.

For machines, it&#8217;s pretty easy to go from requirements (&#8220;find the latest 5.30 release with threads and the v0.1.5 ci-perl-helpers tag&#8221;) to the correct tag.

It might that all that&#8217;s needed is for Docker Hub to show label information in some useful way. Making this information searchable for a given repository would be even better.