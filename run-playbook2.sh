#! /bin/bash
hosts=$(cat ansible/hosts.yml)
echo $hosts
ansible-playbook -i $hosts ansible/haproxy-ubuntu-book2.yml --forks=1