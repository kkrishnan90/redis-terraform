# -- Tenant Information
user_ocid        = "ocid1.user.oc1..aaaaaaaaacfec4cr2px7jc2fi4azb6db33lxmptagsqc7coicr25dujgkmqq"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaal2fcg74ss6fcyolks6mwr2sb67mzczmvjar4ob4uny7lh5b3k4vq"
fingerprint      = "b2:e5:26:92:1d:09:94:36:4a:e5:d0:3e:eb:d5:42:a7"
compartment_ocid = "ocid1.compartment.oc1..aaaaaaaaizyvwydcbr37ym7fkioxl6xrujljf4zdoapnadqwlihugd2olrqa"
region           = "ca-toronto-1"
ad_number        = "1"

# ---- Instances
ssh_public_key_path  = "/home/opc/pub_key.pem"         //for created instance
ssh_private_key_path = "/home/opc/private_key_oci.pem" //for created instances
api_private_key_path = "/home/opc/oci_api_key.pem"     //for oci cli setup

instance_shape = "VM.Standard2.2"
subnet_ocid    = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaapxrvrqrettfjowbaom475bwqr5xm6l5npmkl7vgoldhlq2uctukq"


# ---- App related configurationn
hap_instance_count      = "2"
hap_ip_count            = "10"
hap_instance_image_ocid = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaapkhghx7pslvwrarurrztge4f4a3vlfy3kt3jd7vtxz4przfkmfvq"
