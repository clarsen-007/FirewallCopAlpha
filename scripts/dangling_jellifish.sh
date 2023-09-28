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

FEEDERFILE=$( curl --compressed https://raw.githubusercontent.com/clarsen-007/FirewallCopAlpha/main/scripts/dangling_jellifish.conf \
                       grep -v '#' | grep 'http' 2>/dev/null )

FEEDLINELOADER () {
  echo -e "$( $FEEDERFILE | cut -d'@' -f2 )_feeder_block" "Adding IPs to be blocked." | tee -a $FILE
}


while read -r line
  do FEEDLINELOADER
done < read_file.txt
