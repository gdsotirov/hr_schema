CREATE TABLE job_candidates (
  `id`                INT(11)     NOT NULL AUTO_INCREMENT,
  `first_name`        VARCHAR(64) NOT NULL,
  `middle_name`       VARCHAR(64) NULL,
  `last_name`         VARCHAR(64) NOT NULL,
  `sex`               ENUM('male','female')
                                  NULL,
  `birth_date`        DATE        NOT NULL,
  `cv_doc`            BLOB        NULL,
  `job_id`            INT(11)     NOT NULL,
  `first_interview`   DATE        NOT NULL,
  `second_interview`  DATE        NULL,
  `third_interview`   DATE        NULL,
  `status`            ENUM('Approved','Rejected', 'Pending')
                                  NULL,
  `employee_id`       INT(11)     NULL,

  PRIMARY KEY (`id`),

  INDEX `idx_candidate_names`       (`first_name`       ASC,
                                     `last_name`        ASC),
  INDEX `idx_candidate_interviewed` (`first_interview`  ASC),
  INDEX `fk_candidate_job`          (`job_id`           ASC),
  INDEX `fk_candidate_employee`     (`employee_id`      ASC),

  CONSTRAINT `fk_candidate_job`
    FOREIGN KEY (`job_id`)
    REFERENCES `jobs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_candidate_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Catalog of job candidates';
