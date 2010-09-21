#!/usr/bin/perl
#Name: disservices.pl
# 040909/rowens
# Disable unnecessary services
# chages:
# 111309/owensro:added xinetd, gpm
# 111909/owensro:added vsftpd
# atd, bluetooth, cups, firstboot, ip6tables, kudzu, xfs, pcscd
# 022710/owensro:added portmap-nfslock
# 050410/owensro:added yum-updatesd

@services = ("ip6tables", "atd", "gpm", "bluetooth", "cups", "firstboot", "kudzu", "xfs", "pcscd", "avahi-daemon", "avahi-dnsconfd", "haldaemon", "hidd", "xinetd", "vsftpd", "portmap", "rpcgssd", "rpcidmapd", "netfs", "nfslock", "yum-updatesd");

foreach $service(@services) {
        system("/sbin/chkconfig --level 2345 $service off");
        system("/etc/init.d/$service stop");
}
