#!/usr/bin/perl
use strict;
use warnings;

my $AlfrescoSearcher_avgTimePerRequest = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=/alfresco,id=org.apache.solr.handler.component.SearchHandler -A avgTimePerRequest --username controlRole --password change_asap | awk '{print \$6}');
my $AFTSSearcher_avgTimePerRequest = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=/afts,id=org.apache.solr.handler.component.SearchHandler -A avgTimePerRequest --username controlRole --password change_asap | awk '{print \$6}');
my $CMISSearcher_avgTimePerRequest = qx(java -jar ./check_jmx.jar -U service:jmx:rmi:///jndi/rmi://localhost:50500/alfresco/jmxrmi -O solr/alfresco:type=/cmis,id=org.apache.solr.handler.component.SearchHandler -A avgTimePerRequest --username controlRole --password change_asap | awk '{print \$6}');

chomp($AlfrescoSearcher_avgTimePerRequest);
chomp($AFTSSearcher_avgTimePerRequest);
chomp($CMISSearcher_avgTimePerRequest);

my $output = $AlfrescoSearcher_avgTimePerRequest ." ". $AFTSSearcher_avgTimePerRequest ." ". $CMISSearcher_avgTimePerRequest;
$output =~ s/NaN/0.0/g;
print $output;
