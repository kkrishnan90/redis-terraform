#cloud-config
runcmd:
- cp /tmp/motd /home/opc/motd.bkp
- echo 'checking working command bootstrap ${ip}' > motd.bkp