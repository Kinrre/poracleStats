#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini


process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H":00:00")
interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)
interval_middleman=$(date -d '1 hour ago' +%d"/"%b"/"%Y" "%H)

## Get all poracle logs
echo ""
echo "Get all poracle logs"
echo ""
mkdir -p $folder/tmp
grep "$interval" $PATH_TO_PoraclJS/logs/controller-$process_date.log > $folder/tmp/controller.log
grep "$interval" $PATH_TO_PoraclJS/logs/discord-$process_date.log > $folder/tmp/discord.log
grep "$interval" $PATH_TO_PoraclJS/logs/errors-$process_date.log > $folder/tmp/errors.log
grep "$interval" $PATH_TO_PoraclJS/logs/general-$process_date.log > $folder/tmp/general.log
grep "$interval" $PATH_TO_PoraclJS/logs/telegram-$process_date.log > $folder/tmp/telegram.log

## Get controller log data
echo "grep controller log data"

DUmon="$(grep 'Creating monster alert for discord:user' $folder/tmp/controller.log | wc -l)"
DUraid="$(grep 'Creating raid alert for discord:user' $folder/tmp/controller.log | wc -l)"
DUegg="$(grep 'Creating egg alert for discord:user' $folder/tmp/controller.log | wc -l)"
DUquest="$(grep 'Creating quest alert for discord:user' $folder/tmp/controller.log | wc -l)"
DUinvasion="$(grep 'Creating invasion alert for discord:user' $folder/tmp/controller.log | wc -l)"
DUweather="$(grep 'Creating weather alert for discord:user' $folder/tmp/controller.log | wc -l)"

DCmon="$(grep 'Creating monster alert for discord:channel' $folder/tmp/controller.log | wc -l)"
DCraid="$(grep 'Creating raid alert for discord:channel' $folder/tmp/controller.log | wc -l)"
DCegg="$(grep 'Creating egg alert for discord:channel' $folder/tmp/controller.log | wc -l)"
DCquest="$(grep 'Creating quest alert for discord:channel' $folder/tmp/controller.log | wc -l)"
DCinvasion="$(grep 'Creating invasion alert for discord:channel' $folder/tmp/controller.log | wc -l)"
DCweather="$(grep 'Creating weather alert for discord:channel' $folder/tmp/controller.log | wc -l)"

DWmon="$(grep 'Creating monster alert for webhook' $folder/tmp/controller.log | wc -l)"
DWraid="$(grep 'Creating raid alert for webhook' $folder/tmp/controller.log | wc -l)"
DWegg="$(grep 'Creating egg alert for webhook' $folder/tmp/controller.log | wc -l)"
DWquest="$(grep 'Creating quest alert for webhook' $folder/tmp/controller.log | wc -l)"
DWinvasion="$(grep 'Creating invasion alert for webhook' $folder/tmp/controller.log | wc -l)"
DWweather="$(grep 'Creating weather alert for webhook' $folder/tmp/controller.log | wc -l)"

TUmon="$(grep 'Creating monster alert for telegram:user' $folder/tmp/controller.log | wc -l)"
TUraid="$(grep 'Creating raid alert for telegram:user' $folder/tmp/controller.log | wc -l)"
TUegg="$(grep 'Creating egg alert for telegram:user' $folder/tmp/controller.log | wc -l)"
TUquest="$(grep 'Creating quest alert for telegram:user' $folder/tmp/controller.log | wc -l)"
TUinvasion="$(grep 'Creating invasion alert for telegram:user' $folder/tmp/controller.log | wc -l)"
TUweather="$(grep 'Creating weather alert for telegram:user' $folder/tmp/controller.log | wc -l)"

TCmon="$(grep 'Creating monster alert for telegram:channel' $folder/tmp/controller.log | wc -l)"
TCraid="$(grep 'Creating raid alert for telegram:channel' $folder/tmp/controller.log | wc -l)"
TCegg="$(grep 'Creating egg alert for telegram:channel' $folder/tmp/controller.log | wc -l)"
TCquest="$(grep 'Creating quest alert for telegram:channel' $folder/tmp/controller.log | wc -l)"
TCinvasion="$(grep 'Creating invasion alert for telegram:channel' $folder/tmp/controller.log | wc -l)"
TCweather="$(grep 'Creating weather alert for telegram:channel' $folder/tmp/controller.log | wc -l)"

