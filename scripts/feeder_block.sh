#!/bin/bash

# Version 01.05.00.00
# Added - blocklist_de_ips
# Version 01.04.00.00
# Added - emergingthreats_compromised_ips

## Feeder Block 1
## Feeder Block Stamparm - added in 01.01.00.00

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
## Feeder Block emergingthreats_compromised_ips - added in 01.04.00.00

SETNAME2="emergingthreats_compromised_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_emergingthreats_compromised_ips=$( curl --compressed https://rules.emergingthreats.net/blockrules/compromised-ips.txt 2>/dev/null )
   logger -t "feeder_block_emergingthreats_compromised_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME2
   sleep 5
   ipset list $SETNAME2 &>/dev/null
   ipset create $SETNAME2 iphash
   iptables -I INPUT 1 -m set --match-set $SETNAME2 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME2 src -j DROP
      for i in $feeder_block_emergingthreats_compromised_ips
           do ipset add $SETNAME2 $i
      done
   logger -t "feeder_block_emergingthreats_compromised_ips_ip_block" "$( ipset list $SETNAME2 | wc -l )"
fi

## Feeder Block 3
## Feeder Block blocklist.de - added in 01.05.00.00

SETNAME3="blocklist_de_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_blocklist_de_ips=$( curl --compressed https://lists.blocklist.de/lists/all.txt 2>/dev/null | grep -v ":" )
   logger -t "feeder_block_blocklist_de_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME3
   sleep 5
   ipset list $SETNAME3 &>/dev/null
   ipset create $SETNAME3 iphash
   iptables -I INPUT 1 -m set --match-set $SETNAME3 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME3 src -j DROP
      for i in $feeder_block_blocklist_de_ips
           do ipset add $SETNAME3 $i
      done
   logger -t "feeder_block_blocklist_de_ips_ip_block" "$( ipset list $SETNAME3 | wc -l )"
fi
