#! /bin/bash

echo "Emptying contents of hosts.yml in ansible..."
> ansible/hosts.yml
sleep 1
echo "Emptying contents of privateips generated templates..."
rm -rf privateips/*
sleep 1
reg='^[0-9]{8}$'
echo "How many(count) HAProxy do you want to provision ?"
read hap_count
if ! [[ "$hap_count" =~ ^[0-9]+$ ]] ;  then
  echo "HAP server counts cannot contains letters! Exiting..."
  sleep 1
  else
    echo "Checking app server count matches with HAProxy..."
    app_count=$(wc -l ansible/app-servers.conf | awk '{print $1}')
    sleep 1
    echo "App server count ${app_count}"
    if (( $app_count == 0 )) or (($hap_count == 0)) or (( $hap_count < $app_count ))
      then
        echo "Risk forseen !!!!! Your HAProxy counts are less than app server counts. Modify /terraform/ansible/app-servers.conf file (Add more app servers) ! Exiting..."
        sleep 1
      else
        echo "Let's check once again before we proceed..."
        if (($app_count/$hap_count == 2))
          then
            echo "Good to go ! Launch bash init.sh script to start provisioning infrastructure"
          else
            echo "Your app servers counts in odd number. Do you want to recheck ? If not, proceed launching bash init.sh script to provision infrastructure"
      fi
  fi
fi