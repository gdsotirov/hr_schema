CREATE TABLE sal_history (
  `id`          INT(11)       NOT NULL  AUTO_INCREMENT,
  `employee_id` INT(11)       NOT NULL,
  `from_date`   DATE          NOT NULL,
  `salary`      DECIMAL(12,2) NOT NULL,

  PRIMARY KEY (`id`),

  INDEX `fk_sal_hist_employee`  (`employee_id`  ASC),

  CONSTRAINT `fk_sal_hist_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB;
