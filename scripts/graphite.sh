#Install Graphite
mkdir -p /opt
mkdir -p /data
yum -y install python-pip
yum -y install gcc
yum -y install python-devel
pip install carbon
pip install whisper
pip install graphite-web
pip install -Iv 'https://www.djangoproject.com/download/1.5.5/tarball/'
pip install daemonize
pip install 'Twisted<12.0'
pip install tagging
pip install django-tagging
/bin/cp /tmp/settings.py /opt/graphite/webapp/graphite/settings.py
mkdir /data/graphite
yum -y install httpd
chown apache:apache /opt/graphite/storage/log/webapp/
yum -y install mod_wsgi
/bin/cp /opt/graphite/examples/example-graphite-vhost.conf  /etc/httpd/conf.d/graphite.conf
/bin/cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf
/bin/cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
/bin/cp /tmp/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
/bin/cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
/bin/cp /tmp/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
/bin/cp /tmp/graphite.conf /etc/httpd/conf.d/graphite.conf
cp /tmp/carbon.init /etc/init.d/carbon
chmod 755 /etc/init.d/carbon
/sbin/chkconfig httpd on
/sbin/chkconfig --add carbon
/sbin/chkconfig carbon on
mkdir /opt/graphite/storage/log/webapp
chown -R apache:root /opt/graphite/storage
chmod +x /opt/graphite/conf/graphite.wsgi
yum -y install cairo
yum -y install cairo-devel
yum -y install pycairo
yum -y install pycairo-devel
yum -y install mysql mysql-server MySQL-python
chkconfig mysqld on
service mysqld start
mysql -e "CREATE DATABASE graphite;" -u root
mysql -e "GRANT ALL PRIVILEGES ON graphite.* TO 'graphite'@'localhost' IDENTIFIED BY 'graphitePW01Vxzsigavms';" -u root
mysql -e 'FLUSH PRIVILEGES;' -u root
cd /opt/graphite/
echo no | python ./webapp/graphite/manage.py syncdb

#Install statsd
yum -y install git
git clone https://github.com/joyent/node.git
cd node
./configure && make && make install
cd /tmp
wget --no-check-certificate http://npmjs.org/install.sh
sh install.sh
/usr/local/bin/npm install express
git clone https://github.com/etsy/statsd.git
mv /tmp/statsd /opt/graphite
/bin/cp /tmp/local.js /opt/graphite/statsd/local.js
/bin/cp /tmp/statsd.init /etc/init.d/statsd
chmod 755 /etc/init.d/statsd
/sbin/chkconfig --add statsd
chkconfig statsd on

#Install Grafana
tar xvfz /tmp/grafana-1.8.0.tar.gz -C /var/www/html/
ln -s /var/www/html/grafana-1.8.0 /var/www/html/grafana
/bin/cp /tmp/config.js /var/www/html/grafana/
service httpd restart

#Cleanup
/bin/rm -rf /tmp/statsd
/bin/rm -rf /tmp/node
/bin/rm -rf /tmp/node_modules
/bin/rm /tmp/carbon.init
/bin/rm /tmp/config.js
/bin/rm /tmp/grafana-1.8.0.tar.gz
/bin/rm /tmp/graphite.conf
/bin/rm /tmp/graphite-web.conf
/bin/rm /tmp/local.js
/bin/rm /tmp/local_settings.py
/bin/rm /tmp/settings.py
/bin/rm /tmp/statsd.init
/bin/rm /tmp/storage-schemas.conf
/bin/rm /tmp/wsgi.conf
