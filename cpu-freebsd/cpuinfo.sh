#!/bin/sh
###
# ABOUT  : collectd monitoring script for cpu frequency and temperature per core statistics
# AUTHOR : Matthias Breddin <mb@lunetics.com> (c) 2013
# LICENSE: GNU GPL v3
#
# This script parses sysctl variables from coretemp

# Generates output suitable for Exec plugin of collectd.
#
# Requirements:
#       coretemp module:
#       load runtime: $ kldload coretemp
#       load at boot: add `coretemp_load="YES"` to /boot/loader.conf
#   sudo entry for binary (ie. for sys account):
#       sys   ALL = (root) NOPASSWD: /sbin/sysctl
#
#
# Typical usage:
#   /usr/local/collectd-plugins/cpu-freebsd/cpuinfo.sh
#
# Typical output:
#   PUTVAL <host>/cpu-0/temperature-cpu interval=10 N:49.0
#   PUTVAL <host>/cpu-0/cpufreq interval=10 N:2834
#   PUTVAL <host>/cpu-1/temperature-cpu interval=10 N:55.0
#   PUTVAL <host>/cpu-1/cpufreq interval=10 N:2834
#   PUTVAL <host>/cpu-2/temperature-cpu interval=10 N:52.0
#   PUTVAL <host>/cpu-2/cpufreq interval=10 N:2834
#   PUTVAL <host>/cpu-3/temperature-cpu interval=10 N:48.0
#   PUTVAL <host>/cpu-3/cpufreq interval=10 N:2834
#   ...
#
###
NUM_CPUS=`/sbin/sysctl -n hw.ncpu`;
while true
do
	for i in `seq 0 $(($NUM_CPUS -1))`
	do
	        /usr/local/bin/sudo /sbin/sysctl -n dev.cpu.$i.coretemp.tjmax dev.cpu.$i.coretemp.delta | awk -v cpunum=$i -v host=${COLLECTD_HOSTNAME:=`hostname -f`} -v interval=${COLLECTD_INTERVAL:-10} ' BEGIN { ORS="";}{
	            delta=sprintf("%.1f",$0);
	            getline;
	            value=sprintf("%.1f\n", ($0-$delta))
	            print "PUTVAL "host"/cpu-" cpunum "/" "temperature-cpu interval=" interval  " N:" value
	        }';
		echo "PUTVAL ${COLLECTD_HOSTNAME:=`hostname -f`}/cpu-${i}/cpufreq interval=${COLLECTD_INTERVAL:-10} N:`/usr/local/bin/sudo /sbin/sysctl -n dev.cpu.0.freq`";
	done

	sleep ${COLLECTD_INTERVAL:-10} || true;
done