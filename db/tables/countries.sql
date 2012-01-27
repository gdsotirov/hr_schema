CREATE TABLE `countries` (
  `id`              INT(11)       NOT NULL  AUTO_INCREMENT,
  `iso_num3`        CHAR(3)       NOT NULL  COMMENT 'ISO 3166-1 numeric 3 code',
  `iso_code2`       CHAR(2)       NOT NULL  COMMENT 'ISO 3166-1 alpha-2 code',
  `iso_code3`       CHAR(3)       NOT NULL  COMMENT 'ISO 3166-1 alpha-3 code',
  `name_en`         VARCHAR(64)   NOT NULL  COMMENT 'English short name',
  `name_fr`         VARCHAR(64)   NOT NULL  COMMENT 'French short name',
  `fullname_en`     VARCHAR(128)  DEFAULT NULL  COMMENT 'English full name',
  `fullname_fr`     VARCHAR(128)  DEFAULT NULL  COMMENT 'French full name',
  `remark_en`       VARCHAR(64)   DEFAULT NULL,
  `remark_fr`       VARCHAR(64)   DEFAULT NULL,
  `adm_lang2`       CHAR(2)       DEFAULT NULL,
  `adm_lang3`       CHAR(3)       DEFAULT NULL,
  `shortname_local` VARCHAR(64)   DEFAULT NULL,
  `un_member_since` DATE          DEFAULT NULL,
  `un_member_until` DATE          DEFAULT NULL,
  `tld`             CHAR(3)       DEFAULT NULL C  OMMENT 'Top level domain',
  `calling_code`    VARCHAR(10)   DEFAULT NULL,
  `region_id`       INT(11)       NOT NULL,

  PRIMARY KEY (`id`),

  UNIQUE KEY  `idx_iso_num3`    (`iso_num3`),
  UNIQUE KEY  `idx_iso_code2`   (`iso_code2`),
  UNIQUE KEY  `idx_iso_code3`   (`iso_code3`),
  KEY         `idx_name_en`     (`name_en`),
  UNIQUE KEY  `idx_tld`         (`tld`),
  KEY         `fk_ctry_region`  (`region_id`),

  CONSTRAINT `fk_ctry_region`
    FOREIGN KEY (`region_id`)
    REFERENCES `regions` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8
COMMENT='List of coutries where the company has activities';
