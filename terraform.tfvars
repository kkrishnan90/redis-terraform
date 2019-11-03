# -- Tenant Information
tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaal2fcg74ss6fcyolks6mwr2sb67mzczmvjar4ob4uny7lh5b3k4vq"
user_ocid    = "ocid1.user.oc1..aaaaaaaaacfec4cr2px7jc2fi4azb6db33lxmptagsqc7coicr25dujgkmqq"
fingerprint  = "b2:e5:26:92:1d:09:94:36:4a:e5:d0:3e:eb:d5:42:a7"
# api_private_key_path = "/home/opc/.oci/oci_api_key.pem" //for linking with oci api/cli
compartment_ocid = "ocid1.compartment.oc1..aaaaaaaa453zen2zclwt2yvddonuucttsatlgz6ymq73jeicubhifkp6qk7q"
# region = "ca-toronto-1"
region = "ap-mumbai-1"


# ---- Instances
NumInstances         = "3"
ssh_public_key_path  = "/home/opc/pub_key.pem"         //for created instance
ssh_private_key_path = "/home/opc/private_key_oci.pem" //for created instances
api_private_key_path = "/home/opc/oci_api_key.pem"


instance_shape = "VM.Standard.E2.1"
subnet_ocid    = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaapxrvrqrettfjowbaom475bwqr5xm6l5npmkl7vgoldhlq2uctukq"
# subnet_ocid="ocid1.subnet.oc1.ca-toronto-1.aaaaaaaaj2t2p3zssogvfwr7hnxodimjmlnhcmelulg5gsxmvf42ywnkkncq"
hap_ip_count = "10"
ad_number    = "1"