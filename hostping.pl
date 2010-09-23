#!/usr/bin/perl
#Name:  hostping.pl
#Desc:  ping host up down
#Author: Rob Owens
##Change##
#initial:ro:/09/03/09
#
#
$DevRoot="/home/rob/myrepo/perl";
$DevLib="$DevRoot/lib";
$DevBin="$DevRoot/bin";
$DevTmp="$DevRoot/tmp";
#
$ServerCsv="$DevTmp/UnixServers.csv";

#includes/use
use Net::Ping;

#$host="booger";
$p = Net::Ping->new();
#print "$host is alive\n" if $p->ping($host);
open (CSV, "< $ServerCsv");

#$p->close();
foreach $line (<CSV>) {
        
        chomp $line;
        my ( $servername, $platform, $environment, $ip_addr_a, $ip_addr_b, $ip_addr_c, $ip_addr_pub, $console, $os, $function, $location,
 $hardware ) = split (/,/, $line);

        print "$servername($ip_addr_a) is ";
        print "NOT " unless $p->ping($ip_addr_a, 2);
        print "reachable.\n";
        sleep(1);    
}
    $p->close();
