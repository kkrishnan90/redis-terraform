#! /bin/bash
hosts=$(cat ansible/hosts.yml)
echo $hosts
ansible-playbook -i $hosts ansible/haproxy-ubuntu-book1.yml --forks=1