#!/bin/bash
export PATH=$PATH:/opt/jboss/bin
ENV="$1"
DEP="$2"

function appone {
 if [ "$DEP" = "undeploy" ] 
	then echo "Undeploy APPONE"
 #jboss-cli.sh --connect controller=$(hostname -s) -c "undeploy MyAppOne-1.0.ear --server-groups=ServerGroupOne --keep-content"
 #jboss-cli.sh --connect controller=$(hostname -s) -c ":read-children-names(child-type=deployment)"
	else echo "Deploy APPONE"
  #jboss-cli.sh --connect controller=$(hostname -s) -c "deploy --name=MyAppOne-1.0.ear --server-groups=ServerGroupOne"
  #jboss-cli.sh --connect controller=$(hostname -s) -c ":read-children-names(child-type=deployment)"
 fi

}

function apptwo {
 if [ "$DEP" = "undeploy" ]
	then echo "Undeploy APPTWO"
 #jboss-cli.sh --connect controller=$(hostname -s) -c "undeploy MyAppTwo-v1.ear --server-groups=ServerGroupTwo --keep-content"
 #jboss-cli.sh --connect controller=$(hostname -s) -c ":read-children-names(child-type=deployment)"
	else echo "Deploy APPTWO"
  #jboss-cli.sh --connect controller=$(hostname -s) -c "deploy --name=MyAppTwo-v1.ear --server-groups=ServerGroupTwo"
  #jboss-cli.sh --connect controller=$(hostname -s) -c ":read-children-names(child-type=deployment)"
 fi
}

function usage {
 echo "Usage:  wildflydep.sh <appone||apptwo> <deploy|undeploy>"
 exit 1
}

if ([ -z "$ENV" ] || [ -z $DEP ])
	then usage 
fi

case $ENV in

	appone | APPONE )
		appone 
	;;
	apptwo | APPTWO )
		apptwo
	;;
	
	*)
		usage
	;;
esac
