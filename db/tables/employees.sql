CREATE TABLE employees (
  `id`              INT(11)       NOT NULL  AUTO_INCREMENT,
  `first_name`      VARCHAR(64)   NOT NULL,
  `middle_name`     VARCHAR(64)   NULL,
  `last_name`       VARCHAR(64)   NOT NULL,
  `sex`             ENUM('male','female')
                                  NULL,
  `birth_date`      DATE          NULL,
  `picture`         BLOB          NULL,
  `martial_status`  ENUM('Single','Married')
                                  NULL,
  `children`        SMALLINT(6)   NULL,
  `contract_date`   DATE          NOT NULL,
  `hire_date`       DATE          NOT NULL,
  `leave_date`      DATE          NULL,
  `leave_reason`    BLOB          NULL,
  `job_id`          INT(11)       NOT NULL  COMMENT 'Current job',
  `manager_id`      INT(11)       NULL      COMMENT 'Current manager',
  `department_id`   INT(11)       NULL      COMMENT 'Current department',
  `division_id`     INT(11)       NOT NULL  COMMENT 'Current division',
  `salary`          DECIMAL(12,2) NOT NULL  COMMENT 'Current GROSS salary',

  PRIMARY KEY (`id`),

  INDEX `idx_emp_first_name`    (`first_name`     ASC),
  INDEX `idx_emp_last_name`     (`last_name`      ASC),
  UNIQUE INDEX `idx_emp_names`  (`first_name`     ASC,
                                 `middle_name`    ASC,
                                 `last_name`      ASC),
  INDEX `fk_emp_job_id`         (`job_id`         ASC),
  INDEX `fk_emp_manager_id`     (`manager_id`     ASC),
  INDEX `fk_emp_department_id`  (`department_id`  ASC),
  INDEX `fk_emp_division_id`    (`division_id`    ASC),

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
