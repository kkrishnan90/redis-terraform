#! /bin/bash
sudo su
echo "root soft nofile 10000000" >> /etc/security/limits.conf
echo "root hard nofile 10000000" >> /etc/security/limits.conf
echo "fs.file-max = 10000000" >> /etc/sysctl.conf
echo "fs.nr_open = 10000000" >> /etc/sysctl.conf