CREATE TABLE `locations` (
  `id`          INT(11)     NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64) NOT NULL,
  `country_id`  INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  KEY `idx_location_name` (`name`),
  KEY `fk_loc_country`    (`country_id`),

  CONSTRAINT `fk_loc_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Locations of company''s offices, wharehouses, etc.';
