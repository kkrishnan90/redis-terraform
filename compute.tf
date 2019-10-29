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
    # user_data = "${data.template_file.user_data.rendered}"
  }
  timeouts {
    create = "60m"
  }

  # provisioner "remote-exec" {    
  #   inline = [
  #     "cp /etc/motd /home/opc/motd.bkp",
  #     "echo ip=${oci_core_instance.TestInstance.private_ip} > motd.bkp",
  #   ]
  # }
  # connection {
  #   type     = "ssh"
  #   host = "${oci_core_instance.TestInstance.private_ip}"
  #   user     = "opc"
  #   password = ""
  #   private_key = "${file("/home/opc/private_key_oci.pem")}"
  # }
}

data "oci_core_vnic_attachments" "instance_vnics" {
  compartment_id      = "${var.compartment_ocid}"
  availability_domain = "${data.oci_identity_availability_domain.ad.name}"
  instance_id         = "${oci_core_instance.TestInstance.id}"
}


# Gets the OCID of the first (default) VNIC
data "oci_core_vnic" "instance_vnic" {
  vnic_id = "${lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0],"vnic_id")}"
}

# Create PrivateIP
resource "oci_core_private_ip" "private_ip" {
  count = "${var.hap_ip_count}"
  vnic_id        = "${lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0],"vnic_id")}"
  display_name   = "someDisplayName${count.index}"
  hostname_label = "somehostnamelabel${count.index}"

  provisioner "local-exec" {
      command = "touch privateips/ifcfg-ens3:${count.index}\necho DEVICE=\"ens3:${count.index}\" >> privateips/ens3:${count.index}\necho BOOTPROTO=static >> privateips/ens3:${count.index}\necho IPADDR=${self.ip_address} >> privateips/ens3:${count.index}\necho NETMASK=255.255.255.0 >> privateips/ens3:${count.index}\necho ONBOOT=yes >> privateips/ens3:${count.index}"  
  }


# provisioner "remote-exec" {    
#     inline = [
#       "echo ${self.ip_address} ${count.index} >> motd.bkp",
#       # "sudo ip addr add ${self.ip_address}/24 dev ens3 label ens3:${count.index+1}",
#       "echo ${self.ip_address} >> ips.txt"
#       # "for ip in ${oci_core_private_ip.private_ip.*.ip_address} do echo ip > motd.bkp done"
#     ]
#   }
#   connection {
#     type     = "ssh"
#     host = "${oci_core_instance.TestInstance.private_ip}"
#     user     = "opc"
#     password = ""
#     private_key = "${file("/home/opc/private_key_oci.pem")}"
#   }

}

# List Private IPs
data "oci_core_private_ips" "private_ip_datasource" {
  # depends_on = ["oci_core_private_ip.private_ip${count.index}"]
  vnic_id    = "${lookup(data.oci_core_vnic_attachments.instance_vnics.vnic_attachments[0],"vnic_id")}"

}

resource "null_resource" "ansible" {
  provisioner "local-exec"{
    command = "sudo ansible-playbook -i ${oci_core_instance.TestInstance.public_ip}, ansible/redis-playbook.yml --extra-vars variable_host=${oci_core_instance.TestInstance.public_ip}"
  }
}

output "testipifcfg" {
  value = "touch privateips/ifcfg-ens3:1\necho DEVICE=\"ens3:1\" >> privateips/ens3:1\necho BOOTPROTO=static >> privateips/ens3:1\necho IPADDR=102.34.34.34 >> privateips/ens3:1\necho NETMASK=255.255.255.0 >> privateips/ens3:1\necho ONBOOT=yes >> privateips/ens3:1"
}



# # output "private_ips" {
# #   value = "${null_resource.ip_script}"
# # }



# output "primary-private-ip" {
#   value = "${oci_core_instance.TestInstance.private_ip}"
# }

output "coreip" {
  value = "${lookup(oci_core_private_ip.private_ip[3], "ip_address")}"
}


output "secondary-private-ips" {
  value = "${oci_core_private_ip.private_ip.*.ip_address}"
}

# output "combined_data" {
#   value = { primary_ip = "${oci_core_instance.TestInstance.private_ip}",secondary_ips="${oci_core_private_ip.private_ip.*.ip_address}" }
# }



# output "templateOuput" {
#   value = "${data.template_file.user_data.rendered}"
# }



# data "template_file" "user_data" { 
#   template = "${base64encode(templatefile("./userdata/bootstrap.tpl",{primaryip=""}))}"
# }

