CREATE TABLE absences (
  `id`            INT(11)   NOT NULL  AUTO_INCREMENT,
  `employee_id`   INT(11)   NOT NULL,
  `from_date`     DATETIME  NOT NULL,
  `to_date`       DATETIME  NULL,
  `type`          INT(11)   NOT NULL,
  `authorized_by` INT(11)   NOT NULL,
  `deputy_id`     INT(11)   NULL,

  PRIMARY KEY (`id`),

  INDEX `fk_absence_employee`   (`employee_id`    ASC),
  INDEX `idx_vacation_date`     (`from_date`      ASC),
  INDEX `fk_absence_type`       (`type`           ASC),
  INDEX `fk_absence_authorized` (`authorized_by`  ASC),
  INDEX `fk_absence_deputy`     (`deputy_id`      ASC),

  CONSTRAINT `fk_absence_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_absence_type`
    FOREIGN KEY (`type`)
    REFERENCES `absence_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_absence_authorized`
    FOREIGN KEY (`authorized_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_absence_deputy`
    FOREIGN KEY (`deputy_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Emplooyees vacations registry';
