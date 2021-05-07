#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini


process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H":00:00")
interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)

## Get logs
mkdir -p $folder/tmp
grep "$interval" $PATH_TO_PoraclJS/logs/controller-$process_date.log > $folder/tmp/controller.log
grep "$interval" $PATH_TO_PoraclJS/logs/discord-$process_date.log > $folder/tmp/discord.log
grep "$interval" $PATH_TO_PoraclJS/logs/errors-$process_date.log > $folder/tmp/errors.log
grep "$interval" $PATH_TO_PoraclJS/logs/general-$process_date.log > $folder/tmp/general.log


## Get controller data
Umon="$(grep :user $folder/tmp/controller.log | grep monster | grep Creating | wc -l)"
Uraid="$(grep :user $folder/tmp/controller.log | grep raid | grep Creating | wc -l)"
Uegg="$(grep :user $folder/tmp/controller.log | grep egg | grep Creating | wc -l)"
Uquest="$(grep :user $folder/tmp/controller.log | grep quest | grep Creating | wc -l)"
Uinvasion="$(grep :user $folder/tmp/controller.log | grep invasion | grep Creating | wc -l)"

Cmon="$(grep :channel $folder/tmp/controller.log | grep monster | grep Creating | wc -l)"
Craid="$(grep :channel $folder/tmp/controller.log | grep raid | grep Creating | wc -l)"
Cegg="$(grep :channel $folder/tmp/controller.log | grep egg | grep Creating | wc -l)"
Cquest="$(grep :channel $folder/tmp/controller.log | grep quest | grep Creating | wc -l)"
Cinvasion="$(grep :channel $folder/tmp/controller.log | grep invasion | grep Creating | wc -l)"

minMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s min"
maxMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s max"
avgMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s add/length)"

echo "Insert into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO messages (Datetime,Umon,Uegg,Uraid,Uquest,Uinvasion,Cmon,Cegg,Craid,Cquest,Cinvasion,minMsgT,maxMsgT,avgMsgT) VALUES ('$process_hour','$Umon','$Uegg','$Uraid','$Uquest','$Uinvasion','$Cmon','$Cegg','$Craid','$Cquest','$Cinvasion','$minMsgT','$maxMsgT','$avgMsgT');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO messages (Datetime,Umon,Uegg,Uraid,Uquest,Uinvasion,Cmon,Cegg,Craid,Cquest,Cinvasion,minMsgT,maxMsgT,avgMsgT) VALUES ('$process_hour','$Umon','$Uegg','$Uraid','$Uquest','$Uinvasion','$Cmon','$Cegg','$Craid','$Cquest','$Cinvasion','$minMsgT','$maxMsgT','$avgMsgT');"
fi


echo 'Created monster user messages'
echo $Umons
echo ''
echo 'Created raid user messages'
echo $Uraid
echo ''
echo 'Created egg user messages'
echo $Uegg
echo ''
echo 'Created invasion user messages'
echo $Uinvasion
echo ''
echo 'Created quest user messages'
echo $Uquest
echo ''
echo 'Created monster channel messages'
echo $Cmons
echo ''
echo 'Created raid channel messages'
echo $Craid
echo ''
echo 'Created egg channel messages'
echo $Cegg
echo ''
echo 'Created invasion channel messages'
echo $Cinvasion
echo ''
echo 'Created quest channel messages'
echo $Cquest
echo ''

echo 'minMsgT'
echo $minMsgT
echo ''
echo 'maxMsgT'
echo $maxMsgT
echo ''
echo 'avgMsgT'
echo $avgMsgT
echo ''
