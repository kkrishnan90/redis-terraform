// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "region" {}

variable "compartment_ocid" {}

variable "api_private_key_path"  {}

variable "ssh_public_key_path" {}

variable "ssh_private_key_path" {}

# Defines the number of instances to deploy
variable "NumInstances" {
  default = "1"
}


variable "instance_shape" {
  default = "VM.Standard.E2.1"
}

output "Instance_Address" {
  value = ["${oci_core_instance.RedisInstance.*.public_ip}"]
}

variable "instance_image_ocid" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    ap-mumbai-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaa4tjx2itqin7msqxo42tmgp6vb66pdoqobxuk2nlxwbvb7ahfnvia"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaoqj42sokaoh42l76wsyhn3k2beuntrh5maj3gmgmzeyr55zzrwwa"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaasorq3smbazoxvyqozz52ch5i5cexjojb7qvcefa5ubij2yjycy2a"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaitzn6tdyjer7jl34h2ujz74jwy5nkbukbh55ekp6oyzwrtfa4zma"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa32voyikkkzfxyo4xbdmadc2dmvorfxxgdhpnk6dw64fa3l4jh7wa"
  }
}


