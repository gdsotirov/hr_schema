CREATE TABLE `persons` (
  `id`                INT(11)       NOT NULL AUTO_INCREMENT,
  `first_name`        VARCHAR(64)   NOT NULL,
  `middle_name`       VARCHAR(64)   DEFAULT NULL,
  `maiden_name`       VARCHAR(32)   DEFAULT NULL,
  `last_name`         VARCHAR(64)   NOT NULL,
  `sex`               ENUM('Male','Female')
                                    NOT NULL,
  `birth_date`        DATE          DEFAULT NULL,
  `death_date`        DATE          DEFAULT NULL,
  `picture`           BLOB,
  `martial_status`    ENUM('Single','Married','Cohabitation','Divorced','Widowed','Separated')
                                    DEFAULT NULL,
  `children`          DECIMAL(2,0)  DEFAULT NULL,
  `personal_id`       VARCHAR(32)   DEFAULT NULL,
  `short_bio`         TEXT          DEFAULT NULL,
  `cv_doc`            LONGBLOB      DEFAULT NULL,
  `linkedin_profile`  VARCHAR(256)  DEFAULT NULL COMMENT 'URL to LinkedIn profile',

  `prior_internship_yrs` INT(2) NULL COMMENT 'Prior internship in years',
  `prior_internship_mns` INT(2) NULL COMMENT 'Prior internship in months',
  `prior_internship_dys` INT(2) NULL COMMENT 'Prior internship in days',

  PRIMARY KEY (`id`),

  UNIQUE KEY `idx_person_names` (`first_name` ASC, `middle_name` ASC, `last_name` ASC) VISIBLE,
  KEY `idx_person_bd` (`birth_date`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
