---
title: Making Docker Play Nice with Ferm Firewalls on Linux
author: Dave Rolsky
type: post
date: 2018-06-01T18:14:28+00:00
url: /2018/06/01/making-docker-play-nice-with-ferm-firewalls-on-linux/
categories:
  - Uncategorized

---
I&#8217;ve been using Docker a fair bit for work at ActiveState recently. It&#8217;s quite nice and makes creating and deploying services much simpler.

However, it can also be incredibly annoying when I&#8217;m using it locally on my desktop. By default, the Docker daemon (dockerd) messes with iptables in order to allow docker images to connect to the interwebs. But if you already have a firewall in place there&#8217;s a good chance that this won&#8217;t work. So every time I want to use Docker I disable my [ferm][1]-based firewall and restart the Docker daemon. Then when I&#8217;m done using Docker I bring the firewall back up. Tedious and unsafe!

## Figuring Out What dockerd Does

Docker creates a new virtual network interface named `docker0` and then sets up iptables to give this interface access to the internet. I could not find any documentation on what dockerd actually does with iptables. Fortunately, this is easy to figure out by dumping the iptables rules when dockerd is running:

<pre class="height-set:true height:300 lang:default highlight:0 decode:true " title="iptables output when docker is running" >$&gt; sudo iptables -L -n -v

Chain INPUT (policy ACCEPT 30 packets, 5160 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target                    prot opt in       out       source               destination         
    0     0 DOCKER-USER               all  --  *        *         0.0.0.0/0            0.0.0.0/0           
    0     0 DOCKER-ISOLATION-STAGE-1  all  --  *        *         0.0.0.0/0            0.0.0.0/0           
    0     0 ACCEPT                    all  --  *        docker0   0.0.0.0/0            0.0.0.0/0            ctstate RELATED,ESTABLISHED
    0     0 DOCKER                    all  --  *        docker0   0.0.0.0/0            0.0.0.0/0           
    0     0 ACCEPT                    all  --  docker0  !docker0  0.0.0.0/0            0.0.0.0/0           
    0     0 ACCEPT                    all  --  docker0  docker0   0.0.0.0/0            0.0.0.0/0           

Chain OUTPUT (policy ACCEPT 36 packets, 5305 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain DOCKER (1 references)
 pkts bytes target     prot opt in     out     source               destination         

Chain DOCKER-ISOLATION-STAGE-1 (1 references)
 pkts bytes target                    prot opt in      out       source               destination         
    0     0 DOCKER-ISOLATION-STAGE-2  all  --  docker0 !docker0  0.0.0.0/0            0.0.0.0/0           
    0     0 RETURN                    all  --  *       *         0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-ISOLATION-STAGE-2 (1 references)
 pkts bytes target     prot opt in     out      source               destination         
    0     0 DROP       all  --  *      docker0  0.0.0.0/0            0.0.0.0/0           
    0     0 RETURN     all  --  *      *        0.0.0.0/0            0.0.0.0/0           

Chain DOCKER-USER (1 references)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 RETURN     all  --  *      *       0.0.0.0/0            0.0.0.0/0           


$&gt; sudo iptables -L -n -v -t nat

Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 DOCKER     all  --  *      *       0.0.0.0/0            0.0.0.0/0            ADDRTYPE match dst-type LOCAL

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 8 packets, 560 bytes)
 pkts bytes target     prot opt in     out     source               destination         
    0     0 DOCKER     all  --  *      *       0.0.0.0/0           !127.0.0.0/8          ADDRTYPE match dst-type LOCAL

Chain POSTROUTING (policy ACCEPT 8 packets, 560 bytes)
 pkts bytes target      prot opt in     out       source               destination         
    0     0 MASQUERADE  all  --  *      !docker0  172.17.0.0/16        0.0.0.0/0           

Chain DOCKER (2 references)
 pkts bytes target     prot opt in      out     source               destination         
    0     0 RETURN     all  --  docker0 *       0.0.0.0/0            0.0.0.0/0           
</pre>

The next step is to translate this into ferm rules and integrate it into my existing ferm config.

## Making It Work

Since I wanted to make ferm set up the Docker rules, I had to tell dockerd to stop doing it itself when the daemon was started.

Depending on what init system you&#8217;re using, there are two ways pass options to dockerd. If your system is using systemd, the daemon is configured via the `/etc/docker/daemon.json`. This disables the iptables setup:

<pre class="lang:js decode:true " title="daemon.json" >{
    "iptables": false
}
</pre>

For other init systems (sysv and upstart) you should edit `/etc/default/docker` and add `--iptables=false` to `DOCKER_OPTS`.

The Docker rules translate to the following ferm config (disclaimer: I am not an iptables or ferm expert so this may be a bit wrong):

<pre class="height-set:true height:300 lang:default highlight:0 decode:true " title="docker rules in ferm" >domain ip {
    table nat {
        chain DOCKER {
            interface docker0 RETURN;
        }

        chain PREROUTING {
            mod addrtype dst-type LOCAL jump DOCKER;
        }

        chain POSTROUTING {
            saddr 172.17.0.0./16 outerface !docker0 MASQUERADE;
        }

        chain OUTPUT {
            destination !127.0.0.0/8 {
                mod addrtype dst-type LOCAL jump DOCKER;
            }
        }
    }

    table filter {
        chain DOCKER {
        }

        chain DOCKER-USER {
        }

        chain DOCKER-ISOLATION-STAGE-1 {
            interface docker0 outerface !docker0 jump DOCKER-ISOLATION-STAGE-2;
            RETURN;
        }

        chain DOCKER-ISOLATION-STAGE-2 {
            outerface docker0 DROP;
            RETURN;
        }

        chain FORWARD {
            jump DOCKER-USER;
            jump DOCKER-ISOLATION-STAGE-1;
            outerface docker0 ACCEPT;
            outerface docker0 jump DOCKER;
            interface docker0 outerface !docker0 ACCEPT;
            interface docker0 outerface docker0 ACCEPT;
        }
    }
}
</pre>

## A Not So Great Solution

This works. I can enable my firewall with `sudo service ferm restart` and use Docker normally. Containers are able to access the internet. Yay!

One problem, however, is that the easiest way to make this work was to put the docker rules before all my other rules. This probably means my docker containers are a bit more exposed than is ideal. However, I only use Docker to build containers and test them locally, so that&#8217;s okay for now.

But the bigger problem is that this will almost certainly break. In the short time I&#8217;ve been using Docker (about 6 months) the way it does networking has changed at least once. A few months back dockerd would set up two virtual interfaces, `docker0` and `docker_gwbridge`. The iptables rules it used were a bit different then as well.

So it seems likely that dockerd might change what it does again and my config will be broken. This is all quite annoying. I&#8217;m not sure what the best solution is, but at the very least it&#8217;d be good to see Docker document exactly what these rules need to be (and better yet, what they&#8217;re doing at a higher level).

 [1]: http://ferm.foo-projects.org/