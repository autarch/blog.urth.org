---
title: Why Do People Use the System Perl?
author: Dave Rolsky
type: post
date: 2011-10-01T13:18:15+00:00
url: /2011/10/01/why-do-people-use-the-system-perl/
---
Recently on the perl5-porters list, there have been [several][1] [discussions][2] about backwards compatibility and the future of Perl 5.

[Jesse's plan][1] is interesting, and in theory sounds like a good idea. Unfortunately, it brings up some incredibly thorny issues and may not be technically possible. Even if it is possible, it's likely that lexically preserving backwards compatibility will not work for every proposed feature.

This is an old discussion. The p5p list has been debating backwards compatibility versus evolution for years.

One thing that keeps coming up is that backwards compatibility is important for people who are using their system-installed Perl. If they upgrade from RHEL 5 to 6, they'll move from Perl 5.8.8 to 5.10.1, and they can't really avoid that. People who are stuck in this situation are very concerned about backwards compatibility.

I'm not very sympathetic to this view. You have an uncontrolled dependency in your system, and you expect the maintainers of said dependency to essentially keep your code working for free. But my sympathy is irrelevant, because I'm not in charge. I don't think p5p as whole (or Jesse as a one) will ever tell these users to just deal with breakage.

All of this leads up to the title of this entry. Why do people use the system Perl? Well, answer number one is that it's really convenient. Perl is already there, so why not use it?

If we can make it easier to _not_ use the system Perl, maybe we'll feel a little freer to (very slowly) break backwards compatibility. We already have [perlbrew][3], which is a great tool for development, especially when you need to test code with more than one version of Perl.

I've seen some people suggest that somehow perlbrew can replace the system Perl for an application, but I don't follow that logic. If I'm running an app across thirty servers, do you seriously expect me to run "perlbrew install perl-5.14.2" on each one? That's nuts. Package systems were invented for a reason.

Wouldn't it be cool if we (as a community) provided a set of "official perl.org" packages of Perl. After all, we're programmers, and this is a task that's ripe for automation. These packages would install under some location like "/opt/perl-5.14.2". For each version, we might provide both threaded and non-threaded versions.

Being able to keep a consistent Perl version across system upgrades will prevent the "I upgraded my OS and all my Perl code broke" problem. As a bonus, this might also make it easier for people to upgrade Perl _more quickly_ if they want to. Not being tied to the system Perl is good for people who want stability _and_ people who want to upgrade faster.

Putting this on perl.org and calling it official is an important part of this plan, since many sysadmins are rightly suspicious of random packages found on some random dude's website.

What do people think?

 [1]: http://grokbase.com/t/perl.org/perl5-porters/2011/09/perl-5-16-and-beyond/12qfeajm3t2egq4hi7cvfczrxwke
 [2]: http://www.nntp.perl.org/group/perl.perl5.porters/2011/09/msg177798.html
 [3]: http://www.perlbrew.pl/

## Comments

**szabgab.com, on 2011-10-01 14:46, said:**  
This might solve the problem for some people but in many shops they require things to be supplied by the vendor (e.g. RedHat). For those encouraging RedHat to provide multiple versions of perl might be only solution.

**Nigel Metheringham, on 2011-10-02 03:17, said:**  
I use perlbrew to build an application perl, along with a few hundred additional modules, all packaged up as a single rpm, which is required by the application rpm.

I ignore the system perl.

**alex.hartmaier, on 2011-10-02 05:29, said:**  
We need to reach those people that are using the distro Perl and ask them why they do.  
Maybe a poll is a good start.  
I think as someone gets more and more into Perl the likelyhood that (s)he compiles his/her own Perl rises.  
Maybe we're trying to hard to fix a problem that doesn't even exist (or is much smaller than we think).

I've used the distros Perl for almost ten years just because it worked and also because everything was Perl 5.8.  
I even switched distro (from RedHat to Debian) because of RHEL3's unicode broken 5.8.1.  
It never came to my mind that compiling my own Perl takes so litte time and effort.

Currently I'm in the process of getting all my boxes upgraded to Debian 6 to be able to do Perl and module upgrades on my dev box and spread them to the different prod boxes using git.

**berekuk.ru, on 2011-10-02 07:39, said:**  
Yes!  
But I believe we need to take a step further and provide the whole CPAN in the pre-packaged form (PPA in case of Ubuntu, and I hope there is some similar solution for RedHat world).  
Maintaining ~25k packages may sound like an impossible task, but thanks to the wonderful dh-make-perl it can be automated and the only hard part is to deploy the whole infrastructure once (again, don't know much aboud RedHat tools).

PS: [I proposed this plan](http://blogs.perl.org/users/vyacheslav_matjukhin/2011/05/proposal-for-corporate-people-who-are-stuck-with-old-system-perl.html) some time ago, but unfortunately nobody commented back then.

**mikegrb, on 2011-10-02 20:20, said:**  
I always used the system perl, even for development, until perlbrew came along. Ease was the primary reason and perlbrew eliminated that reason. Perlbrew isn't the answer for production usage though. Gabor made a great point about people tied to vendors, especially with support contracts for things like RHEL. I'd think even then though with an alternate Perl in /opt and the system perl left untouched you'd be okay but who knows. I very much like the idea of official perl.org packages and can definitely see it allowing organizations to upgrade to more recent perl versions quicker.

**Stephen, on 2011-10-02 21:00, said:**  
No one with a clue _wants_ to use the vendor-supplied Perl. We are _forced_ to use it by idiot PHBs with zero understanding of the technical requirements. The vendor Perl is sacrosanct to them - we (the corporation) paid for it, the vendor supports and warrants it, ergo we shall use it.

What, you say the vendor Perl was compiled by chimps that think flipping every configure bit on is a good idea? ithreads are a useless anti-performance feature? Well, okay, just get seven managers, four VPs, and the entire sysadmin group to sign off of this custom software install waiver, and if our server gets hacked we will probably blame your custom install (even if it has nothing to do with it) and fire you.

The issue is not with Perl, or even with the vendors, it is with the suits that are clueless about reality.

I think official packages are a good step toward a solution, if not _the_ solution. Getting an updated MySQL was easy when I pointed out that Oracle produced its own "vendor" packages of the latest version. Perl might be a harder sell since there's no backing company, but it has to be a step in the right direction for those of us trapped in this particular circle of hell.

**szabgab.com, on 2011-10-03 00:06, said:**  
Alex, I'd be happy to run such poll on perlpolls.com but I need help in putting together 2-4 questions with reasonable answers to select from.

I'll also need help in distribution the poll to corporate users. </p>

**Zbigniew Lukasiak, on 2011-10-03 02:37, said:**  
The question is how these additional perls would live together with the system perl - and in particular can they use the same name for the executable? With vi and vim you can set it globally with <http://linux.die.net/man/8/alternatives> - but we need to set it per 'task', if you run a system utility you want it to use the system perl - but for your own web apps you want your alternative perl. I think the only sane solution here is to use different names for these perls - just like the smoke testers do.

**Bron Gondwana, on 2011-10-03 02:47, said:**  
Why have we kept using the system perl? If you have multiple perls on the system then you need to worry about multiple module trees and compatibility between them. You need to worry about "something was run with the wrong perl and did weird things".

Most of all - you need to compile your own mod_perl, and then you need to look after your own apache - pretty soon you're maintaining a whole huge package tree separately of the operating system.

We build our own packages for some things, but perl has so many tentacles throughout the operating system as well - the only way I can see that would be sane would be to call the own-built binary something else, and make sure you actually had: /opt/siteperl/siteperl at the top of every script, and always ran "siteperl $script" if running a script. Then you could keep the two worlds separate.

**Ed Avis, on 2011-10-03 06:18, said:**  
I have to say I don't understand what all the fuss is about. We use the Perl packages supplied with Fedora and are happy with them. If there are additional CPAN modules which Fedora doesn't package then we package them ourselves using cpanflute2 to make an RPM. From a sysadmin point of view it is much easier to use the package manager to manage the software on your system. Our custom packages (source and binary) are then kept in a Subversion repository. This makes it easy to install a new machine - just do the default install and then 'yum localinstall RPMS/*' plus copying some config files to /etc. It is also pretty straightforward to upgrade the OS to a newer Fedora release; the source packages often just need a 'rpmbuild -rebuild'.

Using RPM (or dpkg, or whatever) does not mean you are forced to use the vendor's perl. When we wanted to use 5.10 but Fedora didn't package it yet, I just built some RPMs for it and installed those. When the new Fedora came out the packages were replaced with the upstream ones without any fuss.

If your vendor's Perl distribution sucks you should at least \*try\* to contact the vendor and ask them to improve it before you give up and resort to your own build. OK, if it's Mac OS and there is no hope of getting anyone in Cupertino who has a clue, then by all means roll your own. But in Linux-land raise your expectations a bit. If your vendor isn't capable of packaging Perl sanely then get another vendor.

**gizmomathboy, on 2011-10-03 08:32, said:**  
I imagine providing a .rpm or .deb would make it significantly easier for Red Hat to then bless and add to their repo.

Then again, we recompile our own Perl into /opt, but making a package packages to do that from Perl itself would be fantastic I think.

**Diogo, on 2011-10-04 06:20, said:**  
Using system Perl isn't the only problem...

My problem, is that the systems where I'm currently developing Perl, are mostly very old Solaris, for witch I found no pre-compiled versions of Perl, that I may use without requesting to the system administrator. The system administrator fears replacing the older versions that he makes me availlable (the system and a other little younger), and refuses installing further more Perl versions.

Also I can't build my own newest Perl, because I'm missing dependecies (that I also can't install).

Other problem is that this machines are isolated from the Internet. And don't have an internal CPAN mirror...

Operating System upgrade is not an option. We have a huge code base (15 years of work on the same systems, writen in C, Java, Bash, ksh, tcsh, Perl, PHP, and others) of critical applications. And just the efford for re-testing all the code, would take us to a stand still and cost millions. So I'm stuck with this old versions of Perl.

So it would be really cool if I got a pre-compiled Perl that a could install in my home directory for this old systems... Or at least a bundle of everything that would be needed to compile my own Perl (including all dependencies).

**Christopher Cashell, on 2011-10-21 00:06, said:**  
I've been thinking about this on and off for a while (as someone who maintains a large number of systems, and writes perl and wishes to use modern releases). The best solution I've been able to come up with is better support in Perl for concurrent versions. Then the "base" perl could be a slower moving system perl (which /usr/bin/perl could/would point to), but you would have multiple (vendor included) packages for perl-5.12 and perl-5.14 (or whatever).

Unfortunately, this wouldn't be an easy change. Best case scenario would be years away.

**Ravenhall, on 2012-07-10 12:21, said:**  
RedHat, et alia will continue to use old versions of Perl as long as they can get away with it. How does Gnome, etc get RedHat to use newer packages? They break backward compatibility.

Perl has maintained better backward compatibility than almost any other language I've seen - or even software distribution. This has been its downfall as well as its strength.

The OS distros should know better. They should be staying on the current stable release of Perl.

I'm in the midst of a large perl project at my company, and I'm ignoring the system perl.