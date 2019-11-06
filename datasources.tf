// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.


data "oci_identity_availability_domain" "ad" {
  tenancy_ocid = "${var.tenancy_ocid}"
}

output "ad-names" {
  value = "${data.oci_identity_availability_domain.ad}"
}
