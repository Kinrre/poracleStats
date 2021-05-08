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
  PRIMARY KEY (`Datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `error` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `warn` smallint(10) DEFAULT NULL,
  `warnMap` smallint(10) DEFAULT NULL,
  `warnRL` smallint(10) DEFAULT NULL,
  `error` smallint(10) DEFAULT NULL,
  PRIMARY KEY (`Datetime`)
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
  PRIMARY KEY (`Datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `Datetime` datetime NOT NULL,
  `RPL` smallint(6) NOT NULL,
  `id` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `msgSend` smallint(10) DEFAULT NULL,
  PRIMARY KEY (`Datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `version` (
  `key` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` smallint(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE IF EXISTS messages RENAME TO controller;

ALTER TABLE `controller`
ADD COLUMN IF NOT EXISTS  `RPL` smallint(6) NOT NULL AFTER `Datetime`,
ADD COLUMN IF NOT EXISTS `minMsgT` decimal(10,2) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `maxMsgT` decimal(10,2) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `avgMsgT` decimal(10,2) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `rateLimit` smallint(10) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `minMsgT0` decimal(10,2) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `maxMsgT0` decimal(10,2) DEFAULT NULL,
ADD COLUMN IF NOT EXISTS `avgMsgT0` decimal(10,2) DEFAULT NULL
;

-- update version
INSERT IGNORE INTO version values ('stats',1);
UPDATE version set version = 5;
