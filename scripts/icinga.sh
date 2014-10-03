#Install Icinga
rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
yum -y install icinga icinga-doc
yum -y install icinga-gui
usermod -aG icinga apache
/bin/cp /tmp/icinga.cfg /etc/icinga/
/bin/cp /tmp/alfresco-NodeX.cfg /etc/icinga/objects/
/bin/cp /tmp/alfresco-commands.cfg /etc/icinga/objects/
chown -R icinga:icinga /var/spool/icinga/*
chgrp -R icinga /etc/icinga/*
chgrp -R icinga /usr/lib64/icinga/*
chgrp -R icinga /usr/share/icinga/*
mkdir -p /usr/lib64/icinga/plugins
mkdir -p /usr/lib64/nagios/
/bin/cp /tmp/check_alfresco /usr/lib64/icinga/plugins/
/bin/cp /tmp/check_alfresco.jar /usr/lib64/icinga/plugins/
ln -s /usr/lib64/icinga/plugins /usr/lib64/nagios
chown -R icinga:root /usr/lib64/icinga
chown -R icinga:root /usr/lib64/nagios
cp /tmp/alfresco.gif /usr/share/icinga/images/logos/
yum -y install nagios-plugins-all
service httpd restart
service icinga restart

#Cleanup
/bin/rm /tmp/check_alfresco
/bin/rm /tmp/check_alfresco.jar
/bin/rm /tmp/alfresco.gif
/bin/rm /tmp/alfresco-NodeX
/bin/rm /tmp/alfresco-commands.cfg
/bin/rm /tmp/icinga.cfg
