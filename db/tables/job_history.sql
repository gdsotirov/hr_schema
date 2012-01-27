CREATE TABLE `job_history` (
  `id`          INT(11) NOT NULL  AUTO_INCREMENT,
  `employee_id` INT(11) NOT NULL,
  `from_date`   DATE    NOT NULL,
  `job_id`      INT(11) NOT NULL,
  `granted_on`  DATE    DEFAULT NULL,
  `granted_by`  INT(11) NOT NULL,
  `approved_on` DATE    DEFAULT NULL,
  `approved_by` INT(11) NOT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_jobhist_employee` (`employee_id`),
  KEY `fk_jobhist_job`      (`job_id`),
  KEY `fk_jobhist_granted`  (`granted_by`),
  KEY `fk_jobhist_approved` (`approved_by`),

  CONSTRAINT `fk_jobhist_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON UPDATE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_job`
    FOREIGN KEY (`job_id`)
    REFERENCES `jobs` (`id`)
    ON UPDATE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_granted`
    FOREIGN KEY (`granted_by`)
    REFERENCES `employees` (`id`)
    ON UPDATE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_approved`
    FOREIGN KEY (`approved_by`)
    REFERENCES `employees` (`id`)
    ON UPDATE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
