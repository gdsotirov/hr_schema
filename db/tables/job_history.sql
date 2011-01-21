CREATE TABLE IF NOT EXISTS job_history (
  `id`            INT(11)       NOT NULL,
  `employee_id`   INT(11)       NOT NULL,
  `start_date`    DATE          NOT NULL,
  `end_date`      DATE          NOT NULL,
  `job_id`        INT(11)       NOT NULL,
  `manager_id`    INT(11)       NOT NULL,
  `department_id` INT(11)       NOT NULL,
  `division_id`   INT(11)       NOT NULL,
  `salary`        DECIMAL(12,2) NULL COMMENT 'GROSS salary',

  PRIMARY KEY (`id`),

  CONSTRAINT `fk_jobhist_employee_id`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_department_id`
    FOREIGN KEY (`department_id`)
    REFERENCES `departments` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_division_id`
    FOREIGN KEY (`division_id`)
    REFERENCES `divisions` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_job_id`
    FOREIGN KEY (`job_id`)
    REFERENCES `jobs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_manager_id`
    FOREIGN KEY (`manager_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB;

CREATE INDEX `fk_jobhist_employee_id`   ON `job_history` (`employee_id` ASC);
CREATE INDEX `fk_jobhist_department_id` ON `job_history` (`department_id` ASC);
CREATE INDEX `fk_jobhist_division_id`   ON `job_history` (`division_id` ASC);
CREATE INDEX `fk_jobhist_job_id`        ON `job_history` (`job_id` ASC);
CREATE INDEX `fk_jobhist_manager_id`    ON `job_history` (`manager_id` ASC);
