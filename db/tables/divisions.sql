CREATE TABLE `divisions` (
  `id`          INT(11)     NOT NULL  AUTO_INCREMENT,
  `name`        VARCHAR(64) NOT NULL,
  `established` DATE        DEFAULT NULL COMMENT 'Date on which the division was created',
  `size`        INT(11)     DEFAULT NULL COMMENT 'Current number of employees in the division',
  `location_id` INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  KEY `idx_division_name`     (`name`),
  KEY `fk_division_location`  (`location_id`),

  CONSTRAINT `fk_division_location`
    FOREIGN KEY (`location_id`)
    REFERENCES `locations` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Company''s divisions';
