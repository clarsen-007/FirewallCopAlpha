#!/bin/bash

## Creating Log file and star logging

FILE=/var/log/feeder_block.log
if [ -f "$FILE" ]
    then echo "Feeder_block will now renew bad IP list and firewall" >> $FILE
    else touch $FILE && echo "Feeder_block will now renew bad IP list and firewall" >> $FILE
fi

echo ""
echo " ** Starting Feeder Block script" | tee -a $FILE
echo "                   Ver. 01.12.00.00" | tee -a $FILE
echo ""

date >> $FILE

## Flushing firewall rules

# /usr/sbin/ufw disable
# sleep 2
# /usr/sbin/iptables -F
# sleep 2
# /usr/sbin/ufw enable
# sleep 2
# /usr/sbin/ufw status numbered | tee -a $FILE

## Feeder Block 1
## Feeder Block Stamparm - added in 01.01.00.00

SETNAME1="feeder_block_stamparm"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_stamparm_ips=$( curl --compressed https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt 2>/dev/null \
                      | grep -v "#" | grep -v -E "\s[1-2]$" | cut -f 1 )
   logger -t "feeder_block_stamparm_ip_block" "Adding IPs to be blocked."  
   ipset flush $SETNAME1
   sleep 3
   iptables -D INPUT 1 -m set --match-set $SETNAME1 src -j DROP
   iptables -D FORWARD -m set --match-set $SETNAME1 src -j DROP
   sleep 3
   ipset create $SETNAME1 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME1 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME1 src -j DROP
      for i in $feeder_block_stamparm_ips
           do ipset add $SETNAME1 $i
      done
   logger -t "feeder_block_stamparm_ip_block" "$( ipset list $SETNAME1 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME1 | head -7 | tee -a $FILE
fi

## Feeder Block 2
## Feeder Block emergingthreats_compromised_ips - added in 01.04.00.00

SETNAME2="emergingthreats_compromised_ips"
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

## Feeder Block 3
## Feeder Block blocklist.de - added in 01.05.00.00

SETNAME3="blocklist_de_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_blocklist_de_ips=$( curl --compressed https://lists.blocklist.de/lists/all.txt 2>/dev/null | grep -v ":" )
   logger -t "feeder_block_blocklist_de_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME3
   sleep 3
   ipset create $SETNAME3 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME3 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME3 src -j DROP
      for i in $feeder_block_blocklist_de_ips
           do ipset add $SETNAME3 $i
      done
   logger -t "feeder_block_blocklist_de_ips_ip_block" "$( ipset list $SETNAME3 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME3 | head -7 | tee -a $FILE
fi

## Feeder Block 4
## Feeder Block abuse.ch - added in 01.06.00.00

SETNAME4="abuse_ch_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   curl --compressed https://sslbl.abuse.ch/blacklist/sslipblacklist.txt 2>/dev/null \
                     | grep -v "#" | sed '/^$/d' | sed 's/\r$//' > /tmp/feeder_block_abuse_ch_ips.txt
   feeder_block_abuse_ch_ips=$( cat /tmp/feeder_block_abuse_ch_ips.txt )
   logger -t "feeder_block_abuse_ch_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME4
   sleep 3
   ipset create $SETNAME4 hash:ip family inet 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME4 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME4 src -j DROP
      while read p
          do ipset add $SETNAME4 $p
      done < /tmp/feeder_block_abuse_ch_ips.txt
   logger -t "feeder_block_abuse_ch_ips_ip_block" "$( ipset list $SETNAME4 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME4 | head -7 | tee -a $FILE
fi

## Feeder Block 5
## Feeder Block interserver_all - added in 01.07.00.00

