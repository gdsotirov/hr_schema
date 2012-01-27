CREATE TABLE `regions` (
  `id`    INT(11)     NOT NULL AUTO_INCREMENT,
  `name`  VARCHAR(32) NOT NULL,

  PRIMARY KEY (`id`),

  KEY `idx_reg_name` (`name`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='List of country regions where the company has activities';
