#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini


process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H":00:00")
interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)

## Get all logs
echo "Get all logs"
echo ""
mkdir -p $folder/tmp
grep "$interval" $PATH_TO_PoraclJS/logs/controller-$process_date.log > $folder/tmp/controller.log
grep "$interval" $PATH_TO_PoraclJS/logs/discord-$process_date.log > $folder/tmp/discord.log
grep "$interval" $PATH_TO_PoraclJS/logs/errors-$process_date.log > $folder/tmp/errors.log
grep "$interval" $PATH_TO_PoraclJS/logs/general-$process_date.log > $folder/tmp/general.log


## Get controller log data
echo "grep controller log data"
echo ""
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

minMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s min)"
maxMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s max)"
avgMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s add/length)"

minMsgT0="$(grep '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s min)"
maxMsgT0="$(grep '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s max)"
avgMsgT0="$(grep '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s add/length)"

rateLimit="$(grep 'Rate limit' $folder/tmp/controller.log | wc -l)"

echo "Insert controller log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO controller (Datetime,RPL,Umon,Uegg,Uraid,Uquest,Uinvasion,Cmon,Cegg,Craid,Cquest,Cinvasion,minMsgT,maxMsgT,avgMsgT,rateLimit,minMsgT0,maxMsgT0,avgMsg0T) VALUES ('$process_hour','60','$Umon','$Uegg','$Uraid','$Uquest','$Uinvasion','$Cmon','$Cegg','$Craid','$Cquest','$Cinvasion','$minMsgT','$maxMsgT','$avgMsgT','$rateLimit','minMsgT0','$maxMsgT0','$avgMsgT0');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO controller (Datetime,RPL,Umon,Uegg,Uraid,Uquest,Uinvasion,Cmon,Cegg,Craid,Cquest,Cinvasion,minMsgT,maxMsgT,avgMsgT,rateLimit,minMsgT0,maxMsgT0,avgMsgT0) VALUES ('$process_hour','60','$Umon','$Uegg','$Uraid','$Uquest','$Uinvasion','$Cmon','$Cegg','$Craid','$Cquest','$Cinvasion','$minMsgT','$maxMsgT','$avgMsgT','$rateLimit','$minMsgT0','$maxMsgT0','$avgMsgT0');"
fi

## Get error log  data
echo "grep error log data"
echo ""
warn="$(grep 'MAIN warn' $folder/tmp/errors.log | wc -l)"
warnMap="$(grep 'MAIN warn' $folder/tmp/errors.log | grep StaticMap | wc -l)"
warnRL="$(grep 'MAIN warn' $folder/tmp/errors.log | grep 'rate limit hit' | wc -l)"
error="$(grep 'MAIN error' $folder/tmp/errors.log | wc -l)"

echo "Insert error log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (Datetime,RPL,warn,warnMap,warnRL) VALUES ('$process_hour','60','$warn','$warnMap','$warnRL','$error');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (Datetime,RPL,RPL,warn,warnMap,warnRL) VALUES ('$process_hour','60','$warn','$warnMap','$warnRL','$error');"
fi
