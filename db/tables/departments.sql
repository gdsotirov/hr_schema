CREATE TABLE `departments` (
  `id`          INT(11)     NOT NULL  AUTO_INCREMENT,
  `name`        VARCHAR(64) NOT NULL,
  `established` DATE        DEFAULT NULL  COMMENT 'Date on which the department was created',
  `size`        INT(11)     DEFAULT NULL  COMMENT 'Current number of employees working in the department',
  `manager_id`  INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  KEY `idx_department_name` (`name`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
