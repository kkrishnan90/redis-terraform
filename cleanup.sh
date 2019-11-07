#! /bin/bash

> ansible/hosts.yml
rm -rf privateips/*
app_servers_count=wc -l ansible/app-servers.conf | awk '{ print $1 }'
$app_servers_count % 2 ? echo "Good to go ahead !" : echo "App servers cannot be odd in number"