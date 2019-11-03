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

data "oci_core_instance" "test_instance" {
  count = "${var.NumInstances}"
  instance_id = "${oci_core_instance.TestInstance.*.id[count.index]}"
}

data "oci_core_private_ips" "test_private_ips_by_subnet" {
    count = "${var.NumInstances}"
    ip_address = "${oci_core_instance.TestInstance.*.private_ip[count.index]}"
    subnet_id = "${oci_core_instance.TestInstance.*.subnet_id[count.index]}"
}

output "instance-output" {
  value = "${data.oci_core_private_ips.test_private_ips_by_subnet}"
}


# resource "oci_core_private_ip" "private_ip" {
#   count = "${var.hap_ip_count}"
#   depends_on=["oci_core_instance.TestInstance"]
#   vnic_id        = "${element(local.name[*].vnic_id,count.index)}"
#   display_name   = "someDisplayName${count.index}"
#   hostname_label = "somehostnamelabel${count.index}"

#   # provisioner "local-exec" {
#   #     command = "touch privateips/ifcfg-ens3:${count.index}\necho DEVICE='\"ens3:${count.index}\"' >> privateips/ifcfg-ens3:${count.index}\necho BOOTPROTO=static >> privateips/ifcfg-ens3:${count.index}\necho IPADDR=${self.ip_address} >> privateips/ifcfg-ens3:${count.index}\necho NETMASK=255.255.255.0 >> privateips/ifcfg-ens3:${count.index}\necho ONBOOT=yes >> privateips/ifcfg-ens3:${count.index}"  
#   # }
# }








