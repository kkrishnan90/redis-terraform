#! /bin/bash
sudo apt install python3
cat >> privateips/interfaces <<EOL
auto ens3:$1
iface ens3:$1 inet static
	address $2
	netmask 255.255.255.0
EOL