#cloud-config
runcmd:
- echo '${ip_addresses}' > /tmp/motd