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

# while read -r line
#  do FEEDLINELOADER
# done < $FEEDERFILE
