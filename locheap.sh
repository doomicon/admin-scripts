#!/bin/bash
# run local as root
IFS=$'\n'
arrheap=($(/opt/wildfly/bin/jboss-cli.sh -c --controller=$(hostname) --command="/core-service=platform-mbean/type=memory:read-attribute(name=heap-memory-usage)" | grep 'used\|max' | awk '{print $3}' | sed 's/[L||L,]//g'))
unset IFS

heapused=${arrheap[0]}
heapmax=${arrheap[1]}

freememory=$(expr $heapmax - $heapused)

#echo "used:  $heapused"
#echo "max:   $heapmax"
#echo "avial: $freememory"

if [ "$freememory" -le 128000000 ]
then
  echo "$(hostname -f):  JVM Heap memory getting low: Remaining: $freememory bytes" | mail -s "Wildfly Heap Alert" emailaddr@fqdn.dom
fi
