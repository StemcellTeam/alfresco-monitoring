#!/usr/bin/perl
use strict;
use warnings;

my @threads = qx(ps -ef | grep java | grep Bootstrap | grep -v grep | awk '{print \$2}' | xargs -I {} top -H -p {} -n 1 -b | grep java | head -10);
my @jstack = qx(ps -ef | grep java | grep Bootstrap | grep -v grep | awk '{print \$2}' | xargs -I {} jstack {});

print ("Top 10 threads by CPU usage\n");

foreach (@threads) {
    my ($PID, $USER, $PR, $NI, $VIRT, $RES, $SHR, $S, $CPU, $MEM, $TIME, $COMMAND) = split();
    printf ("nid:0x%x, CPU:%s\n", $PID, $CPU);
}
print ("\n");
print (@jstack);
