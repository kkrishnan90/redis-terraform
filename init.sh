#!/bin/bash
terraform init
terraform plan
terraform output
terraform apply
sleep 5
echo "Running playbook to configure HAProxy..."
bash run-playbook1.sh