#! /bin/bash
# export PATH=$PATH:/usr/bin   ###make sure add OCI CLI and curl command paths here.
# REGION=$(curl -L http://169.254.169.254/opc/v1/instance/canonicalRegionName 2> /dev/null)
# INST_OCID=$(curl -L http://169.254.169.254/opc/v1/instance/id 2> /dev/null)
# VNIC_OCID=$(oci compute instance list-vnics --instance-id $INST_OCID --region $REGION --output table --query "data [*].id"|grep ocid|cut -f 2 -d"|")
 
# echo "#! /bin/bash > /etc/rc.local"
# echo "## below lines added to bind additional private IPs needed by HA_proxy" >> /etc/rc.local
# chmod +x /etc/rc.local
# systemctl enable rc.local

# for i in {1..10}
# do
#   PRIV_IP=$(oci network vnic assign-private-ip --vnic-id $VNIC_OCID  --region $REGION --query "data.\"ip-address\""|sed 's/"//g')
#   ####Provide the correct device name(ens3) and gateway IP below.
 
#   ip a add $PRIV_IP/24 dev ens3:$i
 
#   echo "ip a add $PRIV_IP/24 dev ens3:$i" >> /etc/rc.local
 
# done