#!/usr/bin/perl
#Name:  resolv.pl
#Desc:  resolv hostnames to IP
#Author: Rob Owens
##Change##
#initial:ro:/09/02/09
#
#
$DevRoot="/home/rob/myrepo/perl";
$DevLib="$DevRoot/lib";
$DevBin="$DevRoot/bin";
$DevTmp="$DevRoot/tmp";
#
#includes/use
use Socket;
#
open (HOSTLIST, "<$DevTmp/hostlist.txt");

while(<HOSTLIST>) {
	chomp $_;
	$Host=$_;
	$packed_ip = gethostbyname("$Host");
    		if (defined $packed_ip) {
        		$ip_address = inet_ntoa($packed_ip);
		}
	print "$ip_address	$Host\n";
# if a lookup fails ip_addr will maintain last value, clearit
	$ip_address="FAILED_LOOKUP";
}
	

close (HOSTLIST);
