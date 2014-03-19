﻿CREATE TABLE `bonus_distribution` (
  `id`          INT(11)       NOT NULL AUTO_INCREMENT,
  `bonus_id`    INT(11)       NOT NULL,
  `employee_id` INT(11)       NOT NULL,
  `amount`      DECIMAL(12,2) NOT NULL COMMENT 'Amount in GROSS',
  `granted_on`  DATE          NOT NULL,
  `granted_by`  INT(11)       NOT NULL,
  `approved_on` DATE          DEFAULT NULL,
  `approved_by` INT(11)       DEFAULT NULL,
  `details`     VARCHAR(256)  DEFAULT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_bondtl_employee_idx`  (`employee_id`),
  KEY `fk_bondtl_bonus_idx`     (`bonus_id`),
  KEY `idx_granted_date`        (`granted_on`),
  KEY `fk_bondtl_granted_idx`   (`granted_by`),
  KEY `fk_bondtl_approved_idx`  (`approved_by`),
  KEY `idx_approved_date`       (`approved_on`),

  CONSTRAINT `fk_bondtl_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_bonus`
    FOREIGN KEY (`bonus_id`)
    REFERENCES `bonuses` (`id`)
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
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Bonueses history';
