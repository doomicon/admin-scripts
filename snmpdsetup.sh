chkconfig snmpd on

user1=user1
pass1='xxxxxxxz'
user2=user2
pass2='xxxxxxxx'
user3=user3
pass3='xxxxxxy'

cat >/etc/snmp/snmpd.conf <<EOD
createUser $user1 MD5 $pass1 DES
rwuser $user1
EOD

service snmpd stop
rm -f /var/net-snmp/snmpd.conf
service snmpd start

snmpusm -v 3 -u $user1 -l authNoPriv -a MD5 -A $pass1 \
        localhost create $user2 $user1
snmpusm -v 3 -u $user1 -l authNoPriv -a MD5 -A $pass1 -x DES \
        localhost passwd -Cx $pass1 $pass2 $user2
snmpusm -v 3 -u $user1 -l authNoPriv -a MD5 -A $pass1 \
        localhost passwd -Ca $pass1 $pass2 $user2

snmpusm -v 3 -u $user1 -l authNoPriv -a MD5 -A $pass1 \
        localhost create $user3 $user1
snmpusm -v 3 -u $user1 -l authNoPriv -a MD5 -A $pass1 -x DES \
        localhost passwd -Cx $pass1 $pass3 $user3
snmpusm -v 3 -u $user1 -l authNoPriv -a MD5 -A $pass1 \
        localhost passwd -Ca $pass1 $pass3 $user3

cat >/etc/snmp/snmpd.conf <<EOD
rouser user1
rouser user2
EOD
