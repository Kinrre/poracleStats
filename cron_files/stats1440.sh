#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" 00:00:00")
#interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)

## Get user data
echo "Get daily user data"
if [ -z "$userStats" ]; then
        echo ""
        echo "Not generating daily user Stats"
else
	echo "Get log data"
	echo ""
	grep Creating $PATH_TO_PoraclJS/logs/controller-$process_date.log > $folder/tmp/controller1440.log
	grep 'Stopping alerts' $PATH_TO_PoraclJS/logs/general-$process_date.log > $folder/tmp/general1440.log
        echo "Inserting all users"
        echo ""
        mysql -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT $STATS_DB -N -e "insert ignore into users (Datetime,RPL,id,name,type) select '$process_hour', '1440', id, name, type from $PORACLE_DB.humans where admin_disable=0;"
        echo "Get user data"

        query(){
        mysql -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT $STATS_DB -NB -e "$1;"
        }
        while read -r id _ ;do
        msgSend=$(grep -e "$id" $folder/tmp/controller1440.log | grep 'Creating' | grep -v '(clean)' | wc -l)
	mon=$(grep -e "$id" $folder/tmp/controller1440.log | grep 'Creating monster alert' | wc -l)
	raid=$(grep -e "$id" $folder/tmp/controller1440.log | grep 'Creating raid alert' | wc -l)
	egg=$(grep -e "$id" $folder/tmp/controller1440.log | grep 'Creating egg alert' | wc -l)
	invasion=$(grep -e "$id" $folder/tmp/controller1440.log | grep 'Creating invasion alert' | wc -l)
	quest=$(grep -e "$id" $folder/tmp/controller1440.log | grep 'Creating quest alert' | wc -l)
	stopRL=$(grep -e "$id" $folder/tmp/general1440.log | grep 'Stopping alerts (Rate limit)' | wc -l)
	stopUR=$(grep -e "$id" $folder/tmp/general1440.log | grep 'Stopping alerts [until restart]' | wc -l)

        if [ "$msgSend" != '' ]; then
                mysql -u$SQL_user -p$SQL_password -h$DB_IP -P$DB_PORT $STATS_DB -N -e "UPDATE users set msgSend='$msgSend', mon='$mon', raid='$raid', egg='$egg', invasion='$invasion', quest='$quest', stopRL='$stopRL', stopUR='$stopUR'  WHERE id = '$id' and Datetime = '$process_hour';"
        fi
        done < <(query "select id FROM users where datetime = '$process_hour';")
fi

## Allign user names with PoracleDB
echo "Allign user names with PoracleDB"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "UPDATE $STATS_DB.users a INNER JOIN $PORACLE_DB.humans b ON a.id = b.id COLLATE utf8mb4_unicode_ci SET a.name = b.name;"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "UPDATE $STATS_DB.users a INNER JOIN $PORACLE_DB.humans b ON a.id = b.id COLLATE utf8mb4_unicode_ci SET a.name = b.name;"
fi


## Aggregate hourly to daily data
echo "Aggregate hourly to daily data"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $folder/cron_files/stats1440.sql
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $folder/cron_files/stats1440.sql
fi


## Cleanup stats tables
echo "Cleanup stats tables"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from controller where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from discord where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from error where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from general where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from middleman where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from controller where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from discord where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from error where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from general where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from middleman where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from controller where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from discord where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from error where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from general where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from middleman where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from users where RPL = 1440 and Datetime < now() - interval $userRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB -e "DELETE from users where RPL = 10080 and Datetime < now() - interval $userRPL10080 day;"
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from controller where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from discord where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from error where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from general where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from middleman where RPL = 60 and Datetime < now() - interval $statsRPL60 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from controller where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from discord where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from error where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from general where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from middleman where RPL = 1440 and Datetime < now() - interval $statsRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from controller where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from discord where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from error where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from general where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from middleman where RPL = 10080 and Datetime < now() - interval $statsRPL10080 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from users where RPL = 1440 and Datetime < now() - interval $userRPL1440 day;"
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB -e "DELETE from users where RPL = 10080 and Datetime < now() - interval $userRPL10080 day;"
fi
