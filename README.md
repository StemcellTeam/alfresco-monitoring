#alfresco-monitoring


What is it?
-----------

This project is a solution to monitor Alfresco software (http://www.alfresco.com/) with OpenSource tools. 
Note that these tools can be used to monitor most software i.e. a database server, so we can use them to monitor the solution not just one application.

These tools have been configured to run on Linux servers only so if you are going to run the on a different Operating System you may have to make some changes.

The OpenSource tools used are:

- Logstash - for collecting/tailing log files and output from custom commands and pushing data to ElasticSearch and Graphite.
- ElasticSearch - Lucene engine to index content.
- Kibana -  browser based analytics and search dashboard for ElasticSearch.
- Graphite - for collecting and storing time series data in real time.
- Granafa - feature rich metrics dashboard and graph editor for Graphite.
- Icinga - monitoring system for checking hosts and services and notifying you when things go wrong and when they recover.

Installation
------------

This project uses packer (http://www.packer.io/) software to build a virtual machine from zero (including the Operating System) and installs the software packages automatically using the "monitoring_template.json" file as the guide to build the virtual machine and provision it with the required software.

First install packer on your local computer and the software to run your virtual machine i.e. VirtualBox, VMWare, QEMU, etc.

Then use the packer command to build the Virtual Machine and install the software. For example to build a VirtualBox appliance use:

```# packer build -only virtualbox-iso monitoring_template.json```

This command will launch VirtualBox, download the ISO file for Centos 6.5, install it based on the ```http/ks.cfg``` file and run the shell scripts under the scripts directory as specified in the ```monitoring_template.json``` template file.

On completion the VirtualBox files will be stored in the ```output-virtualbox-iso``` folder. This folder will contain the VMDK and OVF files needed by VirtualBox to run the virtual machine.

You can adjust the template file to install additional software and to meet your own requirements.

Post-Installation
-----------------

- Run the virtual machine and login using alfresco/alfresco as the username/password
- Run "sudo su" to become root user. Edit ```/etc/hosts``` file and add the IP and hostname for the virtual machine i.e.
    ```
    192.168.1.10 alfrescoMonitor
    ```

Please note that this IP address should be in the same network as Alfresco's nodes IP addresses as they need to be able to communicate between them. 
- Edit ```/etc/sysconfig/network-scripts/ifcfg-eth0``` and assign the same IP address to this interface i.e.
```
DEVICE=eth0
BOOTPROTO=static
IPADDR=192.168.1.10
NETMASK=255.255.255.0
ONBOOT=yes
USERCTL=yes
```
- Also add the IP address and the hostname of your Alfresco nodes to this file.
- Add your Alfresco host details to Icinga ```/etc/icinga/icinga.cfg``` (bottom of the file)
- And create a new commands file for each host in ```/etc/icinga/objects``` using alfresco-NodeX.cfg as a template, just replace "NodeX" with the hostname of your Alfresco node.
 

What to do/change in Alfresco
-----------------------------

- Edit ```/etc/hosts``` and add alfrescoMonitor hostname pointing to the IP address of the monitoring server virtual machine.
- Change the following entry alfresco, solr and share log4j properties file to use full date time stamp in the log files:
```log4j.appender.File.layout.ConversionPattern=%d{yyyy-MM-dd} %d{ABSOLUTE} %-5p [%c] %m%n```
- Copy ```logstash-elasticsearch``` and ```logstash-graphite``` folders to the alfresco node(s).
- On each folder edit logstash.conf file and change the paths to point to your alfresco installation.
Edit ```logstash-elasticsearch/audit.sh``` script and make sure alfresco path is pointing to the correct location.
Enable auditing in Alfresco if required. You only need to run ```audit.sh``` script in one of the Alfresco nodes so you can comment it out from ```logstas-elasticsearch/run_logstash.sh``` on the other nodes.
- Exectute the following command on each folder to start sending data to the monitoring server.
    
```# run_logstash.sh start```

Then you can stop it with

```# run_logstash.sh stop```
- If Icinga can not connect to Alfreso RMI service then add the following java option to Alfresco: ```-Djava.rmi.server.hostname=<hostname>``` and restart Alfresco application.

Setting up Kibana
-----------------

On your browser enter the url for kibana [http://alfrescoMonitor/kibana](http://alfrescoMonitor/kibana)

Click on the "Load" icon (open folder), then select "Advanced" and then"Choose file". Select the file ```frontEndsConfig/kibana/Kibana-Alfresco```. This should bring the dashboard configuration.

Next click on the "Save" icon and save the dashboard as "Alfresco"

Now when you click on the "Load" icon the "Alfresco" dashboard will be avaible for your. You can also set this dashboard as the home dashboard (Save->Advanced->Save as Home) so it is loaded automatically when you enter kibana.

You can also load "Alfresco-Transactions" dashboard to Kibana. This dashboard is used to monitor transactions such as CREATE, READ, UPDATE, CHECK-IN, CHECK-OUT, SEARCH. This dashboard takes input from Alfresco audit entries and Solr searches debugging so the following configuration is required in Alfresco.

- Edit ```alfresco-global.properties``` file and add the following entries to enable auditing.

```
audit.enabled=true
audit.alfresco-access.enabled=true
audit.tagging.enabled=true
audit.alfresco-access.sub-actions.enabled=true
audit.cmischangelog.enabled=true
```

Then add the following entry to Alfresco's ```log4j.properties``` file:

```
log4j.logger.org.alfresco.repo.search.impl.solr.SolrQueryHTTPClient=debug
```

Restart Alfresco application for these two changes to take effect. Please note that the ```logstash-elasticsearch/audit.sh``` script should be run only from one of the Alfresco nodes so you should comment out these entries in the ```logstash-elasticsearch/run_logstash.sh``` file on the other nodes:

```
  nohup ./audit.sh 1>audit.log &>audit.log &
```

and 

```
  ps -ef | grep "/bin/sh ./audit.sh" | grep -v grep | awk '{print $2}' | xargs -I {} kill -9 {}
```

Setting up grafana
------------------

Edit the text files ```frontEndsConfig/grafana/Alfresco-NodeX``` and "frontEndsConfig/grafana/Solr Caches-NodeX" and replace all instances of "NodeX" with the hostname of your Alfresco server. Create a new file for each Alfresco node.

On your browser enter the url for grafana [http://alfrescoMonitor/granfa](http://alfrescoMonitor/granfa)

Click on the "Search" icon (open folder), then select "Import" and then "Choose file". Select the files ```frontEndsConfig/grafana/Alfresco-NodeX```. This should bring the dashboard configuration. Next click on the "Save" icon and save the dashboard as "Alfresco-<node name>". 

We need to repeat the same operation for the file "Solr Caches-NodeX" so click on the "Search" icon (open folder), then select "Import" and then"Choose file". Select the file ```frontEndsConfig/grafana/Solr Caches-NodeX```. This should bring the dashboard configuration. Next click on the "Save" icon and save the dashboard as "Solr Caches-<node name>"

Now when clicking on "Search" icon you should have the dashboards available to choose from.

Repeat the same import/save operation for each of the Alfresco nodes.

Setting up Icinga
-----------------

Icinga web application is available at [http://alfrescoMonitor/icinga](http://alfrescoMonitor/icinga). The default username and password are "icingaadmin" and "icingaadmin".

The thresholds for the commands and Alfresco paths are defined in ```/etc/icinga/objects/alfresco-<node name>.cfg``` file. You will need to adjust these values to meet your application requirements.

Edit /etc/icinga/icinga.cfg and set the email address for notifications; the default one is icinga@localhost. Then edit /etc/ssmtp/ssmtp.cf and configure the mail options for external emails. 

Setting up NGINX access logs
----------------------------
If you are using NGINX (```http://nginx.org/en/```) as a HTTP proxy server to access Alfresco you can process the access logs generated by NGINX and display request response time in Kibana (Alfresco-Transactions dashboard). To do this you need to edit nginx.conf file and enable logging settings in the ```http``` section i.e.:

```
        ##
        # Logging Settings
        ##

        log_format timed_combined '$remote_addr - $remote_user [$time_local] '
        '"$request" $status $body_bytes_sent '
        '"$http_referer" "$http_user_agent" '
        '$request_time $upstream_response_time $pipe';

        access_log /var/log/nginx/access.log timed_combined;
        error_log /var/log/nginx/error.log;
```

Restart NGINX after this changes. Make sure ```logstash-elasticsearch/logstash.conf``` is pointing to the correct path for NGINX access log.

Setting up Tomcat access logs
-----------------------------
If you want to Tomcat HTTP response times and display the data in Kibana (Alfresco-Transactions dashboard) you need to edit tomcat/conf/server.xml file and enable access logging settings i.e.:

```
        <!-- Access logs -->
        <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
        prefix="access-" suffix=".log"
        pattern='%a %l %u %t "%r" %s %b "%{Referer}i" "%{User-agent}i" %T "%I"'
        resolveHosts="false"/>
```

Restart Tomcat after this changes. Make sure ```logstash-elasticsearch/logstash.conf``` is pointing to the correct path for Tomcat access log.

Alfresco Monitoring URLs
------------------------

Finally bookmark your URLs for quick access:
- [http://alfrescoMonitor/kibana](http://alfrescoMonitor/kibana)
- [http://alfrescoMonitor/granfa](http://alfrescoMonitor/granfa)
- [http://alfrescoMonitor/icinga](http://alfrescoMonitor/icinga)
