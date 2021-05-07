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
