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
    # user_data = "${base64encode(file("bootstrap.sh"))}"
    # user_data = "${data.template_file.user_data.rendered}"
  }
  timeouts {
    create = "60m"
  }
}

locals {
  name="${oci_core_instance.TestInstance.[*].private_ip}"
}

output "locals-output" {
  value = "${local.name}"
}






