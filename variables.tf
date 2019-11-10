// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

variable "tenancy_ocid" {}

variable "user_ocid" {}

variable "fingerprint" {}

variable "region" {}

variable "compartment_ocid" {}

variable "api_private_key_path" {}

variable "ssh_public_key_path" {}

variable "ssh_private_key_path" {}

variable "subnet_ocid" {}

variable "ad_number" {}

#### HAProxy Variables ###

# Defines the number of instances to deploy
variable "hap_instance_count" {
  default = "2"
}

variable "hap_instance_image_ocid" {}

variable "hap_ip_count" {}

variable "instance_shape" {
  default = "VM.Standard.E2.1"
}

#### App Variables

variable "app_instance_count" {}

variable "app_instance_shape" {}

variable "app_instance_image_ocid" {}

variable "app_subnet_ocid" {}

#### Load Balancer Variables
variable "load_balancer_count" {}

variable "load_balancer_shape" {}

variable "load_balancer_subnet_ocid" {}

variable "tenancy_name" {}







