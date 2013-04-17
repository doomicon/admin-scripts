#!/bin/bash
#Name: getmac.sh
#Desc: remotely gather macs.
#Author: Rob Owens
##Change##
#initial:ro:/04/17/13

MACS="./prodbmac.out"
#MACS="./devdb.out"
declare -a hosts=(`cat prodb.txt`)

for host in "${hosts[@]}";do

	echo "$host" >> $MACS
	ssh $host /sbin/ifconfig | grep HW | awk '{ print $1":"$5 }' >> $MACS
done
