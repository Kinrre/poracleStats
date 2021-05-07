CREATE TABLE IF NOT EXISTS `messages` (
  `Datetime` datetime NOT NULL,
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
  PRIMARY KEY (`Datetime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
