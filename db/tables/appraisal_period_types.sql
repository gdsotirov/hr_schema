CREATE TABLE `appraisal_period_types` (
  `id`          VARCHAR(16) NOT NULL,
  `title`       VARCHAR(64) NOT NULL,
  `description` TEXT NULL,

  PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
