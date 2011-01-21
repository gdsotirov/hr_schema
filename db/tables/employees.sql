CREATE TABLE employees (
  `id`            INT(11)       NOT NULL  AUTO_INCREMENT,
  `first_name`    VARCHAR(64)   NOT NULL,
  `middle_name`   VARCHAR(64)   NULL,
  `last_name`     VARCHAR(64)   NOT NULL,
  `sex`           ENUM('man','women')
                                NULL,
  `birth_date`    DATE          NULL,
  `contract_date` DATE          NOT NULL,
  `hire_date`     DATE          NOT NULL,
  `job_id`        INT(11)       NOT NULL COMMENT 'Current job',
  `manager_id`    INT(11)       NOT NULL COMMENT 'Current manager',
  `department_id` INT(11)       NOT NULL COMMENT 'Current department',
  `division_id`   INT(11)       NOT NULL COMMENT 'Current division',
  `salary`        DECIMAL(12,2) NOT NULL COMMENT 'Current GROSS salary',

  PRIMARY KEY (`id`),

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
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Catalog of company\'s most valuable resource';

CREATE INDEX `idx_emp_first_name`   ON `employees` (`first_name` ASC);
CREATE INDEX `idx_emp_last_name`    ON `employees` (`last_name` ASC);
CREATE INDEX `fk_emp_job_id`        ON `employees` (`job_id` ASC);
CREATE INDEX `fk_emp_manager_id`    ON `employees` (`manager_id` ASC);
CREATE INDEX `fk_emp_department_id` ON `employees` (`department_id` ASC);
CREATE INDEX `fk_emp_division_id`   ON `employees` (`division_id` ASC);
