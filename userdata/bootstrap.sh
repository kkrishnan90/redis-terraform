#!/bin/bash
sudo yum update -y
echo 'This instance was provisioned by Terraform user data bootstrap script' >> /etc/motd