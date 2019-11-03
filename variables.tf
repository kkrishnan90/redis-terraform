// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

variable "tenancy_ocid" {
}
variable "user_ocid" {
}
variable "fingerprint" {
}
variable "region" {
}

variable "compartment_ocid" {
}

variable "api_private_key_path"  {
}

variable "ssh_public_key_path" {
}

variable "ssh_private_key_path" {
}

# Defines the number of instances to deploy
variable "NumInstances" {
  default = "1"
}


variable "instance_shape" {
  default = "VM.Standard.E2.1"
}




variable "instance_image_ocid" {
  type = "map"

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-provided image "Oracle-Linux-7.5-2018.10.16-0"
    # ap-mumbai-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaapkhghx7pslvwrarurrztge4f4a3vlfy3kt3jd7vtxz4przfkmfvq"
    ca-toronto-1 = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaefcax7pqzhgcpiaxomtzvwj67cssuxhazggbhoxjv4adcvsfkfga"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaoqj42sokaoh42l76wsyhn3k2beuntrh5maj3gmgmzeyr55zzrwwa"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaageeenzyuxgia726xur4ztaoxbxyjlxogdhreu3ngfj2gji3bayda"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaaitzn6tdyjer7jl34h2ujz74jwy5nkbukbh55ekp6oyzwrtfa4zma"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaa32voyikkkzfxyo4xbdmadc2dmvorfxxgdhpnk6dw64fa3l4jh7wa"
  }
}

variable "BootStrapFile" {
  default = "./userdata/bootstrap.sh"
}

variable "subnet_ocid" {
}

variable "private_ip_count"{
  default = "1"
}

variable "ad_number" {
  
}

variable "hap_ip_count" {
  
}

