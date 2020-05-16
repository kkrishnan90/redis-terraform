# -- Tenant Information
user_ocid        = "ocid1.user.oc1..xxxxxxx"        // user ocid from oci console
tenancy_ocid     = "ocid1.tenancy.oc1..xxxxx"     // tenancy ocid from oci console
fingerprint      = "xx:xx:xx:xx:xx:df:35:xx:fd:xx:xx:47:83:xx:xx:xx"                                     // fingerprint after adding public key to API Keys in users console oci
compartment_ocid = "ocid1.compartment.oc1..xxxxxxxx" // compartment ocid from oci console
region           = "ap-mumbai-1"                                                                         // region to use for terraform to create servers/instances
ad_number        = "1"                                                                                   // availability domain number to use for region specified above
tenancy_name     = "xxxxx"                                                                           // cloud account name ex: rcitpl123

# ---- Instances
ssh_public_key_path  = "/home/opc/public_key_oci.pem"  //public key to access each server created by Terraform viz.HAProxy,App servers, etc.
ssh_private_key_path = "/home/opc/private_key_oci.pem" //private key for all servers created by Terraform viz.HAProxy, App servers,etc.
api_private_key_path = "~/.oci/oci_api_key.pem"        //private key for oci cli by default in ~/.oci/oci_api_key.pem




# ---- HAP related configuration
haproxy_instance_name   = "wc-hap-instance-"                                                                             //HAProxy instance name to be displayed on oci console
hap_instance_count      = "1"                                                                                         // Number of HAProxy instances to create
hap_instance_shape      = "VM.Standard2.2"                                                                            // Compute shape to use for HAProxy instance
hap_ip_count            = "10"                                                                                        // Number of private IPs to add in the primary vnic of each HAProxy server
hap_instance_image_ocid = "ocid1.image.oc1.ap-mumbai-1.xxxxx"  // Image ocid to use : This image ocid is blank Ubuntu 18.04 - Oracle provided image
hap_subnet_ocid         = "ocid1.subnet.oc1.ap-mumbai-1.xxxxx" // Subnet ocid to which the HAProxy machines should be provisioned - should be private subnet

# ---- APP related configuration
app_instance_name       = "wc-app-instance-"                                                                             //App instance name to be displayed on oci console
app_instance_count      = "2"                                                                                         // Number of app servers to be created
app_instance_shape      = "VM.Standard2.2"                                                                            // Compute shape to use for app server
app_instance_image_ocid = "ocid1.image.oc1.ap-mumbai-1.xxxxx"  // Image ocid to use: you can use your app image ocid which you have already as custom image
app_subnet_ocid         = "ocid1.subnet.oc1.ap-mumbai-1.xxxxx" // Subnet ocid to which App server to be provisioned - should be private subnet

# ---- Load Balancer related configuration
load_balancer_name        = "wc-loadbalancer-"                                                                            // Name of the load balancer to be displayed on oci console
load_balancer_count       = "1"                                                                                         // Number of load balancers required
load_balancer_shape       = "400Mbps"                                                                                   // Shape of load balancer required - Ex. 100Mbps, 400 Mbps
load_balancer_subnet_ocid = "ocid1.subnet.oc1.ap-mumbai-1.xxxxx" // Subnet ocid to which load balancer to be provisioned - should be public subnet
lb_ca_certificate_path    = "/home/opc/ca-cert.pem"                                                                     //Certificate path to be used in ca_certificate for load balancer - Ex: "/home/opc/ca_certificate.pem" File extension must be .pem, .cer, or .crt
lb_private_key_path       = "/home/opc/privkey.pem"                                                                     // The SSL private key for your certificate, in PEM format.
lb_public_key_path        = "/home/opc/fullchain.pem"                                                                   //The public certificate, in PEM format, that you received from your SSL certificate provider.
