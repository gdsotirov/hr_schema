CREATE TABLE `employees` (
  `id`                INT(11)       NOT NULL  AUTO_INCREMENT,
  `person_id`         INT(11)       NOT NULL,
  `contract_date`     DATE          NOT NULL      COMMENT 'Date when contract was signed',
  `hire_date`         DATE          NOT NULL      COMMENT 'Date from which the employee started work',
  `trial_period`      INT(1)        DEFAULT NULL  COMMENT 'Trial Periods in months',
  `leave_date`        DATE          DEFAULT NULL  COMMENT 'Date on which the employee left company',
  `leave_reason`      TEXT                        COMMENT 'Reason for leave',
  `job_id`            INT(11)       NOT NULL      COMMENT 'Current job',
  `manager_id`        INT(11)       DEFAULT NULL  COMMENT 'Current manager',
  `department_id`     INT(11)       DEFAULT NULL  COMMENT 'Current department',
  `division_id`       INT(11)       NOT NULL      COMMENT 'Current division',
  `salary`            DECIMAL(14,3) DEFAULT NULL  COMMENT 'Current GROSS salary',
  `currency`          CHAR(3)       DEFAULT NULL,
  `newcomer_issue_id` VARCHAR(16)   DEFAULT NULL  COMMENT 'Related newcomer issue identifier (TTS key)',

  PRIMARY KEY (`id`),

  KEY `fk_emp_person_id_idx`      (`person_id`),
  KEY `fk_emp_job_id_idx`         (`job_id`),
  KEY `fk_emp_manager_id_idx`     (`manager_id`),
  KEY `fk_emp_department_id_idx`  (`department_id`),
  KEY `fk_emp_division_id_idx`    (`division_id`),
  KEY `fk_emp_currency_idx`       (`currency`),

  CONSTRAINT `fk_emp_person_id`
    FOREIGN KEY (`person_id`)
    REFERENCES `persons` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_job_id`
    FOREIGN KEY (`job_id`)
    REFERENCES `jobs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_manager_id`
    FOREIGN KEY (`manager_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_department_id`
    FOREIGN KEY (`department_id`)
    REFERENCES `departments` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_division_id`
    FOREIGN KEY (`division_id`)
    REFERENCES `divisions` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_currency`
    FOREIGN KEY (`currency`)
    REFERENCES `currencies` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Catalog of company''s most valuable resources';

