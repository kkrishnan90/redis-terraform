// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_instance" "HAPInstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  count               = "${var.hap_instance_count}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "HAP-Instance-${count.index}"
  shape               = "${var.instance_shape}"
  image               = "${var.hap_instance_image_ocid}"
  create_vnic_details {
    subnet_id        = "${var.subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = "HAP-Instance-VNiC${count.index}"
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_path)}"
  }
  timeouts {
    create = "60m"
  }
}

data "oci_core_vnic_attachments" "get_vnicid_by_instance_id" {
  count               = "${var.hap_instance_count}"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  instance_id         = "${oci_core_instance.HAPInstance.*.id[count.index]}"
}

data "oci_core_vnic" "instance_vnic" {
  count   = "${var.hap_instance_count}"
  vnic_id = "${lookup(element(data.oci_core_vnic_attachments.get_vnicid_by_instance_id.*.vnic_attachments[count.index], 0), "vnic_id")}"
}

resource "oci_core_private_ip" "private_ip" {
  count          = "${var.hap_ip_count * var.hap_instance_count}"
  depends_on     = ["oci_core_instance.HAPInstance"]
  vnic_id        = "${lookup(element(data.oci_core_vnic.instance_vnic, count.index % var.hap_instance_count), "vnic_id")}"
  display_name   = "someDisplayName${count.index}"
  hostname_label = "somehostnamelabel${count.index}"

  #For Ubuntu 18.04
  provisioner "local-exec" {
    command = "bash add-vnic-ips.sh ${data.oci_core_vnic.instance_vnic.*.private_ip_address[count.index % var.hap_instance_count]} ${count.index} ${self.ip_address}"
  }
}

output "HAP-IPs" {
  value = "${oci_core_instance.HAPInstance.*.private_ip}"
}


resource "null_resource" "ansible_inventory" {
  count = "${var.hap_instance_count}"
  provisioner "local-exec" {
    command = "bash create-host-ips.sh ${oci_core_instance.HAPInstance.*.private_ip[count.index]}"
  }
}

