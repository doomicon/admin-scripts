#!/usr/bin/perl
#Name: diffck.pl
#Desc: This was used to verify the checksums of the copied data during
#      the orastandby migration.  Basically I formatted the output of
#      of a recursive cksum.. bla bla bla.  
#      THE IMPORTANT THING!!!  I loaded the data in two separate associtive
#      arrays then compared the two arrays.. This sounds easy in theory, 
#      but actually it's a FREAKIN PAIN!!!  So I'm saving this for the
#      "use Test::More" module example at the bottom.
#Author: Rob Owens
##Change##
#initial:ro:/12/1?/09

#$NFSF="nfsu301.out";
#$ORAD="ora02u30.out";
#$NSFF="nfsstand.out";
$ORAD="orastand.out";


open ( NFS, "< /tmp/pwystand.out" ) || die "Could not open $NFSF\n";
foreach $line (<NFS>) {
	chomp $line;
	my ($cksumd, $sized, $filenamed ) = split (/:/, $line );
	$nfshash{ $filenamed } = $cksumd;
	print "$filenamed:  $cksumd\n";
}
open ( ORA, "< $ORAD" ) || die "Could not open $ORAD\n";

foreach $line (<ORA>) {
	chomp $line;
        my ($cksums, $sizes, $filenames ) = split (/:/, $line );
        $orahash{ $filenames } = $cksums;
}
use Test::More tests => 1;
is_deeply(\%nfshash, \%orahash, 'data should be the same');

#foreach $k (keys %nfshash) {
#	print "$k\n";
#}
