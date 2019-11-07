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

# Defines the number of instances to deploy
variable "hap_instance_count" {
  default = "2"
}

variable "hap_instance_image_ocid" {}

variable "hap_ip_count" {}

variable "instance_shape" {
  default = "VM.Standard.E2.1"
}



