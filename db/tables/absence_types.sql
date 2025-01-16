CREATE TABLE `absence_types` (
  `id`          INT(11)     NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(64) NOT NULL,
  `description` TEXT,
  `days_type`   ENUM('work','cal') DEFAULT NULL COMMENT 'Whether leave should be specified in working or calendar days',

  PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8m4
COMMENT='Types of possible absences';

