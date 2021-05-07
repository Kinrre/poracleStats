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

##  Meaning of columns
### Table messages:
Umon  = number of user messages created for monster<BR>
Uegg  = number of user messages created for eggs<BR>
Uraid  = number of user messages created for raids<BR>
Uquest  = number of user messages created for quests<BR>
Uinvasion  = number of user messages created for invasions<BR>
<BR>
Cxxxx = same as User messages above but for Channels<BR>
<BR>
minMsgT = for messages where at least 1 human cared, the lowest time to process it<BR>
maxMsgT = for messages where at least 1 human cared, the highest time to process it<BR>
avgsgT = for messages where at least 1 human cared, the average time to process them all<BR>
<BR>
rateLimit = number of messages not created due to human being rate limited

