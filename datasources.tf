// Copyright (c) 2017, 2019, Oracle and/or its affiliates. All rights reserved.

data "oci_identity_availability_domain" "ad" {
  compartment_id = "${var.tenancy_ocid}"
  name = "Ixgl:AP-MUMBAI-1-AD-1"
}

