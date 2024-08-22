#!/bin/bash
# Version 1.0 | 09/19/2024 | F5 Global Training Services
#
# This script automates common Setup Utility tasks for 2 BIG-IP systems to be prepared as SSLO1 and SSLO2.
# The script uses the third octet of the management IP address to populate the following configuration objects:
# Self-IP addresses: 10.10.X.31, 10.10.X.33, 172.16.X.31, 172.16.X.33
# root and admin user account passwords: setting both to f5trn00X or f5trn0XX (dependant upon station number)
# root and admin passwords will not be in compliance with 8 charater requirement set in BIG-IP v17.1 - SSLO v11.0
# New host name: ssloX.f5trn.com
# UCS file: ssloX_prepared.ucs
# Enable option to create instructor admin role on line 105 if needed. (Helpful in classes where hardware is used.)
# 
#  Requirements to run:
#
# 1. BIG-IP system must be licensed and operational, as indicated by "Active"
#    in the CLI prompt.
#
# 2. Management interface must already be configured for normal classroom use
#    (management IP address must be in the format 192.168.X.31, where "X" is
#    the student's workstation number).
# 
# TO RUN THIS SCRIPT:
# 1. Upload the script to the student's BIG-IP system and place in /shared/tmp/
# 2. Check the script for errant line feed characters by running the following command:
#       cat sslo_bigip_setup_1.0.sh | od -c
#
# 3. If you see " \ r \ n " characters in the output, run these commands to remove them:
#       tr -d "\r" < sslo_bigip_setup_1.0.sh > sslo_bigip_setup_1.0a.sh
#       mv sslo_bigip_setup_1.0a.sh sslo_bigip_setup_1.0.sh   (reply "yes" when prompted)

# 4. Make script executable: chmod 755 /shared/tmp/sslo_bigip_setup_1.0.sh
# 5. From the /shared/tmp/ directory, execute the script:
#       ./sslo_bigip_setup_1.0.sh
#    
#
# Is this a BIG-IP system?
if [ ! -d /config ]; then
  echo This is not a BIGIP system!
  exit 1
fi
 
# Get student workstation number from the MGMT IP address
n=`ifconfig mgmt | awk -F"." '/inet/ { print $3 }'`
echo "Student workstation number >>> $n <<< detected"
 
# Workstation number must be in the range 1-16
if [ ${n} -lt 1 -o ${n} -gt 16 ]; then
  echo "Invalid Student number >>> $n <<< detected"
  exit 1
fi

# do not modify the instructor LTM (station 17)
if [ ${n} -eq 17 ]; then
  echo Cannot use this script on the instructor LTM
  exit 1
fi
#[ ${n} -eq 17 ] && exit 1
 
#original hostname check
#grep -qe 'hostname bigip1$' /config/bigip_base.conf
#if [ $? -ne 0 ]; then
#echo This bigip has a config! 
#exit 1
#fi

# Does the BIGIP have an existing network configuration?
 grep -q 'vlan /Common/.*' /config/bigip_base.conf
if [ $? -eq 0 ]; then
  echo This bigip has an existing configuration.  Please load sys config default, save config, and try again.
  exit 1
fi

# Is the system properly licensed and active?
if grep -v Active /var/prompt/ps1 > /dev/null; then
  echo This bigip is not active. Is it licensed?
  exit 1
fi

echo Building Config
 
# silently set execution echo on
{ set -x; } 2>/dev/null
tmsh modify sys global-settings gui-setup disabled
tmsh modify sys global-settings mgmt-dhcp disabled
tmsh modify sys global-settings hostname "sslo${n}.f5trn.com"
tmsh modify sys ntp servers replace-all-with { 172.16.20.1 }
tmsh modify sys dns name-servers replace-all-with { 172.16.20.1 }
tmsh mv cm device "sslo${n}" "sslo${n}.f5trn.com"
station=${n}
if [ $n -lt 10 ]; then
  station=0${n}
fi
echo setting root password to f5trn0${station}
tmsh modify auth password root <<EOD
f5trn0${station}
f5trn0${station}
EOD
echo setting admin password to f5trn0${station}
tmsh modify auth user admin shell tmsh
tmsh modify auth password admin <<EOD
f5trn0${station}
f5trn0${station}
EOD
#option to create instructor admin role
#tmsh create auth user Instructor password f5trnins partition-access add {all-partitions { role admin } } shell bash
# [not correct] tmsh create net route external_default_gateway network default gw 10.10.17.33
tmsh create net vlan internal interfaces add { 1.2 { untagged } }
tmsh create net vlan external interfaces add { 1.1 { untagged } }
tmsh create net vlan icap_VLAN interfaces add { 1.3 { untagged } }
tmsh create net self "172.16.${n}.31" address "172.16.${n}.31/16" traffic-group traffic-group-local-only vlan internal allow-service default
tmsh create net self "172.16.${n}.33" address "172.16.${n}.33/16" traffic-group traffic-group-1 vlan internal allow-service default
tmsh create net self "10.10.${n}.31" address "10.10.${n}.31/16" traffic-group traffic-group-local-only vlan external
tmsh create net self "10.10.${n}.33" address "10.10.${n}.33/16" traffic-group traffic-group-1 vlan external
tmsh create net self "10.1.30.3${n}" address "10.1.30.3${n}/24" traffic-group traffic-group-local-only vlan icap_VLAN
tmsh create net self "10.1.30.33" address "10.1.30.33/24" traffic-group traffic-group-1 vlan icap_VLAN
tmsh modify cm device "bigip${n}.f5trn.com" configsync-ip "172.16.${n}.31" unicast-address {{ effective-ip "192.168.${n}.31" ip "192.168.${n}.31" } { effective-ip "172.16.${n}.31" ip "172.16.${n}.31" }} mirror-ip "172.16.${n}.31"
tmsh create /ltm pool existing_app_pool load-balancing-mode round-robin members add { 172.16.20.1:443 172.16.20.2:443 172.16.20.3:443 } monitor gateway_icmp
tmsh create /ltm virtual existing_app_pool destination 10.10.1.100:443 pool existing_app_pool profiles add { tcp } source-address-translation { type automap } translate-address enabled translate-port enabled
tmsh modify /sys provision sslo urldb level minimum
sleep 20
for i in {1..30}; do [ "$(cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
tmsh modify /sys provision ltm level none
sleep 20
for i in {1..30}; do [ "$(cat /var/prompt/ps1)" = "Active" ] && break; sleep 5; done
tmsh save sys config
{ set +x; } 2>/dev/null
echo This bigip configuration is complete.
echo Creating backup
{ set -x; } 2>/dev/null
tmsh save sys ucs "sslo${n}_prepared.ucs"
{ set +x; } 2>/dev/null
echo Backup complete.

echo System is prepared.


