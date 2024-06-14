---
title: git-age-report
author: Dave Rolsky
type: post
date: 2012-04-17T10:44:38+00:00
url: /2012/04/17/git-age-report/
---

At work we have some git repos that were converted from CVS originally created back in 2002 or so. A
lot of the things in these repos is cruft and could be deleted. I wrote a little git command to
report the most recent commit date for each thing in the current directory.

```perl
#!/usr/bin/env perl

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
```

## Comments

**http://openid.aliz.es/anonymous, on 2012-04-17 12:59, said:**  
`ack -naf|xargs -I {} sh -c 'echo -n $(git log -1 -format=%ai "{}"); echo " {}"'`

**Frew Schmidt, on 2012-04-18 09:48, said:**  
Nice one anonymous! I golfed it down and replaced ack with find:

`find . -maxdepth 1 -type f |xargs -I {} git log -1 -format="%ai {}" "{}"`

**Matt Lawrence, on 2012-04-23 07:21, said:**  
Those one-liners don't solve the original problem. The entries should be sorted by date and
directories should not be skipped.

`ls -p | xargs -I {} git log -1 -format="%ai {}" "{}" | sort -r`

This one sorts by date and marks directories with a slash (like the original). Note that the
original script would have mis-sorted dates earlier than 9th Sep 2001 because of string sort on unix
time, but the earliest expected date was after that anyway.

**Dave Rolsky, on 2012-04-23 09:06, said:**  
Just to clarify, the only directories my code skips are '.' and '..'
