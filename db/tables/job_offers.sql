CREATE TABLE `job_offers` (
  `id`          INT(11)     NOT NULL AUTO_INCREMENT,
  `title`       VARCHAR(64) NOT NULL,
  `description` BLOB        NOT NULL,
  `job_id`      INT(11)     NOT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_job_offer_job_id_idx` (`job_id`),

  CONSTRAINT `fk_job_offer_job_id`
    FOREIGN KEY (`job_id`)
    REFERENCES `jobs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
