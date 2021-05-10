# poracleStats

Since nobody with an actual brain picked this up, this idiot gave it a go. <BR>
<BR>
Hourly process PoracleJS logs and store into database.<BR>
<BR>
Numbers are being added to DB, roughly un-verified, so feeback is appreciated. Bitch at it please :)
<BR>

tbd:<BR>
 - 1440 and 10080 aggregation, added working?
 - add/update grafana templates, added working?
 - create grafana performance overview dashboard, added working?
 - add grafana installation to wiki
 - add + update user name to table users and update daily from PoracleDB?
 - add cleanup of tables after Xdays? 
 - telegram??

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
Requires Poracle logging to be set to
```
    "logger": {
        "consoleLogLevel": "verbose",
        "logLevel": "verbose",
```

## Updates
- git pull
- check for any changes in default_files/config.ini.example and adapt accordingly
- execute ``./settings.run`` 
- update grafana templates when changed

##  Meaning of columns
### Table controller:
Umon  = #User messages created for monster<BR>
Uegg  = #User messages created for eggs<BR>
Uraid  = #User messages created for raids<BR>
Uquest  = #User messages created for quests<BR>
Uinvasion  = #User messages created for invasions<BR>
<BR>
Cxxxx = same as User messages above but for Channels<BR>
<BR>
minMsgT = for messages where at least 1 human cared, the lowest time to process it (ms)<BR>
maxMsgT = for messages where at least 1 human cared, the highest time to process it (ms)<BR>
avgsgT = for messages where at least 1 human cared, the average time to process them all (ms)<BR>
<BR>
rateLimit = #messages not created due to user being rate limited<BR>
<BR>
xxxMsgT0 = like xxxMsgT but 0 humans cared<BR>
  
### Table discord
warn = #warnings<BR>
error = #errors<BR>
errorBG = #errors on Bad Gateway<BR>
errorUA = #errors on User Aborted requests<BR>
msgClean = #Clean messages<BR>
msgSend = #Messages send<BR>

### Table error
warn = #warnings<BR>
warnMap = #warnings related to StaticMap<BR>
warnRL = #warning relate to Rate Limit<BR>
error = #errors<BR>

### Table general
whQinMin = WebHook Queue inbound minimum <BR>
whQinMax = WebHook Queue inbound maximum<BR>
whQinAvg = WebHook Queue inbound average<BR>
<BR>
whQoutxxx = as above but outbound<BR>
<BR>
stopRL = user stops due to rate limit hit<BR>
stopUR = users stopped due to too many rate limit hits, stopped until User Reactivation<BR>

### Table users
id = id from PoracleJS<BR>
type = user or channel from PoracleJS<BR>
msgSend = #discord messages send, excl clean<BR>
mon = #monster alerts send<BR>
raid = #raid alerts send<BR>
egg = #egg alerts send<BR>
invasion = #invasion alerts send<BR>
quest = #quest alerts send<BR>

### Table middleman
total = #POST_staticmap messages in log<BR>
post200 = #POST_staticmap resulting in http 200<BR>
post500 = #POST_staticmap resulting in http 500<BR>