SETNAME5="interserver_all_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_interserver_all_ips=$( curl --compressed https://sigs.interserver.net/iprbl.txt 2>/dev/null | grep -v "#" )
   logger -t "feeder_block_interserver_all_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME5
   sleep 3
   ipset create $SETNAME5 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME5 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME5 src -j DROP
      for i in $feeder_block_interserver_all_ips
           do ipset add $SETNAME5 $i
      done
   logger -t "feeder_block_interserver_all_ips_ip_block" "$( ipset list $SETNAME5 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME5 | head -7 | tee -a $FILE
fi

## Feeder Block 6
## Feeder Block bruteforceblocker - added in 01.08.00.00

SETNAME6="bruteforceblocker_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   curl --compressed https://danger.rulez.sk/projects/bruteforceblocker/blist.php 2>/dev/null \
                                  | cut -d'#' -f1 | sed '/^$/d' > /tmp/bruteforceblocker_ips.txt
   feeder_block_bruteforceblocker_ips=$( cat /tmp/bruteforceblocker_ips.txt )
   logger -t "feeder_block_bruteforceblocker_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME6
   sleep 3
   ipset create $SETNAME6 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME6 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME6 src -j DROP
      while read p
          do ipset add $SETNAME6 $p
      done < /tmp/bruteforceblocker_ips.txt
   logger -t "feeder_block_bruteforceblocker_ips_ip_block" "$( ipset list $SETNAME6 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME6 | head -7 | tee -a $FILE
fi

## Feeder Block 7
## Feeder Block greensnow.co - added in 01.09.00.00

SETNAME7="greensnow_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_greensnow_ips=$( curl --compressed https://blocklist.greensnow.co/greensnow.txt 2>/dev/null )
   logger -t "feeder_block_greensnow_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME7
   sleep 3
   ipset create $SETNAME7 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME7 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME7 src -j DROP
      for i in $feeder_block_greensnow_ips
           do ipset add $SETNAME7 $i
      done
   logger -t "feeder_block_greensnow_ips_ip_block" "$( ipset list $SETNAME7 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME7 | head -7 | tee -a $FILE
fi

## Feeder Block 8
## Feeder Block cybercrime-tracker.net - added in 01.12.00.00

SETNAME8="cybercrime_tracker_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_cybercrime_tracker_ips=$( curl --compressed https://iplists.firehol.org/files/cybercrime.ipset \
                                    | grep -v "#" 2>/dev/null )
   logger -t "feeder_block_cybercrime_tracker_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME8
   sleep 3
   ipset create $SETNAME8 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME8 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME8 src -j DROP
      for i in $feeder_block_cybercrime_tracker_ips
           do ipset add $SETNAME8 $i
      done
   logger -t "feeder_block_cybercrime_tracker_ips_ip_block" "$( ipset list $SETNAME8 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME8 | head -7 | tee -a $FILE
fi

sudo cscli decisions list --origin CAPI | cut -d ':' -f2 | cut -d '|' -f1 | grep -v '\---' | grep -i -v 'Value'

## Feeder Block 9
## Feeder Block crowdsec.net - added in 01.13.00.00

SETNAME8="crowdsec_tracker_ips"
if [ -x `which curl` -a -x `which ipset` ]; then
   feeder_block_crowdsec_tracker_ips=$( cscli decisions list --origin CAPI | cut -d ':' -f2 | cut -d '|' -f1 \
                                    | grep -v '\---' | grep -i -v 'Value' )
   logger -t "feeder_block_crowdsec_tracker_ips_ip_block" "Adding IPs to be blocked."
   ipset flush $SETNAME9
   sleep 3
   ipset create $SETNAME9 iphash 2>/dev/null
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME9 src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME9 src -j DROP
      for i in $feeder_block_crowdsec_tracker_ips
           do ipset add $SETNAME9 $i
      done
   logger -t "feeder_block_crowdsec_tracker_ips_ip_block" "$( ipset list $SETNAME9 | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME9 | head -7 | tee -a $FILE
fi

## Cleanup
rm /tmp/feeder_block_abuse_ch_ips.txt
rm /tmp/bruteforceblocker_ips.txt
