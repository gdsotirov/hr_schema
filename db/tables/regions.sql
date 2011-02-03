CREATE TABLE regions (
  `id`    INT(11)       NOT NULL  AUTO_INCREMENT,
  `name`  VARCHAR(128)  NULL,

  PRIMARY KEY (`id`),

  INDEX `idx_reg_name`  (`name` ASC)
)
ENGINE = InnoDB
COMMENT = 'List of country regions where the company has activities';
