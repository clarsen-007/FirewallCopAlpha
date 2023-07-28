#!/bin/bash

## Feeder Block 1
## Feeder Block Stamparm

SETNAME="feeder_block_stamparm"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_stamparm_ips=$( curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null \
                      | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1 )
   logger -t "feeder_block_stamparm_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME
   sleep 5
   ipset list $SETNAME &>/dev/null
   ipset create $SETNAME iphash
   iptables -I INPUT 2 -m set --match-set $SETNAME src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME src -j DROP
      for i in $feeder_block_stamparm_ips ; do ipset add $SETNAME $i ; done
   logger -t "feeder_block_stamparm_ip_block" "$( ipset list $SETNAME | wc -l )"
fi
