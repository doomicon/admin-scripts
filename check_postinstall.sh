#name: check_postinstall.sh
#desc: This is a postinstall check only!
#
#
# Checks added:
#	correct puppet package
#	scom package
#	splunk packages
#	clamav packages
#	Puppet is configured for this host
#	SCOM is configured for this host
#	Satellite is configured for this host
#todo:
#  	automate postinstall
#	bootstrap scripts need to check correct os
#	...
#  Changes Added:	
#  082515:  	If splunkconf check fails, mv the splunk.conf to splunk.conf.old
#		prior to running 'fixsplunk'.	
#  083115:      Check to find anomaly where server is in Satellite, however the 
#		/etc/sysconfig/rhn/systemid file is missing.  Checks for missing file
#  083115:      Satellite autoconfigure function added, NOT IN USE! Testing.
#  101315:	Satellite autoconfigure enabled for mismatch hostname in rhn/sysconfg
#  101315:	Satellite fix required before SCOM.

Scomssl="/etc/opt/microsoft/scx/ssl"
PuppetConf="/etc/puppetlabs/puppet/puppet.conf"
SplunkConf="/opt/splunkforwarder/etc/system/local/server.conf"
SplunkInputsConf="/opt/splunkforwarder/etc/system/local/inputs.conf"
ScomSSL="/etc/opt/microsoft/scx/ssl"
rhnid="/etc/sysconfig/rhn/systemid"
EmailBody="/tmp/emailbody.postinstall"
InitLog="/var/log/PostInstall.Firttime"
OtherLog="/var/log/PostInstall.log"
version=6
release=/etc/redhat-release
Satellite=<sat-server-fqdn>

Days=45
YumLog="/var/log/yum.log"

Date=`date`

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ -f $EmailBody ]
	then 
		cat /dev/null > $EmailBody
fi


if [ -f "$InitLog" ] 
	then OutputLog="$OtherLog"
	else OutputLog="$InitLog"
fi

echo $Date > $OutputLog

function mailbody {
	echo $1 >> $EmailBody
}

function log {
	echo $1 >> $OutputLog
}

declare -a packages=('pe-puppet-enterprise-release' 'scx' 'splunkforwarder' 'splunkforwarder-serve-conf' 'clamav' 'clamav-db')

function splunkconfig {

	service splunkforwarder stop
	/opt/splunkforwarder/bin/splunk clone-prep-clear-config
	service splunkforwarder start
}

function satconfig {
	grep $version $release;verstatus=$?
	if [ $verstatus = 0 ]
	then
		rm $rhnid
		wget -O - http://$Satellite/pub/bootstrap/bootstrap6.sh | bash
	else	
		echo "Satellite NOT configured, system is NOT an RHEL6.x system" >> $EmailBody
	fi
}

function scomconfig {
	service scx-cimd stop
	rm -f $ScomSSL/*
	yum reinstall --nogpgcheck scx -y
}


for package in "${packages[@]}"
do
        rpm -q $package
        status=$?
                if [ $status = 1 ]
                        then
#                               echo "$package:  is not installed" >> $EmailBody 
				mailbody "$package:  is not installed"
				log "$package:  FAILED"
			else
				log "$package:  PASSED"
                fi
done

#Splunkforwarder
grep $(hostname -f) $SplunkConf
SplunkStatus=$?
grep serverName $SplunkConf
VarServStatus=$?
if [ $SplunkStatus = 1 ] && [ $VarServStatus = 0 ]
	then
		mv $SplunkConf "$SplunkConf".old
		mailbody "Splunkforwarer:  $SplunkConf contains incorrect hostname"
		log "SlunkforwarderServer:  FAILED (or) NOT REQUIRED $SplunkConf contains incorrect hostname"
		fixsplunk=1
	else
		log "SplunkfowarderServer:  PASSED"
		fixsplunk=0
fi

if [ $fixsplunk = 1 ]
	then splunkconfig
	mailbody "Splunk has been Auto Updated"
	log "Splunk has been Auto Updated"
fi
	

#Puppet Configuration
grep $(hostname -f) $PuppetConf
status=$?
if [ $status = 1 ]
	then 
		mailbody "Puppet:  /etc/puppetlabs/puppet/puppet.conf contains incorrect hostname"
		log "Puppet Config:  FAILED /etc/puppetlabs/puppet/puppet.conf contains incorrect hostname"
	else
		log "Puppet Config:  PASSED"
fi

# Satellite
if [ ! -f $rhnid ]
then
                mailbody "Satellite:  /etc/sysconfig/rhn/systemid Does NOT Exist! Please verify system is NOT in Satellite and configure"
                log "Satellite Config:  FAILED /etc/sysconfig/rhn/systemid Does not Exist!"
#               log "Attemping Satellite AutoConfigure"
#               satconfig

fi

grep $(hostname) $rhnid
status=$?
if [ $status = 1 ]
        then
                mailbody "Satellite:  Incorrect hostname, Not configured"
                log "Satellite Config:  FAILED Incorrect hostname, Not configured, attempting autoconfig"
                log "Attemping Satellite AutoConfigure"
                satconfig
        else
                log "Satellite Config:  PASSED"
fi

#Scom Configuration
if [ ! -f $Scomssl/scx-host-$(hostname -f).pem ]
	then
		mailbody "SCOM:  Incorrect SSL Certificate, Not configured"
		log "SCOM Config:  FAILED, Incorrect SSL Certificate, Not configured, attempting autoconfig"
		fixscom=1
	else
		log "SCOM Config:  PASSED"
		fixscom=0
fi

if [ $fixscom = 1 ]
	then scomconfig
	mailbody "SCOM has been Auto Updated"
	log "SCOM has been Auto Updated"
fi


#Email only in case of failure
if [ -s $EmailBody ]
       then mail -s "PostInstall:  $(hostname -f)" emailaddr@fqdn.dom < $EmailBody
fi

# Last Update Testing
#!/bin/bash
#days=90
#LastPatched=`find $YumLog -mtime +"$days"`
#if [ -z "$LastPatched" ]
#	then log "Patch/Updates:  PASSED"
#	else 
#	  	mailbody "Patch/Updates:   FAILED"
#		log "Patch/Updates: 	FAILED"
#fi
