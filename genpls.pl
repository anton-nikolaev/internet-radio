#!/usr/bin/perl

use strict;

my $file = '/home/svetlana/t.m3u';
my $tmp = '/home/svetlana/.radio.m3u.tmp';
my $pls = '/home/svetlana/radio.m3u';
exit(0) if not -r $file;
open (FILE, $file) or die "Cant read $file: $!";
open (TMP, ">$tmp") or die "Cant write $tmp: $!";
while (<FILE>) {
    chomp;
    next if /^\#/;
    s/^\d+\\/music\//;
    print TMP "$_\n";
}
close(FILE);
close(TMP);
unlink($pls) or die "Cant remove file $pls: $!";
rename($tmp, $pls) or die "Cant rename $tmp to $pls: $!";
unlink($file) or die "Cant remove file $file: $!";
