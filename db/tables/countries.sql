CREATE TABLE countries (
  `id`        INT(11)     NOT NULL AUTO_INCREMENT,
  `name`      VARCHAR(64) NOT NULL,
  `iso_code`  CHAR(3)     NULL,
  `region_id` INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  INDEX `idx_cntry_name`  (`name`       ASC),
  INDEX `fk_region_id`    (`region_id`  ASC),

  CONSTRAINT `fk_region_id`
    FOREIGN KEY (`region_id`)
    REFERENCES `regions` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'List of coutries where the company has activities';
