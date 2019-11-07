# -- Tenant Information
user_ocid        = "ocid1.user.oc1..aaaaaaaaacfec4cr2px7jc2fi4azb6db33lxmptagsqc7coicr25dujgkmqq"
tenancy_ocid     = "ocid1.tenancy.oc1..aaaaaaaal2fcg74ss6fcyolks6mwr2sb67mzczmvjar4ob4uny7lh5b3k4vq"
fingerprint      = "fe:4b:33:a4:11:2f:a1:dc:b8:6f:5d:70:31:61:d7:5c"
compartment_ocid = "ocid1.compartment.oc1..aaaaaaaaizyvwydcbr37ym7fkioxl6xrujljf4zdoapnadqwlihugd2olrqa"
region           = "ap-mumbai-1"
ad_number        = "1"

# ---- Instances
ssh_public_key_path  = "/home/opc/public_key_oci.pem"  //for created instance
ssh_private_key_path = "/home/opc/private_key_oci.pem" //for created instances
api_private_key_path = "~/.oci/oci_api_key.pem"        //for oci cli setup

instance_shape = "VM.Standard2.2"
subnet_ocid    = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaas2shltexr77cxgcknienmoz6zbypxkgxnzz7oyyurjlatgxkdj5q"



# ---- HAP related configurationn
hap_instance_count      = "2"
hap_ip_count            = "10"
hap_instance_image_ocid = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaapkhghx7pslvwrarurrztge4f4a3vlfy3kt3jd7vtxz4przfkmfvq"

# ---- APP related configuration
app_instance_count      = "1"
app_instance_shape      = "VM.Standard2.2"
app_instance_image_ocid = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaapkhghx7pslvwrarurrztge4f4a3vlfy3kt3jd7vtxz4przfkmfvq"
app_subnet_ocid         = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaas2shltexr77cxgcknienmoz6zbypxkgxnzz7oyyurjlatgxkdj5q"

# ---- Load Balancer related configuration
load_balancer_count       = "1"
load_balancer_shape       = "100Mbps"
load_balancer_subnet_ocid = "ocid1.subnet.oc1.ap-mumbai-1.aaaaaaaas2shltexr77cxgcknienmoz6zbypxkgxnzz7oyyurjlatgxkdj5q"
# lb_ca_certificate_path = ""
# lb_private_key_path  = ""
# lb_public_key_path = ""

