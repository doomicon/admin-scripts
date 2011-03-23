#!/usr/bin/perl
use IO::Socket;
use Getopt::Long;

#require './subs/usage';
sub usage {

        print<<EOF;

        sscan.pl -h <host> -s <starting port> -e <ending port>"

        Examples:
        ./sscan.pl -h 10.254.111.119 -s 10 -e 1024


EOF


return(1); 
} print;


GetOptions (
	"h=s",\$host,
	"s=i",\$sport,
	"e=i",\$eport
);

if ((!$host) || (!$sport) || (!$eport)) {
	usage();
};

if($sport > $eport){  

	print "Error: min port is higher then max port\n";  

	exit 1;  
};

for($i = $sport; $i <= $eport; ++$i){ 
$scan = IO::Socket::INET->new(PeerAddr=>$host,PeerPort=>$i,proto=>'tcp',Timeout=>1) and print "Port $i is open\n";
};

