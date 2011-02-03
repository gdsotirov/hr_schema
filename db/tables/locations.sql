CREATE TABLE locations (
  `id`          INT(11)     NOT NULL  AUTO_INCREMENT,
  `name`        VARCHAR(64) NOT NULL,
  `country_id`  INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  INDEX `idx_location_name` (`name`       ASC),
  INDEX `fk_country_id`     (`country_id` ASC),

  CONSTRAINT `fk_country_id`
    FOREIGN KEY (`country_id`)
    REFERENCES `countries` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Locations of company\'s offices, wharehouses, etc.';
