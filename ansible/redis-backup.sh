#!/bin/sh

readonly cluster_topology=$(/home/opc/redis-cli -h $1 cluster nodes) # change /home/opc/redis-cli - pass as arg
readonly slaves=$(echo "${cluster_topology}" | grep slave | cut -d' ' -f2,4 | tr ' ' ',')

# mkdir -p /opt/redis-backup

for slave in ${slaves}
do
    master_id=$(echo "${slave}" | cut -d',' -f2)
    slave_ip=$(echo "${slave}" | cut -d':' -f1)
    slots=$(echo "${cluster_topology}" | grep "${master_id}" | grep "master" | cut -d' ' -f9)

    if [ -z "$slave_ip" ] || [ -z "$slots" ]
    then
        printf "Can not find redis slave or slots in topology\n%s\n" $cluster_topology
        exit 1
    fi

    # Get last dump.rdb
    /home/opc/redis-cli --rdb dump.rdb -h ${slave_ip} # change /home/opc/redis-cli - pass as arg

    # Check rdb file for consistency
    rdb_check=$(/mnt/redis/ansible/redis-4.0.10/src/redis-check-rdb dump.rdb) #Change /mnt/redis/ansible to base dir pass as arg
    echo ${rdb_check} | grep "Checksum OK" | grep "RDB looks OK!"

    # If rdb is consistent, compress it and move to backup directory. Fail otherwise.
    if [ $? -eq 0 ]
    then
        backup_file=dump-${slots}-$(date '+%Y-%m-%d-%H%M').rdb.gz
        gzip dump.rdb
        mv dump.rdb.gz /home/opc/backups/${backup_file}  # change /home/opc/ - pass as arg
    else
        failed_dump=dump-failed-${slots}-$(date '+%Y-%m-%d-%H%M').rdb
        printf "RDB check failed!"
        mv dump.rdb /home/opc/backups/${failed_dump}   # change /home/opc/ - pass as arg
    fi
done
