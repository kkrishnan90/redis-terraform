// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

############# HAP INSTANCE ###############
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


############# APP INSTANCE ###############
resource "oci_core_instance" "AppInstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  count               = "${var.app_instance_count}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "App-Instance-${count.index}"
  shape               = "${var.app_instance_shape}"
  image               = "${var.app_instance_image_ocid}"
  create_vnic_details {
    subnet_id        = "${var.app_subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = "APP-Instance-VNiC${count.index}"
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_path)}"
  }
  timeouts {
    create = "60m"
  }
}

output "AppInstance-ips" {
  value = "${oci_core_instance.AppInstance}"
}




############# LOAD BALANCER ###############
resource "oci_load_balancer" "lb1" {
  count          = "${var.load_balancer_count}"
  shape          = "${var.load_balancer_shape}"
  compartment_id = "${var.compartment_ocid}"

  subnet_ids = [
    "${var.load_balancer_subnet_ocid}"
  ]

  display_name = "lb${count.index}"
}

# resource "oci_load_balancer_certificate" "lb-cert1" {
#   load_balancer_id   = "${oci_load_balancer.lb1.*.id[count.index]}"
#   ca_certificate     = "${file(var.lb_ca_certificate_path)}"
#   certificate_name   = "certificate1"
#   private_key        = "${file(var.lb_private_key_path)}"
#   public_certificate = "${file(var.lb_public_key_path)}"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "oci_load_balancer_backend_set" "lb-http-backendset" {
  count            = "${var.load_balancer_count}"
  name             = "lb-http-backendset"
  load_balancer_id = "${oci_load_balancer.lb1.*.id[count.index]}"
  policy           = "ROUND_ROBIN"

  health_checker {
    retries             = "3"
    timeout_in_millis   = "3000"
    interval_ms         = "10000"
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_backend_set" "lb-ws-backendset" {
  count            = "${var.load_balancer_count}"
  name             = "lb-ws-beackendset"
  load_balancer_id = "${oci_load_balancer.lb1.*.id[count.index]}"
  policy           = "ROUND_ROBIN"

  health_checker {
    retries             = "3"
    timeout_in_millis   = "3000"
    interval_ms         = "10000"
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/"
  }
}

resource "oci_load_balancer_backend" "lb_backend1" {
  count = "${var.app_instance_count * var.load_balancer_count}"
  #Required
  backendset_name  = "${oci_load_balancer_backend_set.lb-http-backendset.*.name[count.index % var.load_balancer_count]}"
  ip_address       = "${lookup(element(oci_core_instance.AppInstance, count.index),"private_ip")}"
  load_balancer_id = "${lookup(element(oci_load_balancer.lb1, count.index % var.load_balancer_count),"id")}"
  port             = "80"
}

resource "oci_load_balancer_backend" "lb_backend2" {
  count = "${var.app_instance_count * var.load_balancer_count}"
  #Required
  backendset_name  = "${oci_load_balancer_backend_set.lb-http-backendset.*.name[1]}"
  ip_address       = "${lookup(element(oci_core_instance.AppInstance, count.index),"private_ip")}"
  load_balancer_id = "${oci_load_balancer.lb1.*.id[count.index % var.load_balancer_count]}"
  port             = "80"
}

output "LB-1" {
  value = "${oci_load_balancer.lb1.*.id}"
}

output "LB-BackendSet-1" {
  value = "${oci_load_balancer_backend.lb_backend1.*.name}"
}

output "LB-BackendSet-2" {
  value = "${oci_load_balancer_backend.lb_backend2.*.name}"
}




