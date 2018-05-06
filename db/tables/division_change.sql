CREATE TABLE `division_change` (
  `id`          INT(11) NOT NULL  AUTO_INCREMENT,
  `employee_id` INT(11) NOT NULL,
  `from_date`   DATE    NOT NULL,
  `division_id` INT(11) NOT NULL,
  `granted_on`  DATE    DEFAULT NULL,
  `granted_by`  INT(11) DEFAULT NULL,
  `approved_on` DATE    DEFAULT NULL,
  `approved_by` INT(11) DEFAULT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_div_chng_emp_idx`       (`employee_id`),
  KEY `fk_div_chng_div_idx`       (`division_id`),
  KEY `fk_div_chng_granted_idx`   (`granted_by`),
  KEY `fk_div_chng_approved_idx`  (`approved_by`),

  CONSTRAINT `fk_div_chng_emp`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_div_chng_div`
    FOREIGN KEY (`division_id`)
    REFERENCES `divisions` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_div_chng_granted`
    FOREIGN KEY (`granted_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_div_chng_approved`
    FOREIGN KEY (`approved_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Employees division change register';
