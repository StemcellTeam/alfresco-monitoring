#Java JDK
cd /tmp/alfresco-monitoring-master/elasticsearch_software_packages
rpm -ivh ./jre-7-linux-x64.rpm


#Install Elasticsearch
cd /tmp/alfresco-monitoring-master/elasticsearch_software_packages
rpm -ivh ./elasticsearch-1.3.2.noarch.rpm
chkconfig --add elasticsearch
chkconfig elasticsearch on
/bin/cp elasticsearch.yml /etc/elasticsearch/
echo "00 4 * * * root /usr/share/elasticsearch/bin/elasticsearch-remove-old-indices.sh" >> /etc/crontab
/bin/cp /tmp/alfresco-monitoring-master/elasticsearch_software_packages/elasticsearch-remove-old-indices.sh /usr/share/elasticsearch/bin/

#Install Logstash
cd /tmp/elasticsearch_software_packages
rpm -ivh ./logstash-1.4.2-1_2c0f5a1.noarch.rpm
chkconfig --add logstash
chkconfig logstash on
/bin/cp /tmp/alfresco-monitoring-master/elasticsearch_software_packages/logstash.conf /etc/logstash/conf.d/
tar xvfz logstash-contrib-1.4.2.tar.gz
/bin/cp -r /tmp/alfresco-monitoring-master/elasticsearch_software_packages/logstash-contrib-1.4.2/* /opt/logstash/

#Install Kibana
cd /tmp/elasticsearch_software_packages
unzip ./kibana-3.1.0.zip -d /var/www/html
ln -s /var/www/html/kibana-3.1.0 /var/www/html/kibana

#Install Redis
rpm -ivh ./remi-release-6*.rpm epel-release-6*.rpm
yum -y install redis
chkconfig --add redis
chkconfig redis on
/bin/cp redis.conf /etc/

#Cleanup
/bin/rm -rf /tmp/alfresco-monitoring-master/elasticsearch_software_packages
