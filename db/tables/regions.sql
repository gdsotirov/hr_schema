CREATE TABLE regions (
  `id`    INT(11)       NOT NULL  AUTO_INCREMENT,
  `name`  VARCHAR(128)  NULL,

  PRIMARY KEY (`id`)
)
ENGINE = InnoDB
COMMENT = 'List of country regions where the company has activities';
