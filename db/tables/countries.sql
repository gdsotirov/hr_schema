CREATE TABLE countries (
  `id`        INT(11)     NOT NULL AUTO_INCREMENT,
  `name`      VARCHAR(64) NOT NULL,
  `iso_code`  CHAR(3)     NULL,
  `region_id` INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  CONSTRAINT `fk_region_id`
    FOREIGN KEY (`region_id`)
    REFERENCES `regions` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'List of coutries where the company has activities';

CREATE INDEX `idx_cntry_name` ON countries (`name` ASC);
CREATE INDEX `fk_region_id`   ON countries (`region_id` ASC);
