#!/bin/bash
#
#
Pywl="$1"

if [ -f /opt/bea/9.2.1/weblogic92/server/bin/setWLSEnv.sh ] 
	then source /opt/bea/9.2.1/weblogic92/server/bin/setWLSEnv.sh

elif [ -f /opt/Oracle/Middleware/wlserver_10.3/server/bin/setWLSEnv.sh ]
	then source /opt/Oracle/Middleware/wlserver_10.3/server/bin

else  
	echo "setWLSEnv.sh does not exist, please check location"
	exit 1
fi
	
java weblogic.WLST $Pywl
