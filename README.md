# poracleStats

Since nobody with an actual brain picked this up, this idiot gave it a go. <BR>
<BR>
Hourly process PoracleJS logs and store into database.<BR>

## Requirements
- PoracleJS logger settings in ``local.json`` for both ``consoleLogLevel`` and ``logLevel`` to be set to ``verbose``.<BR>
- Make sure ``jq`` is installed (sudo apt-get install jq).<BR>

## Setting up

- Clone poracleStats and copy config file: <br>``git clone https://github.com/dkmur/poracleStats.git && cd poracleStats/ && cp default_files/config.ini.example config.ini``
- Create stats database and grant privileges to user (make sure not to use ``$`` in password and, no, not going to escape it). i.e.:  
```
create database ##poracleSTATS_DB##;
grant all privileges on ##poracleSTATS_DB##.* to ##MYSELF##@localhost;
flush privileges;
```  
- Edit settings in ``config.ini``
- Execute ``./settings.run``, this will create required tables and crontab file
- Edit crontab ``crontab -e`` and insert content of ``crontab.txt`` located in poracleStats home.
<BR>

## Updates
- git pull
- check for any changes in default_files/config.ini.example and adapt accordingly
- execute ``./settings.run`` 
- update grafana templates when changed

## Grafana
- Install Grafana, more details can be found at https://grafana.com/docs/grafana/latest/installation/debian/#install-from-apt-repository or if you prefer to use docker <https://hub.docker.com/r/grafana/grafana>
- Create datasource on STATS_DB
- Add datasource name to config.ini
- After executing settings.run, import the dashboards from /poracleStats/grafana by selecting ``+`` and then import.

##  Meaning of columns
### Table controller:
DUmon  = #Discord User messages created for monster<BR>
DUegg  = #Discord User messages created for eggs<BR>
DUraid  = #Discord User messages created for raids<BR>
DUquest  = #Discord User messages created for quests<BR>
DUinvasion  = #Discord User messages created for invasions<BR>
DUweather =  = #Discord User messages created for weather change<BR>
<BR>
next columns as above: DC=Discord Channel, DW=DiscordWebhook, TU=Telegram User, TC=Telegram Channel, TG=Telegram Group<BR>
<BR>
minMsgT = for messages where at least 1 human cared, the lowest time to process it (ms)<BR>
maxMsgT = for messages where at least 1 human cared, the highest time to process it (ms)<BR>
avgsgT = for messages where at least 1 human cared, the average time to process them all (ms)<BR>
<BR>
rateLimit = #messages not created due to user being rate limited<BR>
<BR>
xxxMsgT0 = like xxxMsgT but 0 humans cared<BR>
<BR>
noSend = #messages not processed due to insufficient time left
<BR>
### Table discord
warn = #warnings<BR>
error = #errors<BR>
errorBG = #errors on Bad Gateway<BR>
errorUA = #errors on User Aborted requests<BR>
errorCantSend = #failed to send discord alert due to Cannot send messages to this user<BR>
errorNoPerm = #failed to send dicord alert due to Missing Permissions<BR>
errorNoAccess = #failed to send discord alert due to Missing Access<BR> 
msgClean = #Clean messages<BR>
msgSend = #Messages send<BR>
UmsgSend = #User messages send<BR>
CmsgSend = #Channel messages send<BR>
WmsgSend = #Webhook messages send<BR>
<BR>
### Table telegram
stickerFail = #Sticker failures<BR>
msgClean = #Clean messages<BR>
msgSend = #Messages send<BR>
UmsgSend = #User messages send<BR>
CmsgSend = #Channel messages send<BR>
GmsgSend = #Group messages send<BR>
<BR>
### Table error
warn = #warnings<BR>
warnMap = #warnings related to StaticMap<BR>
warnRL = #warning relate to Rate Limit<BR>
error = #errors<BR>
errorAddress = #errors due to nominatim getAddress<BR>
<BR>
### Table general
whQinMin = WebHook Queue inbound minimum<BR>
whQinMax = WebHook Queue inbound maximum<BR>
whQinAvg = WebHook Queue inbound average<BR>
<BR>
whQoutxxx = as above but outbound<BR>
<BR>
stopRL = user stops due to rate limit hit<BR>
stopUR = users stopped due to too many rate limit hits, stopped until User Reactivation<BR>
<BR>
### Table users
id = id from PoracleJS humans table<BR>
name = name from PoraleJS humans table<BR>
type = user or channel from PoracleJS humans table<BR>
msgSend = #discord messages send, excl clean<BR>
mon = #monster alerts send<BR>
raid = #raid alerts send<BR>
egg = #egg alerts send<BR>
invasion = #invasion alerts send<BR>
quest = #quest alerts send<BR>
mnc = Message Not Created due to rate limit<BR>
<BR>
### Table middleman
total = #POST_staticmap messages in log<BR>
post200 = #POST_staticmap resulting in http 200<BR>
post500 = #POST_staticmap resulting in http 500<BR>
<BR>
