#!/usr/bin/perl

use strict;
use Data::Dumper;

my $music_dir = '/home/svetlana/music';
my $pls = '/home/svetlana/radio.m3u';
my $tmp = '/home/svetlana/.radio.m3u.tmp';

my @new_pls;
my $regen_pls;

my %dir_music;
opendir (MUSIC, $music_dir) or die "Cant read music dir $music_dir: $!";
while(readdir MUSIC) {
    chomp;
    next if $_ eq '.';
    next if $_ eq '..';
    next unless /\.mp3$/;
    $dir_music{$_} = 1;
}
closedir (MUSIC);

my %pls_music;

open (PLS, "$pls") or die "Cant read playlist file $pls: $!";
while (<PLS>) {
    chomp;
    /^music\/(.*\.mp3)$/;
    $pls_music{$1} = 1;
    # Add this file to a new playlist, if it exists
    # in the directory.
    if (exists $dir_music{$1}) {
        push(@new_pls, $1);
    } else {
        # Skip adding this file and indicate, that new playlist should be
        # generated
        $regen_pls = 1;
    };
}
close(PLS);

foreach (keys %dir_music) {
    next if exists $pls_music{$_};
    # Add this file to a new playlist and indicate that it should be
    # regenerated
    push (@new_pls, $_);
    $regen_pls = 1;
}

if ($regen_pls)
{
    open(TMP, ">$tmp") or die "Cant write new pls tempfile $tmp: $!";
    foreach (@new_pls) {
        print TMP "music/$_\n";
    }
    close(TMP);

    unlink($pls) or die "Cant remove file $pls: $!";
    rename($tmp, $pls) or die "Cant rename $tmp to $pls: $!";
}
