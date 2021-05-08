# poracleStats

##  Setting up

- Clone poracleStats and copy config file: <br>``git clone https://github.com/dkmur/poracleStats.git && cd poracleStats/ && cp default_files/config.ini.example config.ini``
- Create stats database and grant privileges to user (make sure not to use ``$`` in password and, no, not going to escape it). i.e.:  
```
create database ##STATS_DB##;
grant all privileges on ##STATS_DB##.* to ##MYSELF##@localhost;
flush privileges;
```  
- Edit settings in ``config.ini``
- Execute ``./settings.run``, this will create required tables and crontab file
- Edit crontab ``crontab -e`` and insert content of ``crontab.txt`` located in poracleStats home.

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
  
### Table users
id = id from PoracleJS<BR>
type = user or channel from PoracleJS<BR>
msgSend = #discord messages send, excl clean<BR>
