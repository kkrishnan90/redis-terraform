#! /bin/bash
cat <<\EOT >$1
auto ens3:$2
iface ens3:$2 inet static
	address $3
	netmask 255.255.255.0
EOT