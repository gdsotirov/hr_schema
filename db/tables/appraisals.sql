CREATE TABLE `appraisals` (
  `id`              INT(11)       NOT NULL  AUTO_INCREMENT,
  `employee_id`     INT(11)       NOT NULL,
  `interview_date`  DATE          NOT NULL,
  `appriser`        INT(11)       NOT NULL,
  `overall_eval`    DECIMAL(2,1)  NOT NULL,
  `document`        BLOB          NULL,

  PRIMARY KEY (`id`),

  INDEX `fk_appraisal_employee` (`employee_id`    ASC),
  INDEX `idx_appraisal_date`    (`interview_date` ASC),
  INDEX `fk_appraisal_appriser` (`appriser`       ASC),

  CONSTRAINT `fk_appraisal_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appraisal_appriser`
    FOREIGN KEY (`appriser`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Employees appraisls';
 