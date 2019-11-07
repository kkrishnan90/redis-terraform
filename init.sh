#!/bin/bash
rm -rf privateips/*
rm -rf hosts.yml
git pull
terraform init
terraform plan
terraform output
terraform apply