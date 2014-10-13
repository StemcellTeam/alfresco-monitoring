#Java JDK
cd /tmp
rpm -ivh ./jre-7-linux-x64.rpm

#Install Elasticsearch
cd /tmp
rpm -ivh ./elasticsearch-1.3.2.noarch.rpm
chkconfig --add elasticsearch
chkconfig elasticsearch on
/bin/cp elasticsearch.yml /etc/elasticsearch/
mkdir /usr/local/elasticsearch/maintenance
/bin/cp /tmp/elasticsearch-remove-old-indices.sh /usr/local/elasticsearch/maintenance/
echo "00 4 * * * root /usr/share/elasticsearch/bin//maintenance/elasticsearch-remove-old-indices.sh" >> /etc/crontab
/bin/cp /tmp/elasticsearch-remove-old-indices.sh /usr/share/elasticsearch/bin/

#Install Logstash
cd /tmp
rpm -ivh ./logstash-1.4.2-1_2c0f5a1.noarch.rpm
chkconfig --add logstash
chkconfig logstash on
/bin/cp /tmp/logstash.conf /etc/logstash/conf.d/
tar xvfz logstash-contrib-1.4.2.tar.gz
/bin/cp -r /tmp/logstash-contrib-1.4.2/* /opt/logstash/

#Install Kibana
cd /tmp
unzip ./kibana-3.1.0.zip -d /var/www/html
ln -s /var/www/html/kibana-3.1.0 /var/www/html/kibana

#Install Redis
rpm -ivh ./remi-release-6*.rpm epel-release-6*.rpm
yum -y install redis
chkconfig --add redis
chkconfig redis on
/bin/cp redis.conf /etc/

#Cleanup
/bin/rm /tmp/elasticsearch-1.3.2.noarch.rpm
/bin/rm /tmp/epel-release-6-8.noarch.rpm
/bin/rm /tmp/jre-7-linux-x64.rpm
/bin/rm /tmp/kibana-3.1.0.zip
/bin/rm /tmp/logstash-1.4.2-1_2c0f5a1.noarch.rpm
/bin/rm /tmp/logstash-contrib-1.4.2.tar.gz
/bin/rm /tmp/remi-release-6.rpm
/bin/rm /tmp/elasticsearch.yml
/bin/rm /tmp/logstash.conf
/bin/rm /tmp/redis.conf
/bin/rm -rf /tmp/logstash-contrib-1.4.2
/bin/rm /tmp/elasticsearch-remove-old-indices.sh
