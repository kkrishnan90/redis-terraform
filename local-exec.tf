
# locals {
#     file_content = "${join("\n",formatlist(
#                         indent(
#                             4,"%s:\n redis_version: %s\n private_ip: %s \n master: %s \n redis_port: %s \n cluster_port: %s"
#                             ),
#                         oci_core_instance.RedisInstance.*.public_ip,
#                         var.redis_version,
#                         oci_core_instance.RedisInstance.*.private_ip,
#                         var.redis_ismaster,
#                         var.redis_port,
#                         var.cluster_port
#                         ))}"
# }

resource "local_file" "ansible_inventory" {
  content = "${indent(2,"redis:\nobject_storage_url: %s${indent(3,"\nhosts:${indent(4,"\n${join("\n",formatlist(
                        indent(
                            5,"%s:\n redis_version: %s\n private_ip: %s \n master: %s \n redis_port: %s \n cluster_port: %s"
                            ),
                        "",
                        oci_core_instance.TestInstance.*.public_ip,
                        "1",
                        oci_core_instance.TestInstance.*.private_ip,
                        false,
                        "",
                        ""
                        ))}")}")}")}"
  filename = "../ansible/hosts.yml"
}

# resource "local_file" "ansible_inventory" {
#   count = "${var.NumInstances}"
#   content = "${indent(2,"redis:\nhosts:${indent(3,"\n${join("\n",formatlist(
#                         indent(
#                             4,"%s:\n redis_version: %s\n private_ip: %s \n master: %s \n redis_port: %s \n cluster_port: %s"
#                             ),
                        
#                         oci_core_instance.RedisInstance.*.public_ip,
#                         var.redis_version,
#                         oci_core_instance.RedisInstance.*.private_ip,
#                         var.redis_ismaster,
#                         var.redis_port,
#                         var.cluster_port
#                         ))}")}")}"
#   filename = "../ansible/hosts.yml"
# }


