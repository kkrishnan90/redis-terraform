#!/bin/bash
git pull
terraform init
terraform plan
terraform output
terraform apply