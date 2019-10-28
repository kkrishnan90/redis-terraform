// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

resource "oci_core_instance" "TestInstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "HAP-Instance"
  shape               = "${var.instance_shape}"
  image = "${var.instance_image_ocid[var.region]}"
  create_vnic_details{
    subnet_id = "${var.subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = "HAP-Instance-VNiC"
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_path)}"
    # user_data = "${base64encode(file("bootstrap.sh"))}"
    user_data = "${data.template_file.user_data.rendered}"
  }
  timeouts {
    create = "60m"
  }
}

data "oci_core_vnic_attachments" "instance_vnics" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  instance_id         = "${oci_core_instance.TestInstance.id}"
}


# Gets the OCID of the first (default) VNIC
# data "oci_core_vnic" "instance_vnic" {
#   vnic_id = "${lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0],"vnic_id")}"
# }

# # Create PrivateIP
# resource "oci_core_private_ip" "private_ip" {
#   count = "${var.hap_ip_count}"
#   vnic_id        = "${lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0],"vnic_id")}"
#   display_name   = "someDisplayName${count.index}"
#   hostname_label = "somehostnamelabel${count.index}"
# }

# # List Private IPs
# data "oci_core_private_ips" "private_ip_datasource" {
#   # depends_on = ["oci_core_private_ip.private_ip${count.index}"]
#   vnic_id    = "${lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0],"vnic_id")}"
# }


# output "private_ips" {
#   value = "${oci_core_private_ip.private_ip.*.ip_address}"
# }



output "primary-private-ip" {
  value = "${oci_core_instance.TestInstance.private_ip}"
}

output "templateOuput" {
  value = "${data.template_file.user_data.rendered}"
}



data "template_file" "user_data" { 
  template = "${templatefile("./userdata/bootstrap.tpl","[{ip:129.0.0.1}]")}"
}

