// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_instance" "TestInstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  count = "${var.NumInstances}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "HAP-Instance${count.index}"
  shape               = "${var.instance_shape}"
  image = "${var.instance_image_ocid[var.region]}"
  create_vnic_details{
    subnet_id = "${var.subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "HAP-Instance-VNiC${count.index}"
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_path)}"
  }
  timeouts {
    create = "60m"
  }
}

data "oci_core_vnic_attachments" "instance_vnics" {
  count = "${var.NumInstances}"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  instance_id         = "${oci_core_instance.TestInstance.*.id[count.index]}"
}

locals {
  # name="${data.oci_core_vnic_attachments.instance_vnics[*].vnic_attachments[0]}"
  name = "${oci_core_instance.TestInstance[*].id}"
  vnics = "${length(local.name)}"
  init_count = "${var.NumInstances}"
}

output "locals-output" {
  value =  "${oci_core_instance.TestInstance.count.index}"
  
}

# resource "oci_core_private_ip" "private_ip" {

#   count = "${var.hap_ip_count}"
#   depends_on=["oci_core_instance.TestInstance"]
#   vnic_id        = "${for n in length(local.name) : n => local.name[*].vnic_id[n]}"
#   display_name   = "someDisplayName${count.index}"
#   hostname_label = "somehostnamelabel${count.index}"

#   # provisioner "local-exec" {
#   #     command = "touch privateips/ifcfg-ens3:${count.index}\necho DEVICE='\"ens3:${count.index}\"' >> privateips/ifcfg-ens3:${count.index}\necho BOOTPROTO=static >> privateips/ifcfg-ens3:${count.index}\necho IPADDR=${self.ip_address} >> privateips/ifcfg-ens3:${count.index}\necho NETMASK=255.255.255.0 >> privateips/ifcfg-ens3:${count.index}\necho ONBOOT=yes >> privateips/ifcfg-ens3:${count.index}"  
#   # }
# }








