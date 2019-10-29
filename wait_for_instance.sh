#!/bin/bash
while [ ! -f /var/lib/cloud/instance/boot-finished ]: do
    echo -e "\033[1;36Waiting for cloud-init..."
    sleep 1
done