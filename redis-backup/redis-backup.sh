#! /bin/bash
hosts=$(cat redis-hosts.conf)
echo $hosts
ansible-playbook -i $hosts redis-backup-book.yml