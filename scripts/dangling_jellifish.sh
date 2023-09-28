#!/bin/bash

## Creating Log file and star logging

FILE=/var/log/firewallcopalpha.log
if [ -f "$FILE" ]
    then echo "Renewing bad IP list and firewall" >> $FILE
    else touch $FILE && echo "Renewing bad IP list and firewall" >> $FILE
fi

echo ""
echo " ** Starting script" | tee -a $FILE
echo "             Ver. 00.02.00.00" | tee -a $FILE
echo ""

date >> $FILE

## Start Feeders

FEEDERFILE=$( curl --compress https://raw.githubusercontent.com/clarsen-007/FirewallCopAlpha/main/scripts/dangling_jellifish.conf
while read -r line; do  
  
#Readind each line in sequence  
echo $line  
done <read_file.txt





if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_emergingthreats_compromised_ips=$Feeders
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


