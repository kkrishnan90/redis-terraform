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
    assign_public_ip = false #Change during production to false
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

  # For OEL Linux
  # provisioner "local-exec" {
  #   command = "touch privateips/ifcfg-ens3:${count.index}\necho DEVICE='\"ens3:${count.index}\"' >> privateips/ifcfg-ens3:${count.index}\necho BOOTPROTO=static >> privateips/ifcfg-ens3:${count.index}\necho IPADDR=${self.ip_address} >> privateips/ifcfg-ens3:${count.index}\necho NETMASK=255.255.255.0 >> privateips/ifcfg-ens3:${count.index}\necho ONBOOT=yes >> privateips/ifcfg-ens3:${count.index}"
  # }
}

resource "local_file" "ansible_inventory" {
  content = " ${data.oci_core_vnic.instance_vnic.*.private_ip_address}"
  filename = "hosts.yml"
}

# resource "null_resource" "ansible" {
#   count = "${var.hap_instance_count}"
#   provisioner "remote-exec" {
#     script = "wait_for_instance.sh"
#   }
#   #For Ubuntu 18.04 Only
#   provisioner "remote-exec" {
#     script = "startupscript.sh"
#   }

#   connection {
#     type = "ssh"
#     host = "${oci_core_instance.HAPInstance.*.private_ip[count.index]}"
#     # user        = "opc" #For OEL Linux
#     user        = "ubuntu" #For Ubuntu 18.04
#     password    = ""
#     private_key = "${file(var.ssh_private_key_path)}"
#   }


#   provisioner "local-exec" {
#     #For Oracle Linux
#     # command = "ansible-playbook -i ${oci_core_instance.HAPInstance.*.private_ip[count.index]}, ansible/haproxy-oel-linux.yml --extra-vars variable_host=${oci_core_instance.HAPInstance.*.private_ip[count.index]}"
#     #For Ubuntu 18.04
#     command = "ansible-playbook -i ${oci_core_instance.HAPInstance.*.private_ip[count.index]} ansible/haproxy-ubuntu.yml --extra-vars variable_host=${oci_core_instance.HAPInstance.*.private_ip[count.index]} -vvv"
#   }
# }


