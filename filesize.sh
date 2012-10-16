#!/bin/bash 

MailDir="/var/spool/mail"
# array this later
User="UserName"

#Size=`ls -l $MailDir/$User | awk '{ print $5 }'`
Size=`stat -c%s $MailDir/$User`

if [[ $Size > 39000000 ]]; then
echo "File Too Big"
#cat /dev/null > $MailDir/$User
else
echo "File OK"
fi

