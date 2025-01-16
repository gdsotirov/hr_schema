CREATE TABLE `person_relations` (
  `id`        INT(11)     NOT NULL AUTO_INCREMENT,
  `person1`   INT(11)     NOT NULL,
  `type`      VARCHAR(16) NOT NULL,
  `person2`   INT(11)     NOT NULL,
  `from_date` DATE        DEFAULT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_prel_person1_idx` (`person1`),
  KEY `fk_prel_type_idx`    (`type`),
  KEY `fk_prel_person2_idx` (`person2`),

  CONSTRAINT `fk_prel_person1`
    FOREIGN KEY (`person1`)
    REFERENCES `persons` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_prel_type`
    FOREIGN KEY (`type`)
    REFERENCES `person_relation_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_prel_person2`
    FOREIGN KEY (`person2`)
    REFERENCES `persons` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='Relations between persons';

