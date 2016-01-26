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
  `linkedin_profile`  VARCHAR(256)  DEFAULT NULL COMMENT 'URL to LinkedIn profile',
  `short_bio`         TEXT,
  `cv_doc`            LONGBLOB,

  PRIMARY KEY (`id`),

  UNIQUE KEY `idx_person_names` (`first_name`,`middle_name`,`last_name`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8;
