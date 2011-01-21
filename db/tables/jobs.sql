CREATE TABLE jobs (
  `id`          INT(11)     NOT NULL  AUTO_INCREMENT,
  `title`       VARCHAR(64) NULL,
  `description` BLOB        NULL,
  `min_salary`  DECIMAL(6)  NULL,
  `max_salary`  DECIMAL(6)  NULL,

  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'List of jobs within the company';

CREATE INDEX `idx_job_title` ON `jobs` (`title` ASC);
