#!/bin/bash

## Creating Log file and star logging

FILE=/var/log/firewallcopalpha.log
TEMPFOLDER=/tmp

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

wget -P $TEMPFOLDER https://raw.githubusercontent.com/clarsen-007/FirewallCopAlpha/main/scripts/dangling_jellifish.conf
sleep 1
cat $TEMPFOLDER/dangling_jellifish.conf | grep -v "#" | sed '/^$/d' > $TEMPFOLDER/dangling_jellifish.feeder
sleep 1
rm $TEMPFOLDER/dangling_jellifish.conf

FEEDER () {
SETNAME=$( cat $TEMPFOLDER/dangling_jellifish.feeder | cut -d '!' -f2 )
SETNAMEIP=$( cat $TEMPFOLDER/dangling_jellifish.feeder | cut -d '!' -f1 )

if [ -x `which curl` -a -x `which ipset` ]; then
   logger -t "$( echo $SETNAME )" "Adding IPs to be blocked."  
   ipset flush $SETNAME
   sleep 3
   iptables -D INPUT 1 -m set --match-set $SETNAME src -j DROP
   iptables -D FORWARD -m set --match-set $SETNAME src -j DROP
   sleep 3
   ipset create $SETNAME
   sleep 2
   iptables -I INPUT 1 -m set --match-set $SETNAME src -j DROP
   iptables -A FORWARD -m set --match-set $SETNAME src -j DROP
   ipset add $SETNAME $SETNAMEIP
   logger -t "$( echo $SETNAME )" "$( ipset list $SETNAME | wc -l )"
   echo -n "[$(date +"%d/%m/%Y %H:%M:%S")] " | tee -a $FILE
   ipset list $SETNAME | head -7 | tee -a $FILE
fi
}

while read -r line
     do FEEDER
done < $TEMPFOLDER/dangling_jellifish.feeder
