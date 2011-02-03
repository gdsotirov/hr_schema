CREATE TABLE bonus_distribution (
  `id`            INT(11)       NOT NULL  AUTO_INCREMENT,
  `bonus_id`      INT(11)       NOT NULL,
  `employee_id`   INT(11)       NOT NULL,
  `amount`        DECIMAL(12,2) NOT NULL  COMMENT 'Amount in GROSS',
  `granted_date`  DATE          NOT NULL,
  `granted_by`    INT(11)       NOT NULL,
  `approved_date` DATE          NULL,
  `approved_by`   INT(11)       NULL,
  `details`       VARCHAR(256)  NULL,

  PRIMARY KEY (`id`),

  INDEX `fk_bondtl_bonus`     (`bonus_id`       ASC),
  INDEX `fk_bondtl_employee`  (`employee_id`    ASC),
  INDEX `idx_granted_date`    (`granted_date`   ASC),
  INDEX `fk_bondtl_granted`   (`granted_by`     ASC),
  INDEX `idx_approved_date`   (`approved_date`  ASC),
  INDEX `fk_bondtl_approved`  (`approved_by`    ASC),

  CONSTRAINT `fk_bondtl_bonus`
    FOREIGN KEY (`bonus_id`)
    REFERENCES `bonuses` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_granted`
    FOREIGN KEY (`granted_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_approved`
    FOREIGN KEY (`approved_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE = InnoDB
COMMENT = 'Bonueses history';
