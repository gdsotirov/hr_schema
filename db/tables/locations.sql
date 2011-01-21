CREATE TABLE locations (
  `id`          INT(11)     NOT NULL  AUTO_INCREMENT,
  `name`        VARCHAR(64) NOT NULL,
  `country_id`  INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  CONSTRAINT `fk_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Locations of company\'s offices, wharehouses, etc.';

CREATE INDEX `idx_location_name` ON `locations` (`name` ASC);
CREATE INDEX `fk_country_id`     ON `locations` (`country_id` ASC);