TGmon="$(grep 'Creating monster alert for telegram:group' $folder/tmp/controller.log | wc -l)"
TGraid="$(grep 'Creating raid alert for telegram:group' $folder/tmp/controller.log | wc -l)"
TGegg="$(grep 'Creating egg alert for telegram:group' $folder/tmp/controller.log | wc -l)"
TGquest="$(grep 'Creating quest alert for telegram:group' $folder/tmp/controller.log | wc -l)"
TGinvasion="$(grep 'Creating invasion alert for telegram:group' $folder/tmp/controller.log | wc -l)"
TGweather="$(grep 'Creating weather alert for telegram:group' $folder/tmp/controller.log | wc -l)"

minMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s min)"
maxMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s max)"
avgMsgT="$(grep -v '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s add/length)"

minMsgT0="$(grep '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s min)"
maxMsgT0="$(grep '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s max)"
avgMsgT0="$(grep '0 humans cared' $folder/tmp/controller.log | grep 'ms)' | awk '{print substr($(NF-1),2)}' | jq -s add/length)"

rateLimit="$(grep 'Rate limit' $folder/tmp/controller.log | wc -l)"

noSend="$(grep 'already disappeared or is about to go away' $folder/tmp/controller.log | wc -l)"

echo "Insert controller log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO controller (Datetime,RPL,DUmon,DUegg,DUraid,DUquest,DUinvasion,DUweather,DCmon,DCegg,DCraid,DCquest,DCinvasion,DCweather,DWmon,DWegg,DWraid,DWquest,DWinvasion,DWweather,TUmon,TUegg,TUraid,TUquest,TUinvasion,TUweather,TCmon,TCegg,TCraid,TCquest,TCinvasion,TCweather,TGmon,TGegg,TGraid,TGquest,TGinvasion,TGweather,minMsgT,maxMsgT,avgMsgT,rateLimit,minMsgT0,maxMsgT0,avgMsg0T,noSend) VALUES ('$process_hour','60','$DUmon','$DUegg','$DUraid','$DUquest','$DUinvasion','$DUweather','$DCmon','$DCegg','$DCraid','$DCquest','$DCinvasion','$DCweather','$DWmon','$DWegg','$DWraid','$DWquest','$DWinvasion','$DWweather','$TUmon','$TUegg','$TUraid','$TUquest','$TUinvasion','$TUweather','$TCmon','$TCegg','$TCraid','$TCquest','$TCinvasion','$TCweather','$TGmon','$TGegg','$TGraid','$TGquest','$TGinvasion','$TGweather','$minMsgT','$maxMsgT','$avgMsgT','$rateLimit','minMsgT0','$maxMsgT0','$avgMsgT0','$noSend');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO controller (Datetime,RPL,DUmon,DUegg,DUraid,DUquest,DUinvasion,DUweather,DCmon,DCegg,DCraid,DCquest,DCinvasion,DCweather,DWmon,DWegg,DWraid,DWquest,DWinvasion,DWweather,TUmon,TUegg,TUraid,TUquest,TUinvasion,TUweather,TCmon,TCegg,TCraid,TCquest,TCinvasion,TCweather,TGmon,TGegg,TGraid,TGquest,TGinvasion,TGweather,minMsgT,maxMsgT,avgMsgT,rateLimit,minMsgT0,maxMsgT0,avgMsg0T,noSend) VALUES ('$process_hour','60','$DUmon','$DUegg','$DUraid','$DUquest','$DUinvasion','$DUweather','$DCmon','$DCegg','$DCraid','$DCquest','$DCinvasion','$DCweather','$DWmon','$DWegg','$DWraid','$DWquest','$DWinvasion','$DWweather','$TUmon','$TUegg','$TUraid','$TUquest','$TUinvasion','$TUweather','$TCmon','$TCegg','$TCraid','$TCquest','$TCinvasion','$TCweather','$TGmon','$TGegg','$TGraid','$TGquest','$TGinvasion','$TGweather','$minMsgT','$maxMsgT','$avgMsgT','$rateLimit','minMsgT0','$maxMsgT0','$avgMsgT0','$noSend');"
fi

## Get error log data
echo "grep error log data"
warn="$(grep 'warn' $folder/tmp/errors.log | wc -l)"
warnMap="$(grep 'warn' $folder/tmp/errors.log | grep StaticMap | wc -l)"
warnRL="$(grep 'warn' $folder/tmp/errors.log | grep 'rate limit hit' | wc -l)"
error="$(grep 'MAIN error' $folder/tmp/errors.log | wc -l)"

