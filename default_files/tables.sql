CREATE TABLE IF NOT EXISTS `controller` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `Umon` smallint(10) DEFAULT NULL,
  `Uegg` smallint(10) DEFAULT NULL,
  `Uraid` smallint(10) DEFAULT NULL,
  `Uquest` smallint(10) DEFAULT NULL,
  `Uinvasion` smallint(10) DEFAULT NULL,
  `Cmon` smallint(10) DEFAULT NULL,
  `Cegg` smallint(10) DEFAULT NULL,
  `Craid` smallint(10) DEFAULT NULL,
  `Cquest` smallint(10) DEFAULT NULL,
  `Cinvasion` smallint(10) DEFAULT NULL,
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
ADD COLUMN IF NOT EXISTS `noSend` smallint(10) DEFAULT NULL
;

ALTER TABLE `discord`
ADD COLUMN IF NOT EXISTS `UmsgSend` smallint(10) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `CmsgSend` smallint(10) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `WmsgSend` smallint(10) DEFAULT NULL
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
