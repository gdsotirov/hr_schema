CREATE TABLE `absences` (
  `id`            INT(11)   NOT NULL AUTO_INCREMENT,
  `employee_id`   INT(11)   NOT NULL,
  `from_date`     DATETIME  NOT NULL,
  `to_date`       DATETIME  DEFAULT NULL,
  `type`          INT(11)   NOT NULL,
  `for_year`      INT(11)   DEFAULT NULL  COMMENT 'In case of paid leave, for which year is valid',
  `description`   TEXT                    COMMENT 'Additional information about the absence',
  `authorized_by` INT(11)   NOT NULL,
  `deputy_id`     INT(11)   DEFAULT NULL,
  `status`        ENUM('Requested','Authorized','Unauthorized','Cancelled')
                            NOT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_absence_employee_idx`   (`employee_id`),
  KEY `idx_vacation_date`         (`from_date`),
  KEY `fk_absence_type_idx`       (`type`),
  KEY `fk_absence_authorized_idx` (`authorized_by`),
  KEY `fk_absence_deputy_idx`     (`deputy_id`),

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
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Register of employees absences';

