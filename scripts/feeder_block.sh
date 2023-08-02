#!/bin/bash

# Version 01.02.01.00

## Feeder Block 1
## Feeder Block Stamparm

SETNAME1="feeder_block_stamparm"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_stamparm_ips=$( curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null \
                      | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1 )
   logger -t "feeder_block_stamparm_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME1
   sleep 5
   ipset list $SETNAME1 &>/dev/null
   ipset create $SETNAME1 iphash
   iptables -I INPUT 1 -m set --match-set $SETNAME1 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME1 src -j DROP
      for i in $feeder_block_stamparm_ips
           do ipset add $SETNAME1 $i
      done
   logger -t "feeder_block_stamparm_ip_block" "$( ipset list $SETNAME1 | wc -l )"
fi

## Feeder Block 2
## Feeder Block The Spamhaus Project - Drop

SETNAME2="feeder_block_spamhausdrop"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_spamhausdrop_ips=$( curl --compressed https://www.spamhaus.org/drop/drop.txt 2>/dev/null | cut -d';' -f1 | sed '/^$/d' )
   logger -t "feeder_block_spamhausdrop_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME2
   sleep 5
   ipset list $SETNAME2 &>/dev/null
   ipset create $SETNAME2 iphash
   iptables -I INPUT 2 -m set --match-set $SETNAME2 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME2 src -j DROP
      for i in $feeder_block_spamhausdrop_ips
           do ipset add $SETNAME2 $i
      done
   logger -t "feeder_block_spamhausdrop_ip_block" "$( ipset list $SETNAME2 | wc -l )"
fi

EOF
