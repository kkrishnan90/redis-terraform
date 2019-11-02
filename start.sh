#!/bin/bash
sudo git pull
terraform init
terraform plan
terraform refresh
terraform output
terraform apply