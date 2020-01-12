CREATE TABLE `person_relation_types` (
  `id`          VARCHAR(16) NOT NULL,
  `title`       VARCHAR(64) NOT NULL,
  `reverse_id`  VARCHAR(16) DEFAULT NULL  COMMENT 'Used to define the reverse relation',

  PRIMARY KEY (`id`),

  KEY `fk_prel_type_rev_idx` (`id`),

  CONSTRAINT `fk_prel_type_rev`
    FOREIGN KEY (`id`)
    REFERENCES `person_relation_types` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='Types of relations between persons';

