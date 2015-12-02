#!/bin/bash
# Cronjob monitor wildfly heap
arrconn=($(/opt/wildfly/bin/jboss-cli.sh -c --controller=$(hostname) --command="/subsystem=datasources/data-source=OracleDS/statistics=pool:read-resource(recursive=true, include-runtime=true)" | grep 'ActiveCount\|AvailableCount'| awk '{print $3}' | sed 's/[,||"]//g'))
#
connused=${arrconn[0]}
connall=${arrconn[1]}

freeconn=$(expr $connall - $connused)


#echo -e "USED:  $connused\nTOTAL:  $connall\nFREE:  $freeconn\n"


if [ "$freeconn" -le 2 ]
then
  echo "$(hostname -f):  JVM JDBC Pool getting low: Remaining: $freeconn Connections" | mail -s "Wildfly Heap Alert" serve-linuxadmins@aexp.com
fi
