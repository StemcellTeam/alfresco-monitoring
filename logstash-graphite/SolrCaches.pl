#!/usr/bin/perl
use strict;
use warnings;

my $DocumentCache_CummulativeHitRatio = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=documentCache,id=org.apache.solr.search.LRUCache -A cumulative_hitratio --username controlRole --password change_asap | awk '{print \$6}');
my $DocumentCache_CummulativeEvictions = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=documentCache,id=org.apache.solr.search.LRUCache -A cumulative_evictions --username controlRole --password change_asap | awk '{print \$6}');
my $DocumentCache_CummulativeInserts = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=documentCache,id=org.apache.solr.search.LRUCache -A cumulative_inserts --username controlRole --password change_asap | awk '{print \$6}');
my $DocumentCache_CummulativeLookups = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=documentCache,id=org.apache.solr.search.LRUCache -A cumulative_lookups --username controlRole --password change_asap | awk '{print \$6}');

my $QueryResultCache_CummulativeHitRatio = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=queryResultCache,id=org.apache.solr.search.LRUCache -A cumulative_hitratio --username controlRole --password change_asap | awk '{print \$6}');
my $QueryResultCache_CummulativeEvictions = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=queryResultCache,id=org.apache.solr.search.LRUCache -A cumulative_evictions --username controlRole --password change_asap | awk '{print \$6}');
my $QueryResultCache_CummulativeInserts = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=queryResultCache,id=org.apache.solr.search.LRUCache -A cumulative_inserts --username controlRole --password change_asap | awk '{print \$6}');
my $QueryResultCache_CummulativeLookups = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=queryResultCache,id=org.apache.solr.search.LRUCache -A cumulative_lookups --username controlRole --password change_asap | awk '{print \$6}');

my $AlfrescoCache_CummulativeHitRatio = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoCache,id=org.apache.solr.search.FastLRUCache -A cumulative_hitratio --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoCache_CummulativeEvictions = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoCache,id=org.apache.solr.search.FastLRUCache -A cumulative_evictions --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoCache_CummulativeInserts = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoCache,id=org.apache.solr.search.FastLRUCache -A cumulative_inserts --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoCache_CummulativeLookups = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoCache,id=org.apache.solr.search.FastLRUCache -A cumulative_lookups --username controlRole --password change_asap | awk '{print \$6}');

my $AlfrescoAuthorityCache_CummulativeHitRatio = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoAuthorityCache,id=org.apache.solr.search.FastLRUCache -A cumulative_hitratio --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoAuthorityCache_CummulativeEvictions = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoAuthorityCache,id=org.apache.solr.search.FastLRUCache -A cumulative_evictions --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoAuthorityCache_CummulativeInserts = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoAuthorityCache,id=org.apache.solr.search.FastLRUCache -A cumulative_inserts --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoAuthorityCache_CummulativeLookups = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoAuthorityCache,id=org.apache.solr.search.FastLRUCache -A cumulative_lookups --username controlRole --password change_asap | awk '{print \$6}');

my $AlfrescoPathCache_CummulativeHitRatio = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoPathCache,id=org.apache.solr.search.FastLRUCache -A cumulative_hitratio --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoPathCache_CummulativeEvictions = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoPathCache,id=org.apache.solr.search.FastLRUCache -A cumulative_evictions --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoPathCache_CummulativeInserts = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoPathCache,id=org.apache.solr.search.FastLRUCache -A cumulative_inserts --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoPathCache_CummulativeLookups = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoPathCache,id=org.apache.solr.search.FastLRUCache -A cumulative_lookups --username controlRole --password change_asap | awk '{print \$6}');

my $AlfrescoReaderToAclIdsCache_CummulativeHitRatio = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoReaderToAclIdsCache,id=org.apache.solr.search.FastLRUCache -A cumulative_hitratio --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoReaderToAclIdsCache_CummulativeEvictions = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoReaderToAclIdsCache,id=org.apache.solr.search.FastLRUCache -A cumulative_evictions --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoReaderToAclIdsCache_CummulativeInserts = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoReaderToAclIdsCache,id=org.apache.solr.search.FastLRUCache -A cumulative_inserts --username controlRole --password change_asap | awk '{print \$6}');
my $AlfrescoReaderToAclIdsCache_CummulativeLookups = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=alfrescoReaderToAclIdsCache,id=org.apache.solr.search.FastLRUCache -A cumulative_lookups --username controlRole --password change_asap | awk '{print \$6}');

chomp($DocumentCache_CummulativeHitRatio);
chomp($DocumentCache_CummulativeEvictions);
chomp($DocumentCache_CummulativeInserts);
chomp($DocumentCache_CummulativeLookups);

chomp($QueryResultCache_CummulativeHitRatio);
chomp($QueryResultCache_CummulativeEvictions);
chomp($QueryResultCache_CummulativeInserts);
chomp($QueryResultCache_CummulativeLookups);

chomp($AlfrescoCache_CummulativeHitRatio);
chomp($AlfrescoCache_CummulativeEvictions);
chomp($AlfrescoCache_CummulativeInserts);
chomp($AlfrescoCache_CummulativeLookups);

chomp($AlfrescoAuthorityCache_CummulativeHitRatio);
chomp($AlfrescoAuthorityCache_CummulativeEvictions);
chomp($AlfrescoAuthorityCache_CummulativeInserts);
chomp($AlfrescoAuthorityCache_CummulativeLookups);

chomp($AlfrescoPathCache_CummulativeHitRatio);
chomp($AlfrescoPathCache_CummulativeEvictions);
chomp($AlfrescoPathCache_CummulativeInserts);
chomp($AlfrescoPathCache_CummulativeLookups);

chomp($AlfrescoReaderToAclIdsCache_CummulativeHitRatio);
chomp($AlfrescoReaderToAclIdsCache_CummulativeEvictions);
chomp($AlfrescoReaderToAclIdsCache_CummulativeInserts);
chomp($AlfrescoReaderToAclIdsCache_CummulativeLookups);

print ($DocumentCache_CummulativeHitRatio ." ". $DocumentCache_CummulativeEvictions ." ". $DocumentCache_CummulativeInserts ." ". $DocumentCache_CummulativeLookups." ". $QueryResultCache_CummulativeHitRatio ." ". $QueryResultCache_CummulativeEvictions ." ". $QueryResultCache_CummulativeInserts ." ". $QueryResultCache_CummulativeLookups ." ". $AlfrescoCache_CummulativeHitRatio ." ". $AlfrescoCache_CummulativeEvictions ." ". $AlfrescoCache_CummulativeInserts ." ". $AlfrescoCache_CummulativeLookups ." ". $AlfrescoAuthorityCache_CummulativeHitRatio ." ". $AlfrescoAuthorityCache_CummulativeEvictions ." ". $AlfrescoAuthorityCache_CummulativeInserts ." ". $AlfrescoAuthorityCache_CummulativeLookups ." ". $AlfrescoPathCache_CummulativeHitRatio ." ". $AlfrescoPathCache_CummulativeEvictions ." ". $AlfrescoPathCache_CummulativeInserts ." ". $AlfrescoPathCache_CummulativeLookups ." ". $AlfrescoReaderToAclIdsCache_CummulativeHitRatio ." ". $AlfrescoReaderToAclIdsCache_CummulativeEvictions ." ". $AlfrescoReaderToAclIdsCache_CummulativeInserts ." ". $AlfrescoReaderToAclIdsCache_CummulativeLookups);
