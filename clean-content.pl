#!/usr/bin/env perl

use v5.30;
use strict;
use warnings;
use autodie qw( :all );
use experimental qw( signatures );
use feature qw( postderef );

use DateTime::Format::CLDR;
use Path::Tiny::Rule;

sub main {
    STDOUT->binmode(':encoding(UTF-8)');

    my $iter = Path::Tiny::Rule->new->name(qr/\.md\z/)->iter('content/posts');
    while ( my $file = $iter->() ) {
        my $content = $file->slurp_utf8;
        $content =~ s/categories:\n  - Uncategorized\n+//;

        $content =~ s{<a href="(.+?)"[^>]+>([^<]+)</a>}{md_link($1, $2)}ge;
        $content =~ s/&#039;/'/g;
        $content =~ s/&#42;/'/g;
        $content =~ s/&#43;/+/g;
        $content =~ s/&#45;/-/g;
        $content =~ s/&#95;/_/g;
        $content =~ s/&#96;/`/g;
        $content =~ s/&#215;/x/g;
        $content =~ s/&#(?:8210|8211|8212);/-/g;
        $content =~ s/&#(?:8216|8217);/'/g;
        $content =~ s/&#(?:8220|8243);/"/g;
        $content =~ s/&#8221;/"/g;
        $content =~ s/&#8230;/.../g;
        $content
            =~ s/\#\#\# Comment by (.+?) on (20.+)/"**$1, on " . format_date($2) . ', said:**  '/eg;
        $file->spew_utf8($content);
    }
}

my $p = DateTime::Format::CLDR->new(
    pattern => 'yyyy-MM-dd HH:mm:ss ZZ',
    locale  => 'en-US',
);

sub md_link ( $href, $text ) {
    return "<$href>" if $href eq $text;
    return "[$text]($href)";
}

sub format_date ($date) {
    my $dt = $p->parse_datetime($date)
        or die "Could not parse $date";
    $dt->set_time_zone('America/Chicago');
    return $dt->format_cldr('YYYY-MM-dd HH:mm');
}

main();
