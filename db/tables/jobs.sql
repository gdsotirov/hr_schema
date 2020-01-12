CREATE TABLE `jobs` (
  `id`          INT(11)       NOT NULL  AUTO_INCREMENT,
  `title`       VARCHAR(64)   NOT NULL,
  `description` BLOB          DEFAULT NULL,
  `min_salary`  DECIMAL(12,2) DEFAULT NULL,
  `max_salary`  DECIMAL(12,2) DEFAULT NULL,

  PRIMARY KEY (`id`),

  KEY `idx_job_title` (`title`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='List of jobs within the company with salary range';

