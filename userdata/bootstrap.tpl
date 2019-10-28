#cloud-config
runcmd:
- cp /tmp/motd /home/opc/motd.bkp
- echo 'checking working command bootstrap ${primary_ip}' > motd.bkp
- for ip in ${secondary_ips} do ip => echo 'ip $ip' > motd.bkp done