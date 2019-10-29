#! /bin/bash 
 
export PATH=$PATH:/usr/bin   ###make sure add OCI CLI and curl command paths here.
 
REGION=$(curl -L http://169.254.169.254/opc/v1/instance/canonicalRegionName 2> /dev/null)
INST_OCID=$(curl -L http://169.254.169.254/opc/v1/instance/id 2> /dev/null)
VNIC_OCID=$(oci compute instance list-vnics --instance-id $INST_OCID --region $REGION --output table --query "data [*].id"|grep ocid|cut -f 2 -d"|")
 
for i in {1..10}
 
do
 
  PRIV_IP=$(oci network vnic assign-private-ip --vnic-id $VNIC_OCID  --region $REGION --query "data.\"ip-address\""|sed 's/"//g')
 
  ####Provide the correct device name(ens3) and gateway IP below.
 
  echo "DEVICE="ens3:$i"" >> /etc/sysconfig/network-scripts/ifcfg-ens3:$i
  echo "BOOTPROTO=static" >> /etc/sysconfig/network-scripts/ifcfg-ens3:$i
  echo "ONBOOT=yes" >> /etc/sysconfig/network-scripts/ifcfg-ens3:$i
  echo "TYPE="Ethernet"" >> /etc/sysconfig/network-scripts/ifcfg-ens3:$i
  echo "IPADDR=$PRIV_IP" >> /etc/sysconfig/network-scripts/ifcfg-ens3:$i
  echo "NETMASK=255.255.255.0" >> /etc/sysconfig/network-scripts/ifcfg-ens3:$i
 
  ifup ens3:$i
 
done