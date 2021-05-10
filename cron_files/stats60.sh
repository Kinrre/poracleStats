#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini


process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H":00:00")
interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)
interval_middleman=$(date -d '1 hour ago' +%d"/"%b"/"%Y" "%H)

## Get all poracle logs
echo "Get all poracle logs"
echo ""
mkdir -p $folder/tmp
grep "$interval" $PATH_TO_PoraclJS/logs/controller-$process_date.log > $folder/tmp/controller.log
grep "$interval" $PATH_TO_PoraclJS/logs/discord-$process_date.log > $folder/tmp/discord.log
grep "$interval" $PATH_TO_PoraclJS/logs/errors-$process_date.log > $folder/tmp/errors.log
grep "$interval" $PATH_TO_PoraclJS/logs/general-$process_date.log > $folder/tmp/general.log


## Get controller log data
echo "grep controller log data"
echo ""
Umon="$(grep :user $folder/tmp/controller.log | grep 'Creating monster alert' | wc -l)"
Uraid="$(grep :user $folder/tmp/controller.log | grep 'Creating raid alert' | grep Creating | wc -l)"
Uegg="$(grep :user $folder/tmp/controller.log | grep 'Creating egg alert' | grep Creating | wc -l)"
Uquest="$(grep :user $folder/tmp/controller.log | grep 'Creating quest alert' | wc -l)"
Uinvasion="$(grep :user $folder/tmp/controller.log | grep 'Creating invasion alert' | wc -l)"

Cmon="$(grep :channel $folder/tmp/controller.log | grep 'Creating monster alert' | wc -l)"
Craid="$(grep :channel $folder/tmp/controller.log | grep 'Creating raid alert' | grep Creating | wc -l)"
Cegg="$(grep :channel $folder/tmp/controller.log | grep 'Creating egg alert' | grep Creating | wc -l)"
Cquest="$(grep :channel $folder/tmp/controller.log | grep 'Creating quest alert' | wc -l)"
Cinvasion="$(grep :channel $folder/tmp/controller.log | grep 'Creating invasion alert' | wc -l)"

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
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (Datetime,RPL,warn,warnMap,warnRL,error) VALUES ('$process_hour','60','$warn','$warnMap','$warnRL','$error');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (Datetime,RPL,warn,warnMap,warnRL,error) VALUES ('$process_hour','60','$warn','$warnMap','$warnRL','$error');"
fi

## Get discord log  data
echo "grep discord log  data"
echo ""
warn2="$(grep 'MAIN warn' $folder/tmp/discord.log | wc -l)"
error2="$(grep 'MAIN error' $folder/tmp/discord.log | wc -l)"
errorBG="$(grep 'MAIN error' $folder/tmp/discord.log | grep 'Bad Gateway' | wc -l)"
errorUA="$(grep 'MAIN error' $folder/tmp/discord.log | grep 'The user aborted a request' | wc -l)"
msgClean="$(grep 'Sending discord message' $folder/tmp/discord.log | grep 'clean' | wc -l)"
msgSend="$(grep 'Sending discord message' $folder/tmp/discord.log | grep -v 'clean' | wc -l)"

echo "Insert discord log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO discord (Datetime,RPL,warn,error,errorBG,errorUA,msgClean,msgSend) VALUES ('$process_hour','60','$warn2','$error2','$errorBG','$errorUA','$msgClean','$msgSend');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO discord (Datetime,RPL,warn,error,errorBG,errorUA,msgClean,msgSend) VALUES ('$process_hour','60','$warn2','$error2','$errorBG','$errorUA','$msgClean','$msgSend');"
fi


## Get general log  data
echo "grep general log  data"
echo ""
whQinMin="$(grep '$STATS info: Worker STATS: WebhookQueue is currently' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s min)"
whQinMax="$(grep '$STATS info: Worker STATS: WebhookQueue is currently' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s max)"
whQinAvg="$(grep '$STATS info: Worker STATS: WebhookQueue is currently' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s add/length)"
whQoutMin="$(grep 'Queues: WebhookQueue is currently' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s min)"
whQoutMax="$(grep 'Queues: WebhookQueue is currently' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s max)"
whQoutAvg="$(grep 'Queues: WebhookQueue is currently' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s add/length)"
stopRL="$(grep 'Stopping alerts (Rate limit)' $folder/tmp/general.log | grep -v 'clean' | wc -l)"
stopUR="$(grep 'Stopping alerts [until restart]' $folder/tmp/general.log | grep -v 'clean' | wc -l)"

echo "Insert general log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO general (Datetime,RPL,whQinMin,whQinMax,whQinAvg,whQoutMin,whQoutMax,whQoutAvg,stopRL,stopUR) VALUES ('$process_hour','60','$whQinMin','$whQinMax','$whQinAvg','$whQoutMin','$whQoutMax','$whQoutAvg','$stopRL','$stopUR');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO general (Datetime,RPL,whQinMin,whQinMax,whQinAvg,whQoutMin,whQoutMax,whQoutAvg,stopRL,stopUR) VALUES ('$process_hour','60','$whQinMin','$whQinMax','$whQinAvg','$whQoutMin','$whQoutMax','$whQoutAvg','$stopRL','$stopUR');"
fi

## Check for middleman path and process
echo "Middleman data"
echo ""
if [ -z "$PATH_TO_middleman_log" ]
then
  echo "No path entered, skipping"
else
  echo "Get log data"
  grep "$interval_middleman" $PATH_TO_middleman_log/middleman-error.log > $folder/tmp/middleman.log
  echo "grep middleman log data"
  mm200="$(grep 'POST /staticmap' $folder/tmp/general.log | grep '200' | wc -l)"
  mm500="$(grep 'POST /staticmap' $folder/tmp/general.log | grep '500' | wc -l)"
  echo "Insert middleman data into DB"
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO middleman (Datetime,RPL,post200,post500) VALUES ('$process_hour','60','$mm200','$mm500');"
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO middleman (Datetime,RPL,post200,post500) VALUES ('$process_hour','60','$mm200','$mm500');"
  fi
fi
