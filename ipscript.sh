echo DEVICE=\"ens3:$2\" >> /etc/sysconfig/network-scripts/ifcfg-ens3:$2
echo BOOTPROTO = static >> /etc/sysconfig/network-scripts/ifcfg-ens3:$2
echo ONBOOT=yes >> /etc/sysconfig/network-scripts/ifcfg-ens3:$2
echo TYPE=Ethernet >> /etc/sysconfig/network-scripts/ifcfg-ens3:$2
echo IPADDR=$1 >> /etc/sysconfig/network-scripts/ifcfg-ens3:$2
echo NETMASK=255.255.255.0 >> /etc/sysconfig/network-scripts/ifcfg-ens3:$2