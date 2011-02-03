CREATE TABLE departments (
  `id`          INT(11)     NOT NULL AUTO_INCREMENT,
  `name`        VARCHAR(64) NOT NULL,
  `size`        INT(11)     NULL COMMENT 'Number of persons into department',
  `manager_id`  INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  INDEX `idx_department_name` (`name` ASC)
)
ENGINE = InnoDB;
