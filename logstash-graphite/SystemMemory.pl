#!/usr/bin/perl
use strict;
use warnings;
my @info = qx(cat /proc/meminfo | grep -e MemTotal -e MemFree -e SwapTotal -e SwapFree | grep -v grep | tr -d '\n' | awk '{print (\$2),(\$4),(\$6),(\$8)}');
foreach (@info) {
    my ($MemTotal, $MemFree, $SwapTotal, $SwapFree) = split();
    print (($MemTotal * 1024) . " " . ($MemFree * 1024) . " " . ($SwapTotal * 1024) . " " . ($SwapFree * 1024));
}
