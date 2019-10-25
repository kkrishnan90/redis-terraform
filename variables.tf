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

variable "object_storage_name" {
}


variable "VCN_name" {}

variable "VCN_cidr" {}

variable "subnet_name" {}

variable "subnet_cidr" {}

variable "internet_gateway_name" {}

variable "route_table_name" {}



# Defines the number of volumes to create and attach to each instance
# NOTE: Changing this value after applying it could result in re-attaching existing volumes to different instances.
# This is a result of using 'count' variables to specify the volume and instance IDs for the volume attachment resource.
variable "NumIscsiVolumesPerInstance" {
  default = "1"
}

variable "NumParavirtualizedVolumesPerInstance" {
  default = "2"
}

variable "instance_shape" {
  default = "VM.Standard.E2.2"
}

output "Instance_Address" {
  value = ["${oci_core_instance.RedisInstance.*.public_ip}"]
}

variable "instance_image_ocid" {
  type = "map"

  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaoqj42sokaoh42l76wsyhn3k2beuntrh5maj3gmgmzeyr55zzrwwa"

    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaasorq3smbazoxvyqozz52ch5i5cexjojb7qvcefa5ubij2yjycy2a"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaitzn6tdyjer7jl34h2ujz74jwy5nkbukbh55ekp6oyzwrtfa4zma"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa32voyikkkzfxyo4xbdmadc2dmvorfxxgdhpnk6dw64fa3l4jh7wa"
  }
}

variable "DatasetSize" {}

variable "redis_mount_point"{}

variable "redis_port" {}

variable "cluster_port" {}

variable "redis_version" {}

variable "redis_ismaster" {}

variable "object_storage_url" {
  default = "https://objectstorage.${var.region}.oraclecloud.com${oci_objectstorage_preauthrequest.bucket_par.access_uri}"
}
variable "BootStrapFile" {
  default = "./userdata/bootstrap"
}

variable "tag_namespace_description" {
  default = "Just a test"
}

variable "tag_namespace_name" {
  default = "testexamples-tag-namespace"
}

variable "volume_attachment_device" {
  default = "/dev/oracleoci/oraclevdb"
}
