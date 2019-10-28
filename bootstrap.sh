#!/bin/bash
 
cp /etc/motd /home/opc/motd.bkp

var1="VALUE 1"
var2="VALUE 2"

echo "SOME_ADDRESS = ${ip}" > /home/opc/motd.bkp

cat > /home/opc/file1.md << EOF1
do some commands on "$var1" 
and/or "$var2"
and ip is "${ip}"
EOF1

cat > /home/opc/file2.md << EOF2
do some commands on "$var1" 
and/or "$var2"
EOF2
