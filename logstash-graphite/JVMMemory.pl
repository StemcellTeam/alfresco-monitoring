#!/usr/bin/perl
use strict;
use warnings;
my @info = qx(ps -ef | grep java | grep Bootstrap | grep -v grep | awk '{print \$2}' | xargs -I {} jstat -gc -t {} 1 1 | grep -v Timestamp | grep -v grep | sed -e 's/ \+ / /g' | awk '{print \$4, \$5, \$6, \$7, \$8, \$9, \$10, \$11}');
foreach (@info) {
    my ($S0U, $S1U, $EdenCommitted, $EdenUsed, $OldCommitted, $OldUsed, $PermanentCommitted, $PermanentUsed) = split();
    #print (($EdenCommitted * 1024) . " " . ($EdenUsed * 1024) . " " . ($OldCommitted * 1024) . " " . ($OldUsed * 1024) . " " . ($S0C + $S1C + $EdenCommitted + $OldCommitted + $PermanentCommitted));
    print (($EdenCommitted * 1024) . " " . ($EdenUsed * 1024) . " " . ($OldCommitted * 1024) . " " . ($OldUsed * 1024)  . " " . ($PermanentCommitted * 1024) . " " . ($PermanentUsed * 1024) . " " . (($EdenUsed * 1024) + ($OldUsed * 1024) + ($PermanentUsed * 1024)) . " " . (($EdenCommitted * 1024) + ($OldCommitted * 1024) + ($PermanentCommitted * 1024)));
}
