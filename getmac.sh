#!/bin/bash
# remotely get mac
MACS="./MAC.out"
declare -a hosts=(`cat hostlist.txt`)

for host in "${hosts[@]}";do

	echo "$host" >> $MACS
	ssh $host /sbin/ifconfig | grep HW | awk '{ print $1":"$5 }' >> $MACS
done
