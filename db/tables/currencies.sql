CREATE TABLE `currencies` (
  `id`        CHAR(3)     NOT NULL      COMMENT 'ISO code',
  `name`      VARCHAR(32) NOT NULL      COMMENT 'Currency full name',
  `symbol`    VARCHAR(3)  NOT NULL      COMMENT 'Currency symbol',
  `fraction`  VARCHAR(32) DEFAULT NULL  COMMENT 'Fractional unit',
  `basis`     INT(11)     DEFAULT NULL  COMMENT 'Basic amount or conversion',

  PRIMARY KEY (`id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='Currencies register';
