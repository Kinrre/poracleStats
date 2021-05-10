#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" 00:00:00")
#interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)

# Aggregate daily to weekly data
echo "Aggregate daily to weekly data"
echo ""
if [ -z "$SQL_password" ]
then
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user $STATS_DB < $folder/cron_files/stats10080.sql
else
  mysql -h$DB_IP -P$DB_PORT -u$SQL_user -p$SQL_password $STATS_DB < $folder/cron_files/stats10080.sql
fi
