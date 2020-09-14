---
title: git-age-report
author: Dave Rolsky
type: post
date: 2012-04-17T10:44:38+00:00
url: /2012/04/17/git-age-report/
categories:
  - Uncategorized

---
At work we have some git repos that were converted from CVS originally created back in 2002 or so. A lot of the things in these repos is cruft and could be deleted. I wrote a little git command to report the most recent commit date for each thing in the current directory.

<pre class="lang:perl">#!/usr/bin/env perl

use strict;
use warnings;

use DateTime;

my %age;
for my $thing ( glob '*' ) {
    next if $thing =~ /^\.\.?$/;

    my $epoch = `git log -1 --format="%at" $thing`;
    chomp $epoch;

    $thing .= '/' if -d $thing;
    push @{ $age{$epoch} }, $thing;
}

for my $epoch ( reverse sort keys %age ) {
    my $dt = DateTime->from_epoch( epoch => $epoch );

    print $dt->date(), "\n";
    print "  - $_\n" for @{ $age{$epoch} };
    print "\n";
}
</pre>

## Comments

### Comment by http://openid.aliz.es/anonymous on 2012-04-17 12:59:24 -0500
ack -naf|xargs -I {} sh -c &#8216;echo -n $(git log -1 &#8211;format=%ai &#8220;{}&#8221;); echo &#8221; {}&#8221;&#8216;

### Comment by Frew Schmidt on 2012-04-18 09:48:46 -0500
Nice one anonymous! I golfed it down and replaced ack with find:

find . -maxdepth 1 -type f |xargs -I {} git log -1 &#8211;format=&#8221;%ai {}&#8221; &#8220;{}&#8221;

### Comment by Matt Lawrence on 2012-04-23 07:21:03 -0500
Those one-liners don&#8217;t solve the original problem. The entries should be sorted by date and directories should not be skipped.

ls -p | xargs -I {} git log -1 &#8211;format=&#8221;%ai {}&#8221; &#8220;{}&#8221; | sort -r

This one sorts by date and marks directories with a slash (like the original). Note that the original script would have mis-sorted dates earlier than 9th Sep 2001 because of string sort on unix time, but the earliest expected date was after that anyway.

### Comment by Dave Rolsky on 2012-04-23 09:06:35 -0500
Just to clarify, the only directories my code skips are &#8216;.&#8217; and &#8216;..&#8217;