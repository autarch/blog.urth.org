#!/usr/bin/env perl

use v5.30;
use strict;
use warnings;

use DateTime;
use DateTime::Format::RFC3339;
use Path::Tiny qw( path );

sub main {
    my $title = shift // die 'You must supply a title';

    my $now = DateTime->now( time_zone => 'local' );

    my $date = DateTime::Format::RFC3339->format_datetime($now);
    my $slug = slug($title);
    my $url  = $now->format_cldr('/YYYY/MM/dd/') . $slug;
    my $file = path(
        qw( content posts ),
        $now->format_cldr('YYYY-MM-dd-') . $slug . '.md',
    );

    $file->spew_utf8( sprintf( <<'EOF', $title, $date, $url ) );
---
title: %s
author: Dave Rolsky
type: post
date: %s
url: %s
---
EOF
}

sub slug {
    return lc(shift) =~ s/[^a-z0-9]+/-/gr;
}

main(@ARGV);
