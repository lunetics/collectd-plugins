#!/bin/sh
###
# ABOUT  : collectd monitoring script for ipmi statistics
# AUTHOR : Matthias Breddin <mb@lunetics.com> (c) 2013
# LICENSE: GNU GPL v3
#
# This script parses the "ipmitool sensor" output for available data
# Generates output suitable for Exec plugin of collectd.
#
# Requirements:
#   ipmitool binary:
#       Freebsd: /usr/local/bin/ipmitool
#       Linux: /usr/bin
#   sudo entry for binary (ie. for sys account):
#       sys   ALL = (root) NOPASSWD: /usr/local/sbin/ipmitool
#
#
# Typical usage:
#   /usr/local/collect-plugins/ipmitool/ipmitool.sh
#
# Typical output:
#   PUTVAL <host>/ipmitool/temperature/System_Temp interval=300N:60.0000:U
#   PUTVAL <host>/ipmitool/voltage/CPU1_Vcore interval=300N:0.9280:U
#   PUTVAL <host>/ipmitool/voltage/CPU2_Vcore interval=300N:0.9360:U
#   PUTVAL <host>/ipmitool/voltage/+5V interval=300N:5.1520:U
#   PUTVAL <host>/ipmitool/voltage/+5VSB interval=300N:5.1200:U
#   PUTVAL <host>/ipmitool/voltage/+12V interval=300N:12.1370:U
#   PUTVAL <host>/ipmitool/voltage/_12V interval=300N:-11.8040:U
# ...
#
###
PATH=/bin:/usr/bin/:/usr/local/bin/
while true
do
        `which sudo` `which ipmitool` sensor | awk -v host=${COLLECTD_HOSTNAME:=`hostname -f`} -v interval=${COLLECTD_INTERVAL:-10} -F'|' 'tolower($3) ~ /(volt|rpm|watt|degree)/ && $2 !~ /na/ {
        	if (tolower($3) ~ /volt/) type="voltage";
        	if (tolower($3) ~ /rpm/)  type="fanspeed";
        	if (tolower($3) ~ /watt/) type="power";
        	if (tolower($3) ~ /degree/) type="temperature";
        	gsub(/[ \t]*$/,"",$1) gsub(/[ \t.]+/,"_",$1) gsub(/^-/,"minus-", $1) gsub(/[+]/,"plus-", $1);
        	print "PUTVAL "host"/ipmitool-" type "/" type "-" $1 " interval=" interval  " N:" sprintf("%.4f",$2)
        }'

        sleep ${COLLECTD_INTERVAL:-10} || true;
done

