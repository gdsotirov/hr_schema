CREATE TABLE `memos` (
  `id`            INT(11) NOT NULL AUTO_INCREMENT,
  `employee_id`   INT(11) NOT NULL COMMENT 'Related employee',
  `comment`       TEXT    NOT NULL,
  `from_date`     DATE    NOT NULL COMMENT 'Associative date',
  `type`          ENUM('Behaviour','Casus','Problem','Etics','Personal','Note')
                          NOT NULL COMMENT 'Defines the main subject of the memo',
  `written_by`    INT(11) NOT NULL COMMENT 'The author of the memo/note',

  PRIMARY KEY (`id`),

  KEY `fk_memo_employee_idx`  (`employee_id`),
  KEY `idx_memo_from`         (`from_date`),
  KEY `fk_memo_written_idx`   (`written_by`),

  CONSTRAINT `fk_memo_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_memo_written`
    FOREIGN KEY (`written_by`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Notes on employees behviour, attitude, problematics, etc.';
