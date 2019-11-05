#!/bin/bash
sudo git pull
terraform init
terraform plan
terraform output
terraform apply -parallelism=1