CREATE TABLE `bonuses` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(64)   NOT NULL,
  `granted_on`  DATE          DEFAULT NULL,
  `granted_by`  INT(11)       DEFAULT NULL,
  `amount`      DECIMAL(12,2) DEFAULT NULL,

  PRIMARY KEY (`id`)

  KEY `fk_bonus_granted_by_idx` (`granted_by`),

  CONSTRAINT `fk_bonuses_granted`
    FOREIGN KEY (`granted_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
