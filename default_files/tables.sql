CREATE TABLE IF NOT EXISTS `controller` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `DUmon` smallint(10) DEFAULT NULL,
  `DUegg` smallint(10) DEFAULT NULL,
  `DUraid` smallint(10) DEFAULT NULL,
  `DUquest` smallint(10) DEFAULT NULL,
  `DUinvasion` smallint(10) DEFAULT NULL,
  `DUweather` smallint(10) DEFAULT NULL,
  `DCmon` smallint(10) DEFAULT NULL,
  `DCegg` smallint(10) DEFAULT NULL,
  `DCraid` smallint(10) DEFAULT NULL,
  `DCquest` smallint(10) DEFAULT NULL,
  `DCinvasion` smallint(10) DEFAULT NULL,
  `DCweather` smallint(10) DEFAULT NULL,
  `DWmon` smallint(10) DEFAULT NULL,
  `DWegg` smallint(10) DEFAULT NULL,
  `DWraid` smallint(10) DEFAULT NULL,
  `DWquest` smallint(10) DEFAULT NULL,
  `DWinvasion` smallint(10) DEFAULT NULL,
  `DWweather` smallint(10) DEFAULT NULL,
  `TUmon` smallint(10) DEFAULT NULL,
  `TUegg` smallint(10) DEFAULT NULL,
  `TUraid` smallint(10) DEFAULT NULL,
  `TUquest` smallint(10) DEFAULT NULL,
  `TUinvasion` smallint(10) DEFAULT NULL,
  `TUweather` smallint(10) DEFAULT NULL,
  `TCmon` smallint(10) DEFAULT NULL,
  `TCegg` smallint(10) DEFAULT NULL,
  `TCraid` smallint(10) DEFAULT NULL,
  `TCquest` smallint(10) DEFAULT NULL,
  `TCinvasion` smallint(10) DEFAULT NULL,
  `TCweather` smallint(10) DEFAULT NULL,
  `TGmon` smallint(10) DEFAULT NULL,
  `TGegg` smallint(10) DEFAULT NULL,
  `TGraid` smallint(10) DEFAULT NULL,
  `TGquest` smallint(10) DEFAULT NULL,
  `TGinvasion` smallint(10) DEFAULT NULL,
  `TGweather` smallint(10) DEFAULT NULL,
  `minMsgT` decimal(10,2) DEFAULT NULL,
  `maxMsgT` decimal(10,2) DEFAULT NULL,
  `avgMsgT` decimal(10,2) DEFAULT NULL,
  `rateLimit` smallint(10) DEFAULT NULL,
  `minMsgT0` decimal(10,2) DEFAULT NULL,
  `maxMsgT0` decimal(10,2) DEFAULT NULL,
  `avgMsgT0` decimal(10,2) DEFAULT NULL,
  `noSend` smallint(10) DEFAULT NULL,
  PRIMARY KEY (Datetime,RPL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `error` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `warn` smallint(10) DEFAULT NULL,
  `warnMap` smallint(10) DEFAULT NULL,
  `warnRL` smallint(10) DEFAULT NULL,
  `error` smallint(10) DEFAULT NULL,
  `errorAddress` smallint(10) DEFAULT NULL,
  PRIMARY KEY (Datetime,RPL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `general` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `whQinMin` smallint(10) DEFAULT NULL,
  `whQinMax` smallint(10) DEFAULT NULL,
  `whQinAvg` smallint(10) DEFAULT NULL,
  `whQoutMin` smallint(10) DEFAULT NULL,
  `whQoutMax` smallint(10) DEFAULT NULL,
  `whQoutAvg` smallint(10) DEFAULT NULL,
  `stopRL` smallint(10) DEFAULT NULL,
  `stopUR` smallint(10) DEFAULT NULL,
  PRIMARY KEY (Datetime,RPL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `discord` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `warn` smallint(10) DEFAULT NULL,
  `error` smallint(10) DEFAULT NULL,
  `errorBG` smallint(10) DEFAULT NULL,
  `errorUA` smallint(10) DEFAULT NULL,
  `msgClean` smallint(10) DEFAULT NULL,
  `msgSend` smallint(10) DEFAULT NULL,
  `UmsgSend` smallint(10) DEFAULT NULL,
  `CmsgSend` smallint(10) DEFAULT NULL,
  `WmsgSend` smallint(10) DEFAULT NULL,
  PRIMARY KEY (Datetime,RPL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `telegram` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `stickerFail` smallint(10) DEFAULT NULL,
  `msgClean` smallint(10) DEFAULT NULL,
  `msgSend` smallint(10) DEFAULT NULL,
  `UmsgSend` smallint(10) DEFAULT NULL,
  `CmsgSend` smallint(10) DEFAULT NULL,
  `GmsgSend` smallint(10) DEFAULT NULL,
  PRIMARY KEY (Datetime,RPL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `type` varchar(255) NOT NULL,
  `msgSend` smallint(10) DEFAULT NULL,
  `mon` smallint(10) DEFAULT NULL,
  `egg` smallint(10) DEFAULT NULL,
  `raid` smallint(10) DEFAULT NULL,
  `quest` smallint(10) DEFAULT NULL,
  `invasion` smallint(10) DEFAULT NULL,
  `stopRL` smallint(10) DEFAULT NULL,
  `stopUR` smallint(10) DEFAULT NULL,
  `mnc` smallint(10) DEFAULT NULL,
  PRIMARY KEY (Datetime,id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `middleman` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `total` smallint(10) DEFAULT NULL,
  `post200` smallint(10) DEFAULT NULL,
  `post500` smallint(10) DEFAULT NULL,
  PRIMARY KEY (Datetime,RPL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `version` (
  `key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` smallint(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE `controller`
CHANGE COLUMN IF EXISTS `Umon` `DUmon` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Uegg` `DUegg` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Uraid` `DUraid` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Uquest` `DUquest` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Uinvasion` `DUinvasion` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Cmon` `DCmon` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Cegg` `DCegg` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Craid` `DCraid` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Cquest` `DCquest` smallint(10) DEFAULT NULL,
CHANGE COLUMN IF EXISTS `Cinvasion` `DCinvasion` smallint(10) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `DUweather` smallint(10) DEFAULT NULL AFTER DUinvasion,
ADD COLUMN IF NOT EXISTS `DCweather` smallint(10) DEFAULT NULL AFTER DCinvasion,
ADD COLUMN IF NOT EXISTS `DWmon` smallint(10) DEFAULT NULL AFTER DCweather,
ADD COLUMN IF NOT EXISTS `DWegg` smallint(10) DEFAULT NULL AFTER DWmon,
ADD COLUMN IF NOT EXISTS `DWraid` smallint(10) DEFAULT NULL AFTER DWegg,
ADD COLUMN IF NOT EXISTS `DWquest` smallint(10) DEFAULT NULL AFTER DWraid,
ADD COLUMN IF NOT EXISTS `DWinvasion` smallint(10) DEFAULT NULL AFTER DWquest,
ADD COLUMN IF NOT EXISTS `DWweather` smallint(10) DEFAULT NULL AFTER DWinvasion,
ADD COLUMN IF NOT EXISTS `TUmon` smallint(10) DEFAULT NULL AFTER DWweather,
ADD COLUMN IF NOT EXISTS `TUegg` smallint(10) DEFAULT NULL AFTER TUmon,
ADD COLUMN IF NOT EXISTS `TUraid` smallint(10) DEFAULT NULL AFTER TUegg,
ADD COLUMN IF NOT EXISTS `TUquest` smallint(10) DEFAULT NULL AFTER TUraid,
ADD COLUMN IF NOT EXISTS `TUinvasion` smallint(10) DEFAULT NULL AFTER TUquest,
ADD COLUMN IF NOT EXISTS `TUweather` smallint(10) DEFAULT NULL AFTER TUinvasion,
ADD COLUMN IF NOT EXISTS `TCmon` smallint(10) DEFAULT NULL AFTER TUweather,
ADD COLUMN IF NOT EXISTS `TCegg` smallint(10) DEFAULT NULL AFTER TCmon,
ADD COLUMN IF NOT EXISTS `TCraid` smallint(10) DEFAULT NULL AFTER TCegg,
ADD COLUMN IF NOT EXISTS `TCquest` smallint(10) DEFAULT NULL AFTER TCraid,
ADD COLUMN IF NOT EXISTS `TCinvasion` smallint(10) DEFAULT NULL AFTER TCquest,
ADD COLUMN IF NOT EXISTS `TCweather` smallint(10) DEFAULT NULL AFTER TCinvasion,
ADD COLUMN IF NOT EXISTS `TGmon` smallint(10) DEFAULT NULL AFTER TCweather,
ADD COLUMN IF NOT EXISTS `TGegg` smallint(10) DEFAULT NULL AFTER TGmon,
ADD COLUMN IF NOT EXISTS `TGraid` smallint(10) DEFAULT NULL AFTER TGegg,
ADD COLUMN IF NOT EXISTS `TGquest` smallint(10) DEFAULT NULL AFTER TGraid,
ADD COLUMN IF NOT EXISTS `TGinvasion` smallint(10) DEFAULT NULL AFTER TGquest,
ADD COLUMN IF NOT EXISTS `TGweather` smallint(10) DEFAULT NULL AFTER TGinvasion,
ADD COLUMN IF NOT EXISTS `noSend` smallint(10) DEFAULT NULL
;

ALTER TABLE `discord`
ADD COLUMN IF NOT EXISTS `UmsgSend` smallint(10) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `CmsgSend` smallint(10) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `WmsgSend` smallint(10) DEFAULT NULL
;

ALTER TABLE `error`
ADD COLUMN IF NOT EXISTS `errorAddress` smallint(10) DEFAULT NULL
;

ALTER TABLE `middleman`
ADD COLUMN IF NOT EXISTS `total` smallint(10) DEFAULT NULL AFTER `RPL`
;

ALTER TABLE `users`
ADD COLUMN IF NOT EXISTS `name` varchar(255) DEFAULT NULL AFTER `id`,
ADD COLUMN IF NOT EXISTS `mnc` smallint(10) DEFAULT NULL
;

-- update version
INSERT IGNORE INTO version values ('poraclestats',1);
UPDATE version set version = 11 where version.key = 'poraclestats';
