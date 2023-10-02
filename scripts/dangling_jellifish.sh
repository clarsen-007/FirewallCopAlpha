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
cat $TEMPFOLDER/dangling_jellifish.conf | grep -v "#" > $TEMPFOLDER/dangling_jellifish.feeder

# while read -r line
#  do FEEDLINELOADER
# done < $FEEDERFILE
