#base
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
yum -y install gcc make gcc-c++ kernel-devel-`uname -r` perl

#wget
yum -y install wget

#zip
yum -y install zip unzip

#Apache
yum -y install httpd
chkconfig httpd on

#set network interface
echo "DEVICE=eth0
BOOTPROTO=dhcp
ONBOOT=yes
USERCTL=yes" > /etc/sysconfig/network-scripts/ifcfg-eth0

#Disable iptables
chkconfig iptables off
chkconfig ip6tables off

#Set timezone
ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime 

