CREATE TABLE IF NOT EXISTS job_history (
  `id`            INT(11)       NOT NULL,
  `employee_id`   INT(11)       NOT NULL,
  `from_date`     DATE          NOT NULL,
  `job_id`        INT(11)       NOT NULL,
  `salary`        DECIMAL(12,2) NULL COMMENT 'GROSS salary',

  PRIMARY KEY (`id`),

  INDEX `fk_jobhist_employee_id`  (`employee_id`  ASC),
  INDEX `fk_jobhist_job_id`       (`job_id`       ASC),

  CONSTRAINT `fk_jobhist_employee_id`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_job_id`
    FOREIGN KEY (`job_id`)
    REFERENCES `jobs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB;
