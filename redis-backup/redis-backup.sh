#! /bin/bash
hosts=$(cat ansible/redis_hosts.yml)
echo $hosts
ansible-playbook -i $hosts ansible/haproxy-ubuntu.yml -vvv
