// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

############# HAP INSTANCE ###############
resource "oci_core_instance" "HAPInstance" {
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  count               = "${var.hap_instance_count}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.haproxy_instance_name}${count.index}"
  shape               = "${var.hap_instance_shape}"
  image               = "${var.hap_instance_image_ocid}"
  create_vnic_details {
    subnet_id        = "${var.hap_subnet_ocid}"
    display_name     = "primaryvnic"
    assign_public_ip = false
    hostname_label   = "HAP-Instance-VNiC${count.index}"
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_path)}"
    user_data = "${base64encode(file("./bootscript.sh"))}"
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

//Create additional primary vNic IPs for each HAProxy machine
resource "oci_core_private_ip" "private_ip" {
  count          = "${var.hap_ip_count * var.hap_instance_count}"
  depends_on     = ["oci_core_instance.HAPInstance"]
  vnic_id        = "${lookup(element(data.oci_core_vnic.instance_vnic, count.index % var.hap_instance_count), "vnic_id")}"
  display_name   = "someDisplayName${count.index}"
  hostname_label = "somehostnamelabel${count.index}"

  //Add newly created ips of each HAProxy machine create ansible
  provisioner "local-exec" {
    command = "bash add-vnic-ips.sh ${data.oci_core_vnic.instance_vnic.*.private_ip_address[count.index % var.hap_instance_count]} ${count.index} ${self.ip_address}"
  }
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
  display_name        = "${var.app_instance_name}${count.index}"
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

resource "null_resource" "write-app-instance-ips" {
  count = "${var.app_instance_count}"
  provisioner "local-exec" {
    command = "echo ${oci_core_instance.AppInstance.*.private_ip[count.index]}>>ansible/app-servers.conf"
  }
}




############# LOAD BALANCER ###############
resource "oci_load_balancer" "lb1" {
  count          = "${var.load_balancer_count}"
  shape          = "${var.load_balancer_shape}"
  compartment_id = "${var.compartment_ocid}"

  subnet_ids = [
    "${var.load_balancer_subnet_ocid}"
  ]

  display_name = "${var.load_balancer_name}${count.index}"
}

//Add certificates to load balancer
resource "oci_load_balancer_certificate" "lb-certificate" {
  load_balancer_id   = "${oci_load_balancer.lb1.*.id[count.index]}"
  ca_certificate     = "${file(var.lb_ca_certificate_path)}"
  certificate_name   = "certificate1"
  private_key        = "${file(var.lb_private_key_path)}"
  public_certificate = "${file(var.lb_public_key_path)}"

  lifecycle {
    create_before_destroy = true
  }
}


############# CREATE BACKEND SET FOR LOAD BALANCER (HTTP + WEBSOCKET BACKENDSET) ###############

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
  name             = "lb-ws-backendset"
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

locals {
  product = setproduct(oci_core_instance.HAPInstance.*.private_ip, oci_load_balancer.lb1.*.id)
}


############# ADD HAPROXY BACKEND IP TO LOAD BALANCER BACKENDSET FOR BOTH HTTP & WEBSOCKET BACKENDSET ###############
resource "oci_load_balancer_backend" "lb_backendhttp" {
  count = "${var.hap_instance_count * var.load_balancer_count}"
  #Required
  backendset_name  = "lb-http-backendset"
  ip_address       = "${local.product[count.index][0]}"
  load_balancer_id = "${local.product[count.index][1]}"
  port             = "80"
}

resource "oci_load_balancer_backend" "lb_backendws" {
  count            = "${var.hap_instance_count * var.load_balancer_count}"
  backendset_name  = "lb-ws-backendset"
  ip_address       = "${local.product[count.index][0]}"
  load_balancer_id = "${local.product[count.index][1]}"
  port             = "80"
}

resource "oci_load_balancer_listener" "tcp_listener" {
  count = "${var.load_balancer_count}"
  #Required
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-ws-backendset.*.name[count.index]}"
  load_balancer_id         = "${oci_load_balancer.lb1.*.id[count.index]}"
  name                     = "TCPSSL"
  port                     = "80"
  protocol                 = "TCP"

  #Optional
  connection_configuration {
    #Required
    idle_timeout_in_seconds = "300"
  }

  ssl_configuration {
      #Required
      certificate_name = "${oci_load_balancer_certificate.lb-certificate.name}"
  }
}

resource "oci_load_balancer_listener" "https_listener" {
  count = "${var.load_balancer_count}"
  #Required
  default_backend_set_name = "${oci_load_balancer_backend_set.lb-http-backendset.*.name[count.index]}"
  load_balancer_id         = "${oci_load_balancer.lb1.*.id[count.index]}"
  name                     = "HTTPS"
  port                     = "443"
  protocol                 = "HTTP"

  #Optional
  connection_configuration {
    #Required
    idle_timeout_in_seconds = "60"
  }

  ssl_configuration {
      #Required
      certificate_name = "${oci_load_balancer_certificate.lb-certificate.name}"
  }
}

####### BACKUP TFSTATE FILE TO OBJECT STORAGE OR START HAPROXY CONFIGURATION #######
resource "null_resource" "tfstate-backup" {
  depends_on = ["oci_load_balancer_listener.https_listener"]
  
  /*If tfstate to be put in Object Storage backup.Uncomment the below code block [provisioner "local-exec"] and 
  comment bash run-playbook1.sh provisioner code block.
  CAUTION : Do not run terraform script with both the blocks uncommented !*/


  //Creates a backup copy of terraform.tfstate file on Object Storage.
  # provisioner "local-exec" {
  #   command = "oci os object put -ns ${var.tenancy_name} -bn tfstate-backup --name tfstate-backup.tfstate --file terraform.tfstate"
  # }

  //Starts Ansible Playbooks to configure HAProxy and App Servers
  provisioner "local-exec" {
    command = "bash run-playbook1.sh"
  }
}