echo "Insert error log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO error (Datetime,RPL,warn,warnMap,warnRL,error) VALUES ('$process_hour','60','$warn','$warnMap','$warnRL','$error');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO error (Datetime,RPL,warn,warnMap,warnRL,error) VALUES ('$process_hour','60','$warn','$warnMap','$warnRL','$error');"
fi

## Get discord log data
echo "grep discord log  data"
warn2="$(grep 'MAIN warn' $folder/tmp/discord.log | wc -l)"
error2="$(grep 'MAIN error' $folder/tmp/discord.log | wc -l)"
errorBG="$(grep 'MAIN error' $folder/tmp/discord.log | grep 'Bad Gateway' | wc -l)"
errorUA="$(grep 'MAIN error' $folder/tmp/discord.log | grep 'The user aborted a request' | wc -l)"
msgClean="$(grep 'Sending discord message' $folder/tmp/discord.log | grep 'clean' | wc -l)"
msgSend="$(grep 'Sending discord message' $folder/tmp/discord.log | grep -v 'clean' | wc -l)"
UmsgSend="$(grep 'USER Sending discord message' $folder/tmp/discord.log | grep -v 'clean' | wc -l)"
CmsgSend="$(grep 'CHANNEL Sending discord message' $folder/tmp/discord.log | grep -v 'clean' | wc -l)"
WmsgSend="$(grep 'WEBHOOK Sending discord message' $folder/tmp/discord.log | grep -v 'clean' | wc -l)"

echo "Insert discord log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO discord (Datetime,RPL,warn,error,errorBG,errorUA,msgClean,msgSend,UmsgSend,CmsgSend,WmsgSend) VALUES ('$process_hour','60','$warn2','$error2','$errorBG','$errorUA','$msgClean','$msgSend','$UmsgSend','$CmsgSend','$WmsgSend');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO discord (Datetime,RPL,warn,error,errorBG,errorUA,msgClean,msgSend,UmsgSend,CmsgSend,WmsgSend) VALUES ('$process_hour','60','$warn2','$error2','$errorBG','$errorUA','$msgClean','$msgSend','$UmsgSend','$CmsgSend','$WmsgSend');"
fi

## Get telegram log data
echo "grep telegram log data"
stickerFail="$(grep 'Failed to send Telegram sticker' $folder/tmp/telegram.log | wc -l)"
msgClean="$(grep 'Sending telegram message' $folder/tmp/telegram.log | grep 'clean' | wc -l)"
msgSend="$(grep 'Sending telegram message' $folder/tmp/telegram.log | grep -v 'clean' | wc -l)"
UmsgSend="$(grep 'USER Sending telegram message' $folder/tmp/telegram.log | grep -v 'clean' | wc -l)"
CmsgSend="$(grep 'CHANNEL Sending telegram message' $folder/tmp/telegram.log | grep -v 'clean' | wc -l)"
GmsgSend="$(grep 'GROUP Sending telegram message' $folder/tmp/telegram.log | grep -v 'clean' | wc -l)"

echo "Insert discord log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO telegram (Datetime,RPL,stickerFail,msgClean,msgSend,UmsgSend,CmsgSend,GmsgSend) ('$process_hour','60','$stickerFail','$msgClean','$msgSend','$UmsgSend','$CmsgSend','$GmsgSend');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO telegram (Datetime,RPL,stickerFail,msgClean,msgSend,UmsgSend,CmsgSend,GmsgSend) VALUES ('$process_hour','60',$stickerFail','$msgClean','$msgSend','$UmsgSend','$CmsgSend','$GmsgSend');"
fi

## Get general log data
echo "grep general log  data"
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
if [ -z "$middleman_log" ]
then
  echo "No path entered, skipping"
else
  echo "Get log data"
  grep -a "$interval_middleman" $middleman_log > $folder/tmp/middleman.log
  echo "grep middleman log data"
  total="$(grep 'POST /staticmap' $folder/tmp/middleman.log | wc -l)"
  mm200="$(grep 'POST /staticmap' $folder/tmp/middleman.log | grep '200' | wc -l)"
  mm500="$(grep 'POST /staticmap' $folder/tmp/middleman.log | grep '500' | wc -l)"
  echo "Insert middleman data into DB"
  if [ -z "$SQL_password" ]
  then
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO middleman (Datetime,RPL,total,post200,post500) VALUES ('$process_hour','60','$total','$mm200','$mm500');"
  else
    mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO middleman (Datetime,RPL,total,post200,post500) VALUES ('$process_hour','60','$total','$mm200','$mm500');"
  fi
fi
