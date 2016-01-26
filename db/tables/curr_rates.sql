CREATE TABLE `curr_rates` (
  `id`        INT(11)       NOT NULL  AUTO_INCREMENT,
  `from_curr` CHAR(3)       NOT NULL,
  `to_curr`   CHAR(3)       NOT NULL,
  `for_date`  DATE          NOT NULL,
  `rate`      DECIMAL(10,7) NOT NULL,
  `country`   INT(11)       DEFAULT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_curr_rates_from_curr`   (`from_curr`),
  KEY `fk_curr_rates_to_curr`     (`to_curr`),
  KEY `fk_curr_rates_country_idx` (`country`),

  CONSTRAINT `fk_curr_rates_country`
    FOREIGN KEY (`country`)
    REFERENCES `countries` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_curr_rates_from_curr`
    FOREIGN KEY (`from_curr`)
    REFERENCES `currencies` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_curr_rates_to_curr`
    FOREIGN KEY (`to_curr`)
    REFERENCES `currencies` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Currency conversion rates register';
