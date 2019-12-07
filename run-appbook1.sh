#! /bin/bash
hosts=$(cat ansible/app-hosts.yml)
echo $hosts
ansible-playbook -i $hosts ansible/appserver-ubuntu-book2.yml --forks=1