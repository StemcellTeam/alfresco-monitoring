#alfresco-monitoring


What is it?
-----------

This project is a solution to monitor Alfresco software (http://www.alfresco.com/) with Open Source tools. 
Note that these tools can be used to monitor most software i.e. a database server, so we can use them to monitor the solution not just one application.

These tools have been configured to run on Linux servers only. Work will be done in a near future to have this monitoring solution running on Windows OS too.

The Open Source tools used are:

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

Edit the ```monitoring_variables.json``` file to provision it with the details for the host, username, password and paths to the software packages provided in the project (elasticsearch, graphite and icinga). Personally I leave them on my local computer and provision the ```monitoring_variables.json``` file with the login details to my computer, for example:

```
{
    "ssh_host": "xxx.xxx.xxx.xxx",
    "ssh_username": "my_username",
    "ssh_password": "my_password",
    "ssh_elasticsearch": "/opt/alfresco-monitoring/elasticsearch_software_packages",
    "ssh_graphite": "/opt/alfresco-monitoring/graphite_software_packages",
    "ssh_icinga": "/opt/alfresco-monitoring/icinga_software_packages"
 }
``` 

Then use the packer command to build the Virtual Machine and install the software. For example to build a VirtualBox appliance use:

```# packer build -var-file=monitoring_variables.json -only virtualbox-iso monitoring_template.json```

This command will launch VirtualBox, download the ISO file for Centos 6.5, install it based on the ```http/ks.cfg``` file and run the shell scripts under the scripts directory as specified in the ```monitoring_template.json``` template file.

On completion the VirtualBox files will be stored in the ```output-virtualbox-iso``` folder. This folder will contain the VMDK and OVF files needed by VirtualBox to run the virtual machine.

You can adjust the template file to install additional software and to meet your own requirements.

Post-Installation
-----------------

- Run the virtual machine and login using alfresco/alfresco as the username/password
- Run "sudo su" to become root user. Edit ```/etc/hosts``` file and add the IP and hostname for the virtual machine i.e.
    ```
    10.123.12.123 alfrescoMonitor
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

Edit /etc/icinga/icinga.cfg and set the email address for the notification; the default one is icinga@localhost. Then edit /etc/ssmtp/ssmtp.cf and configure the mail options for external emails. 

Alfresco Monitoring URLs
------------------------

Finally bookmark your URLs for quick access:
- [http://alfrescoMonitor/kibana](http://alfrescoMonitor/kibana)
- [http://alfrescoMonitor/granfa](http://alfrescoMonitor/granfa)
- [http://alfrescoMonitor/icinga](http://alfrescoMonitor/icinga)

