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
grep "$interval" $PATH_TO_PoraclJS/logs/general-$process_date.log | grep -v 'debug' > $folder/tmp/general.log

## Get general log data
echo "grep general log  data"

checkLength="$(grep 'verbose: Inbound WebhookQueue' $folder/tmp/general.log | wc -l)"
if (( $checkLength > 0 ))
  then
    whQinMinRaw="$(grep 'verbose: Inbound WebhookQueue' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s min)"
    whQinMaxRaw="$(grep 'verbose: Inbound WebhookQueue' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s max)"
    whQinAvgRaw="$(grep 'verbose: Inbound WebhookQueue' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s add/length)"
    whQinMinWorker="$(grep 'verbose: Worker' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s min)"
    whQinMaxWorker="$(grep 'verbose: Worker' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s max)"
    whQinAvgWorker="$(grep 'verbose: Worker' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s add/length)"
  else
    whQinMinRaw=0
    whQinMaxRaw=0
    whQinAvgRaw=0
    whQinMinWorker=0
    whQinMaxWorker=0
    whQinAvgWorker=0
fi

checkLength="$(grep 'DiscordQueue' $folder/tmp/general.log | grep -v 'Webhook' | wc -l)"
if (( $checkLength > 0 ))
  then
    whQoutMinDiscord="$(grep 'DiscordQueue' $folder/tmp/general.log | grep -v 'Webhook' | awk '{print ($NF)}' | jq -s min)"
    whQoutMaxDiscord="$(grep 'DiscordQueue' $folder/tmp/general.log | grep -v 'Webhook' | awk '{print ($NF)}' | jq -s max)"
    whQoutAvgDiscord="$(grep 'DiscordQueue' $folder/tmp/general.log | grep -v 'Webhook' | awk '{print ($NF)}' | jq -s add/length)"
  else
    whQoutMinDiscord=0
    whQoutMaxDiscord=0
    whQoutAvgDiscord=0
fi

checkLength="$(grep 'DiscordQueue\[Webhook\]' $folder/tmp/general.log | wc -l)"
if (( $checkLength > 0 ))
  then
    whQoutMinDiscordWH="$(grep 'DiscordQueue\[Webhook\]' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s min)"
    whQoutMaxDiscordWH="$(grep 'DiscordQueue\[Webhook\]' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s max)"
    whQoutAvgDiscordWH="$(grep 'DiscordQueue\[Webhook\]' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s add/length)"
  else
    whQoutMinDiscordWH=0
    whQoutMaxDiscordWH=0
    whQoutAvgDiscordWH=0
fi

checkLength="$(grep 'TelegramQueue' $folder/tmp/general.log | wc -l)"
if (( $checkLength > 0 ))
  then
    whQoutMinTelegram="$(grep 'TelegramQueue' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s min)"
    whQoutMaxTelegram="$(grep 'TelegramQueue' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s max)"
    whQoutAvgTelegram="$(grep 'TelegramQueue' $folder/tmp/general.log | awk '{print ($NF)}' | jq -s add/length)"
  else
    whQoutMinTelegram=0
    whQoutMaxTelegram=0
    whQoutAvgTelegram=0
fi

stopRL="$(grep 'Stopping alerts (Rate limit)' $folder/tmp/general.log | grep -v 'clean' | wc -l)"
stopUR="$(grep 'Stopping alerts [until restart]' $folder/tmp/general.log | grep -v 'clean' | wc -l)"

min_hits="$(grep 'Duplicate cache stats' $folder/tmp/general.log | head -1 | awk '{ print $8 }' | grep -Po '(?<=("hits":)).*(?=,"misses")')"
max_hits="$(grep 'Duplicate cache stats' $folder/tmp/general.log | tail -1 | awk '{ print $8 }' | grep -Po '(?<=("hits":)).*(?=,"misses")')"
min_misses="$(grep 'Duplicate cache stats' $folder/tmp/general.log | head -1 | awk '{ print $8 }' | grep -Po '(?<=("misses":)).*(?=,"keys")')"
max_misses="$(grep 'Duplicate cache stats' $folder/tmp/general.log | tail -1 | awk '{ print $8 }' | grep -Po '(?<=("misses":)).*(?=,"keys")')"
if (( $max_misses < $min_misses ))
  then
    whReceived=0
    whDiscarded=0
    workerIn=0
    poracleRes=1
  else
    whReceived=$(($max_misses+$max_hits-$min_misses-$min_hits))
    whDiscarded=$(($max_hits-$min_hits))
    workerIn=$(($max_misses-$min_misses))
    poracleRes=0
fi


echo "Insert general log data into DB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "INSERT IGNORE INTO general (Datetime,RPL,whQinMinRaw,whQinMaxRaw,whQinAvgRaw,whQinMinWorker,whQinMaxWorker,whQinAvgWorker,whQoutMinDiscord,whQoutMaxDiscord,whQoutAvgDiscord,whQoutMinDiscordWH,whQoutMaxDiscordWH,whQoutAvgDiscordWH,whQoutMinTelegram,whQoutMaxTelegram,whQoutAvgTelegram,stopRL,stopUR,whReceived,whDiscarded,workerIn,poracleRes) VALUES ('$process_hour','60','$whQinMinRaw','$whQinMaxRaw','$whQinAvgRaw','$whQinMinWorker','$whQinMaxWorker','$whQinAvgWorker','$whQoutMinDiscord','$whQoutMaxDiscord','$whQoutAvgDiscord','$whQoutMinDiscordWH','$whQoutMaxDiscordWH','$whQoutAvgDiscordWH','$whQoutMinTelegram','$whQoutMaxTelegram','$whQoutAvgTelegram','$stopRL','$stopUR','$whReceived','$whDiscarded','$workerIn','$poracleRes');"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "INSERT IGNORE INTO general (Datetime,RPL,whQinMinRaw,whQinMaxRaw,whQinAvgRaw,whQinMinWorker,whQinMaxWorker,whQinAvgWorker,whQoutMinDiscord,whQoutMaxDiscord,whQoutAvgDiscord,whQoutMinDiscordWH,whQoutMaxDiscordWH,whQoutAvgDiscordWH,whQoutMinTelegram,whQoutMaxTelegram,whQoutAvgTelegram,stopRL,stopUR,whReceived,whDiscarded,workerIn,poracleRes) VALUES ('$process_hour','60','$whQinMinRaw','$whQinMaxRaw','$whQinAvgRaw','$whQinMinWorker','$whQinMaxWorker','$whQinAvgWorker','$whQoutMinDiscord','$whQoutMaxDiscord','$whQoutAvgDiscord','$whQoutMinDiscordWH','$whQoutMaxDiscordWH','$whQoutAvgDiscordWH','$whQoutMinTelegram','$whQoutMaxTelegram','$whQoutAvgTelegram','$stopRL','$stopUR','$whReceived','$whDiscarded','$workerIn','$poracleRes');"
fi
