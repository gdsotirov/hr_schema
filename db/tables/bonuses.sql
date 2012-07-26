﻿CREATE TABLE `bonuses` (
  `id`      INT(11)       NOT NULL AUTO_INCREMENT,
  `title`   VARCHAR(64)   NOT NULL,
  `amount`  DECIMAL(10,2) NOT NULL,

  PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
