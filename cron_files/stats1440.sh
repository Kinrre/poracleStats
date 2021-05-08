#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" 00:00:00")
#interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)

## Get user data
if [ -z "$userStats" ]; then
        echo ""
        echo "Not generating daily user Stats"
else
        echo "Inserting all users"
        echo ""
        mysql -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT $STATS_DB -N -e "insert ignore into users (Datetime,RPL,id,type) select '$process_hour', '1440', id, type from $PORACLE_DB.humans where admin_disable=0;"
        echo "Get user data"

        query(){
        mysql -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT $STATS_DB -NB -e "$1;"
        }
        while read -r id _ ;do
        msgSend=$(grep $id $PATH_TO_PoraclJS/logs/discord-$process_date.log | grep 'Sending discord message' | grep -v '(clean)' | wc -l)

        if [ "$msgSend" != '' ]; then
                mysql -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT $STATS_DB -N -e "UPDATE users set msgSend = '$msgSend' WHERE id = '$id' and Datetime = '$process_hour';"
        fi
        done < <(query "select id FROM users where datetime = '$process_hour';")
fi




## TO BE DONE, aggregate to daily data
