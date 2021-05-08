#!/bin/bash

folder="$(cd ../ && pwd)"
source $folder/config.ini

process_date=$(date -d '1 hour ago' +%Y"-"%m"-"%d)
process_hour=$(date -d '1 hour ago' +%Y"-"%m"-"%d" 00:00:00")
#interval=$(date -d '1 hour ago' +%Y"-"%m"-"%d" "%H)

## Get user data


## TO BE DONE, aggregate to daily data
