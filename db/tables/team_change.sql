CREATE TABLE `team_change` (
  `id`          INT(11) NOT NULL  AUTO_INCREMENT,
  `employee_id` INT(11) NOT NULL,
  `from_date`   DATE    NOT NULL,
  `department`  INT(11) NOT NULL,
  `granted_on`  DATE    DEFAULT NULL,
  `granted_by`  INT(11) NOT NULL,
  `approved_on` DATE    DEFAULT NULL,
  `approved_by` INT(11) NOT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_tmchng_employee`    (`employee_id`),
  KEY `fk_tmchng_department`  (`department`),
  KEY `fk_tmchng_granted`     (`granted_by`),
  KEY `fk_tmchng_approved`    (`approved_by`),

  CONSTRAINT `fk_tmchng_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tmchng_department`
    FOREIGN KEY (`department`)
    REFERENCES `departments` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tmchng_granted`
    FOREIGN KEY (`granted_by`)
    REFERENCES `employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tmchng_approved`
    FOREIGN KEY (`approved_by`)
    REFERENCES `employees` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
