# -- Tenant Information
user_ocid        = "ocid1.user.oc1..aaaaaaaaacfec4cr2px7jc2fi4azb6db33lxmptagsqc7coicr25dujgkmqq"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaal2fcg74ss6fcyolks6mwr2sb67mzczmvjar4ob4uny7lh5b3k4vq"
fingerprint      = "8e:0b:89:df:73:01:14:de:33:d0:df:f7:01:fb:7f:ce"
compartment_ocid = "ocid1.compartment.oc1..aaaaaaaaizyvwydcbr37ym7fkioxl6xrujljf4zdoapnadqwlihugd2olrqa"
region           = "ca-toronto-1"
ad_number        = "1"

# ---- Instances
ssh_public_key_path  = "/home/opc/pub_key.pub"         //for created instance
ssh_private_key_path = "/home/opc/private_key_oci.pem" //for created instances
api_private_key_path = "/home/opc/private_key_oci.pem" //for oci cli setup

instance_shape = "VM.Standard2.2"
subnet_ocid    = "ocid1.subnet.oc1.ca-toronto-1.aaaaaaaamf3maogeseomaj4lingdu3a5hx7icu5r6dku4pcdm6ncfbtvb4oa"



# ---- App related configurationn
hap_instance_count      = "2"
hap_ip_count            = "10"
hap_instance_image_ocid = "ocid1.image.oc1.ca-toronto-1.aaaaaaaa7gb5qhlijlfon7mfoxkapsi2zvqtgrle3idy254wp3h3ddds3opa"
