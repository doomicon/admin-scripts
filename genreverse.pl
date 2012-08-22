#!/usr/bin/perl
#Name:  genreverse.pl
#Desc:  automagicall generate a reverse zone record.
#Author:  Rob Owens
##Change##
#initial:ro:/04/04/12
#
# $count       IN      PTR     host$count.linux.dev.
#includes/use

open (ZONE, ">/tmp/revzone.out");

$count=1;
until ($count == 255) {
	print "$count	IN 	PTR	host$count.linux.dev.\n";
	$count++;
}

close ZONE;
