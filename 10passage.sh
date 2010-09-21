#!/bin/bash
#
#name: passage_ne.sh
#desc: Run as a cronjob(/etc/cron.daily, reports password aging information.
#auth: doomicon and every UNIX Admin on the planet
#note: I can't remember where I got the template for this
#
#
HOSTNAME=`hostname`
LOGFILE=/tmp/passage.out

if [ -f $LOGFILE ]
        then rm $LOGFILE
fi


DATE=`date +%m%d%y` > $LOGFILE
echo "#$HOSTNAME:$DATE" >> $LOGFILE

echo "Please login to change your password prior to expiration." > /tmp/passage.tmp
MailBody="/tmp/passage.tmp"

declare -a users=(`cat /etc/shadow | grep -v :99999: | cut -d: -f1`)
for USER in ${users[*]}
do
CURRENT_EPOCH=`grep ^$USER: /etc/shadow | cut -d: -f3`
EMAIL=`grep ^$USER /etc/passwd | cut -d: -f5`

# Find the epoch time since the user's password was last changed
#EPOCH=`/usr/bin/perl -e 'print int(time/(60*60*24))'`
let EPOCH=`date +%s`/86400
# Compute the age of the user's password
AGE=`echo $EPOCH - $CURRENT_EPOCH | /usr/bin/bc`

# Compute and display the number of days until password expiration
MAX=`grep ^$USER: /etc/shadow | cut -d: -f5`
EXPIRE=`echo $MAX - $AGE | /usr/bin/bc`

CHANGE=`echo $CURRENT_EPOCH + 1 | /usr/bin/bc`
LSTCNG="`perl -e 'print scalar localtime('$CHANGE' * 24 *3600);'`"
if [ "$EXPIRE" -lt 14 ] && [ "$EXPIRE" -gt 0 ]
then 
        #echo "$USER: will expire in $EXPIRE days" #>> $LOGFILE
	mail -s "$HOSTNAME: Password expire in $EXPIRE days" $EMAIL < $MailBody
fi
done

if [ -f $MailBody ]
	then rm $MailBody
fi
