#!/bin/bash
 
cp /etc/motd /etc/motd.bkp
cat << EOF &gt; /etc/motd
 
I have been modified by cloud-init at $(date)
 
EOF