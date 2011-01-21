CREATE TABLE divisions (
  `id`          INT(11)     NOT NULL  AUTO_INCREMENT,
  `name`        VARCHAR(64) NOT NULL,
  `size`        INT(11)     NULL,
  `location_id` INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  CONSTRAINT `fk_division_location_id`
    FOREIGN KEY (`location_id`)
    REFERENCES `locations` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Company\'s divisions';

CREATE INDEX `idx_division_name`       ON `divisions` (`name` ASC);
CREATE INDEX `fk_division_location_id` ON `divisions` (`location_id` ASC);
