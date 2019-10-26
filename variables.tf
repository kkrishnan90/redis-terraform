// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

variable "tenancy_ocid" {
  default="ocid1.tenancy.oc1..aaaaaaaal2fcg74ss6fcyolks6mwr2sb67mzczmvjar4ob4uny7lh5b3k4vq"
}
variable "user_ocid" {
  default="ocid1.user.oc1..aaaaaaaaacfec4cr2px7jc2fi4azb6db33lxmptagsqc7coicr25dujgkmqq"
}
variable "fingerprint" {
  default="60:d9:50:7c:d1:75:c9:5e:28:a5:85:76:d9:b7:e0:c2"
}
variable "region" {
  default="ap-mumbai-1"
}

variable "compartment_ocid" {
  default="ocid1.compartment.oc1..aaaaaaaa453zen2zclwt2yvddonuucttsatlgz6ymq73jeicubhifkp6qk7q"
}

variable "api_private_key_path"  {
  default="/home/opc/oci_api_key.pem"
}

variable "ssh_public_key_path" {
  default="/home/opc/pub_key.pem"
}

variable "ssh_private_key_path" {
  default="/home/opc/private_key_oci"
}

# Defines the number of instances to deploy
variable "NumInstances" {
  default = "1"
}


variable "instance_shape" {
  default = "VM.Standard.E2.1"
}

variable "ad_ocid" {
  default="ocid1.image.oc1.ap-mumbai-1.aaaaaaaa4tjx2itqin7msqxo42tmgp6vb66pdoqobxuk2nlxwbvb7ahfnvia"
}



variable "instance_image_ocid" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    ap-mumbai-1="ocid1.image.oc1.ap-mumbai-1.aaaaaaaapkhghx7pslvwrarurrztge4f4a3vlfy3kt3jd7vtxz4przfkmfvq"
  }
}

variable "BootStrapFile" {
  default = "./userdata/bootstrap"
}

variable "subnet_ocid" {
  default = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaapxrvrqrettfjowbaom475bwqr5xm6l5npmkl7vgoldhlq2uctukq"
}

variable "private_ip_count"{
  default = "1"
}