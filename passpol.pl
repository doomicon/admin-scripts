#!/usr/bin/perl
#Name: passpol.pl
#Desc: implement password policy on existing user accounts.
#Author: Rob Owens
##Change##
#initial:ro:/mm/dd/yy
#change:ro:/11/05/09
# IMPORTANT!  The actual functionality to change user accounts is 
# DISABLED!  The program should be run first so you can verify 
# what accounts will be changed.  After you have verified that 
# the correct accounts will be changed, then you can uncomment the
# 'system' commands and run again.
#
# Sorry, I just didn't have time to add the args, hopefully I
# get back to this and correct it... ugh! :-(
#
# Explanation:
# 1. First we are opening the /etc/passwd file for reading user accounts.
# 2. Next we parse thru each line in /etc/passwd 'foreach'
#	a. We test each line for patterns we want to ignore:
#	  'next if' lines that match pattern /regex/.
# 3. If the line does NOT match the pattern, we process.
# 	a.  we define values for each field in the passwd line,
#	    then split based on /:/, and assign value.
# 4. DEPRACTATED!!!!!  check based on UID!
# 	a.  Last sanity check, if UID is between 300 and 400 then proceed
#	    with 'chage' command.
#
#change:ro:/11/10/09
# Added min 45 days to password changes
#
open (PASSWD, "< /etc/passwd");

foreach $line (<PASSWD>) {
	# Linux and Application Accounts
	next if $line =~ /root/;
	next if $line =~ /bea/;
	next if $line =~ /ora/;
# Solaris 8
#	next if $line =~ /uucp/;
#	next if $line =~ /bin/;
#	next if $line =~ /sys/;
#	next if $line =~ /adm/;
#	next if $line =~ /listen/;
#	next if $line =~ /nobod/;
#	next if $line =~ /noaccess/;
#	next if $line =~ /lp/;
#	next if $line =~ /ssh/;
	chomp $line;
	my ( $login, $pass, $uid, $gid, $gcos, $home, $shell )   = split ( /:/, $line );
@args = ("chage", "-m 45", "-M 90", "-W 7", "$login");
		if ( ( $uid > 300 ) && ( $uid < 400 ) ) {
			printf "chage $login!\n";
		# Uncomment when ready to run!
			system(@args) == 0 or die "system @args failed: $?";
		} elsif  ( ( $uid > 1999 ) && ( $uid < 4999 ) ) {
	     		printf "chage $login!\n";
		# Uncomment when ready to run!
			system(@args) == 0 or die "system @args failed: $?"; 
		} else {
			printf "NO chage $login!\n";
		}
}
