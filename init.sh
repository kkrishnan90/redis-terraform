#!/bin/bash
terraform init
terraform plan
terraform output
terraform apply
sleep 5
echo "Running playbook to configure HAProxy..."
bash run-appbook1.sh
sleep 3
echo "Running playbook to configure HAProxy..."
bash run-playbook1.sh
sleep 3
# echo "Running cleanup script to cleanup directories..."
# bash cleanup.sh