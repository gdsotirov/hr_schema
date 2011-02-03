CREATE TABLE jobs (
  `id`          INT(11)       NOT NULL  AUTO_INCREMENT,
  `title`       VARCHAR(64)   NOT NULL,
  `description` BLOB          NULL DEFAULT NULL,
  `min_salary`  DECIMAL(12,2) NULL DEFAULT NULL,
  `max_salary`  DECIMAL(12,2) NULL DEFAULT NULL,

  PRIMARY KEY (`id`),

  INDEX `idx_job_title` (`title`  ASC)
)
ENGINE = InnoDB
CHARACTER SET = utf8
COMMENT = 'List of jobs within the company';
