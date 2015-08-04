CREATE TABLE `bonuses` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(64)   NOT NULL,
  `granted_on`  DATE          DEFAULT NULL,
  `granted_by`  INT(11)       DEFAULT NULL,
  `amount`      DECIMAL(12,2) DEFAULT NULL,
  `currency`    VARCHAR(5)    DEFAULT NULL,

  PRIMARY KEY (`id`)

  KEY `fk_bonuses_granted_idx` (`granted_by`),

  CONSTRAINT `fk_bonuses_granted`
    FOREIGN KEY (`granted_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
