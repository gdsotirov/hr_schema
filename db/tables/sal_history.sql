CREATE TABLE `sal_history` (
  `id`          INT(11)       NOT NULL  AUTO_INCREMENT,
  `employee_id` INT(11)       NOT NULL,
  `from_date`   DATE          NOT NULL,
  `amount`      DECIMAL(14,3) NOT NULL,
  `currency`    CHAR(3)       DEFAULT NULL,
  `granted_on`  DATE          DEFAULT NULL,
  `granted_by`  INT(11)       NOT NULL,
  `approved_on` DATE          DEFAULT NULL,
  `approved_by` INT(11)       NOT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_salhist_employee_idx` (`employee_id`),
  KEY `fk_salhist_currency_idx` (`currency`),
  KEY `fk_salhist_granted_idx`  (`granted_by`),
  KEY `fk_salhist_approved_idx` (`approved_by`),

  CONSTRAINT `fk_salhist_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_salhist_currency`
    FOREIGN KEY (`currency`)
    REFERENCES `currencies` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_salhist_granted`
    FOREIGN KEY (`granted_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_salhist_approved`
    FOREIGN KEY (`approved_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='Employees salary history';

