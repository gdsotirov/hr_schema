CREATE TABLE `absence_totals` (
  `id`          INT   NOT NULL  AUTO_INCREMENT,
  `type_id`     INT   NOT NULL,
  `employee_id` INT   NULL,
  `division_id` INT   NULL,
  `days`        INT   NOT NULL,
  `for_year`    YEAR  NOT NULL,
  `from_date`   DATE  NULL,

  PRIMARY KEY (`id`),

  INDEX `fk_abstot_type_idx`      (`type_id`      ASC),
  INDEX `fk_abstot_user_idx`      (`employee_id`  ASC),
  INDEX `fk_abstot_division_idx`  (`division_id`  ASC),

  CONSTRAINT `fk_abstot_type`
    FOREIGN KEY (`type_id`)
    REFERENCES `absence_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_abstot_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_abstot_division`
    FOREIGN KEY (`division_id`)
    REFERENCES `divisions` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Defines the maximum days per absence type, user or division to be used in a calendar year';
