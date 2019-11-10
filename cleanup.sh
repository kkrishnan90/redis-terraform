#! /bin/bash

echo "Emptying contents of hosts.yml and app-servers.conf in ansible..."
> ansible/hosts.yml
> ansible/app-servers.conf
sleep 1
echo "Emptying contents of privateips generated templates..."
rm -rf privateips/*
sleep 1