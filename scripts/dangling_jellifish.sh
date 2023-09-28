#!/bin/bash



for Feeders in

if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_emergingthreats_compromised_ips=$( curl --compressed https://rules.emergingthreats.net/blockrules/compromised-ips.txt 2>/dev/null )
   logger -t "feeder_block_emergingthreats_compromised_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME2
   sleep 3
   ipset create $SETNAME2 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME2 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME2 src -j DROP
      for i in $feeder_block_emergingthreats_compromised_ips
           do ipset add $SETNAME2 $i
      done
   logger -t "feeder_block_emergingthreats_compromised_ips_ip_block" "$( ipset list $SETNAME2 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME2 | head -7 | tee -a $FILE
fi


