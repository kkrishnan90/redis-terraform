// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_instance" "TestInstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  count               = "${var.NumInstances}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "HAP-Instance-${count.index}"
  shape               = "${var.instance_shape}"
  image               = "${var.instance_image_ocid[var.region]}"
  create_vnic_details {
    subnet_id        = "${var.subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = true #Change during production to false
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
  count               = "${var.NumInstances}"
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  instance_id         = "${oci_core_instance.TestInstance.*.id[count.index]}"
}

data "oci_core_vnic" "instance_vnic" {
  count   = "${var.NumInstances}"
  vnic_id = "${lookup(element(data.oci_core_vnic_attachments.get_vnicid_by_instance_id.*.vnic_attachments[count.index], 0), "vnic_id")}"
}

resource "oci_core_private_ip" "private_ip" {
  count          = "${var.hap_ip_count * var.NumInstances}"
  depends_on     = ["oci_core_instance.TestInstance"]
  vnic_id        = "${lookup(element(data.oci_core_vnic.instance_vnic, count.index % var.NumInstances), "vnic_id")}"
  display_name   = "someDisplayName${count.index}"
  hostname_label = "somehostnamelabel${count.index}"

  #For Ubuntu 18.04
  provisioner "local-exec" {
    command = "bash add-vnic-ips.sh ${oci_core_instance.TestInstance.*.public_ip[count.index % var.NumInstances]} ${count.index} ${self.ip_address}"
  }

  # For OEL Linux
  # provisioner "local-exec" {
  #   command = "touch privateips/ifcfg-ens3:${count.index}\necho DEVICE='\"ens3:${count.index}\"' >> privateips/ifcfg-ens3:${count.index}\necho BOOTPROTO=static >> privateips/ifcfg-ens3:${count.index}\necho IPADDR=${self.ip_address} >> privateips/ifcfg-ens3:${count.index}\necho NETMASK=255.255.255.0 >> privateips/ifcfg-ens3:${count.index}\necho ONBOOT=yes >> privateips/ifcfg-ens3:${count.index}"
  # }
}

resource "null_resource" "ansible" {
  count = "${var.NumInstances}"
  provisioner "remote-exec" {
    script = "wait_for_instance.sh"
  }
  #For Ubuntu 18.04 Only
  provisioner "remote-exec" {
    script = "startupscript.sh"
  }
  connection {
    type = "ssh"
    host = "${oci_core_instance.TestInstance.*.private_ip[count.index]}"
    # user        = "opc" #For OEL Linux
    user        = "ubuntu" #For Ubuntu 18.04
    password    = ""
    private_key = "${file("/home/opc/private_key_oci.pem")}"
  }
  
 
  provisioner "local-exec" {
    #For Oracle Linux
    # command = "sudo ansible-playbook -i ${oci_core_instance.TestInstance.*.private_ip[count.index]}, ansible/redis-playbook.yml --extra-vars variable_host=${oci_core_instance.TestInstance.*.private_ip[count.index]}"
    #For Ubuntu 18.04
    command = "sudo ansible-playbook -i ${oci_core_instance.TestInstance.*.public_ip[count.index]}, ansible/redis-playbook-ubuntu.yml --extra-vars variable_host=${oci_core_instance.TestInstance.*.public_ip[count.index]} -vvv"
  }
}


