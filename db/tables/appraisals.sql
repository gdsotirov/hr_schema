CREATE TABLE `appraisals` (
  `id`              INT(11)       NOT NULL  AUTO_INCREMENT,
  `employee_id`     INT(11)       NOT NULL,
  `period_type`     VARCHAR(16)   NOT NULL,
  `type`            VARCHAR(16)   NOT NULL,
  `period_from`     DATE          NOT NULL,
  `period_to`       DATE          NOT NULL,
  `interview_date`  DATE          NOT NULL,
  `appriser`        INT(11)       NOT NULL,
  `overall_eval`    DECIMAL(2,1)  NOT NULL,
  `document`        BLOB          NULL,

  PRIMARY KEY (`id`),

  KEY `fk_appraisal_employee_idx`     (`employee_id`),
  KEY `fk_appraisal_period_type_idx`  (`period_type`),
  KEY `fk_appraisal_type_idx`         (`type`),
  KEY `idx_appraisal_date`            (`interview_date`),
  KEY `fk_appraisal_appriser_idx`     (`appriser`),

  CONSTRAINT `fk_appraisal_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appraisal_period_type`
    FOREIGN KEY (`period_type`)
    REFERENCES `appraisal_period_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appraisal_type`
    FOREIGN KEY (`type`)
    REFERENCES `appraisal_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_appraisal_appriser`
    FOREIGN KEY (`appriser`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Employees appraisals';

