SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `hr_schema` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
SHOW WARNINGS;
USE `hr_schema` ;

-- -----------------------------------------------------
-- Table `hr_schema`.`regions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`regions` (
  `id` INT(11)  NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(128) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'List of country regions where the company has activities';

SHOW WARNINGS;
CREATE INDEX `idx_reg_name` ON `hr_schema`.`regions` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `hr_schema`.`countries`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`countries` (
  `id` INT(11)  NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `iso_code` CHAR(3) NULL ,
  `region_id` INT(11)  NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_region_id`
    FOREIGN KEY (`region_id` )
    REFERENCES `hr_schema`.`regions` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'List of coutries where the company has activities';

SHOW WARNINGS;
CREATE INDEX `idx_cntry_name` ON `hr_schema`.`countries` (`name` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_region_id` ON `hr_schema`.`countries` (`region_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `hr_schema`.`locations`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`locations` (
  `id` INT(11)  NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `country_id` INT(11)  NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_country_id`
    FOREIGN KEY (`country_id` )
    REFERENCES `hr_schema`.`countries` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Locations of company\'s offices, wharehouses, etc.';

SHOW WARNINGS;
CREATE INDEX `idx_location_name` ON `hr_schema`.`locations` (`name` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_country_id` ON `hr_schema`.`locations` (`country_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `hr_schema`.`jobs`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`jobs` (
  `id` INT(11)  NOT NULL AUTO_INCREMENT ,
  `title` VARCHAR(64) NULL ,
  `description` BLOB NULL ,
  `min_salary` DECIMAL(6) NULL ,
  `max_salary` DECIMAL(6) NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
COMMENT = 'List of jobs within the company';

SHOW WARNINGS;
CREATE INDEX `idx_job_title` ON `hr_schema`.`jobs` (`title` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `hr_schema`.`departments`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`departments` (
  `id` INT(11)  NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `size` INT(11)  NULL COMMENT 'Number of persons into department' ,
  `manager_id` INT(11)  NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `idx_department_name` ON `hr_schema`.`departments` (`name` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `hr_schema`.`divisions`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`divisions` (
  `id` INT(11)  NOT NULL AUTO_INCREMENT ,
  `name` VARCHAR(64) NOT NULL ,
  `size` INT(11)  NULL ,
  `location_id` INT(11)  NOT NULL ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_division_location_id`
    FOREIGN KEY (`location_id` )
    REFERENCES `hr_schema`.`locations` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Company\'s divisions';

SHOW WARNINGS;
CREATE INDEX `idx_division_name` ON `hr_schema`.`divisions` (`name` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_division_location_id` ON `hr_schema`.`divisions` (`location_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `hr_schema`.`employees`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`employees` (
  `id` INT(11)  NOT NULL AUTO_INCREMENT ,
  `first_name` VARCHAR(64) NOT NULL ,
  `middle_name` VARCHAR(64) NULL ,
  `last_name` VARCHAR(64) NOT NULL ,
  `sex` ENUM('man','women') NULL ,
  `birth_date` DATE NULL ,
  `contract_date` DATE NOT NULL ,
  `hire_date` DATE NOT NULL ,
  `job_id` INT(11)  NOT NULL COMMENT 'Current job' ,
  `manager_id` INT(11)  NOT NULL COMMENT 'Current manager' ,
  `department_id` INT(11)  NOT NULL COMMENT 'Current department' ,
  `division_id` INT(11)  NOT NULL COMMENT 'Current division' ,
  `salary` DECIMAL(12,2) NOT NULL COMMENT 'Current GROSS salary' ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_emp_job_id`
    FOREIGN KEY (`job_id` )
    REFERENCES `hr_schema`.`jobs` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_manager_id`
    FOREIGN KEY (`manager_id` )
    REFERENCES `hr_schema`.`employees` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_department_id`
    FOREIGN KEY (`department_id` )
    REFERENCES `hr_schema`.`departments` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_division_id`
    FOREIGN KEY (`division_id` )
    REFERENCES `hr_schema`.`divisions` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Catalog of company\'s most valuable resource';

SHOW WARNINGS;
CREATE INDEX `idx_emp_first_name` ON `hr_schema`.`employees` (`first_name` ASC) ;

SHOW WARNINGS;
CREATE INDEX `idx_emp_last_name` ON `hr_schema`.`employees` (`last_name` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_emp_job_id` ON `hr_schema`.`employees` (`job_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_emp_manager_id` ON `hr_schema`.`employees` (`manager_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_emp_department_id` ON `hr_schema`.`employees` (`department_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_emp_division_id` ON `hr_schema`.`employees` (`division_id` ASC) ;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `hr_schema`.`job_history`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `hr_schema`.`job_history` (
  `id` INT(11)  NOT NULL ,
  `employee_id` INT(11)  NOT NULL ,
  `start_date` DATE NOT NULL ,
  `end_date` DATE NOT NULL ,
  `job_id` INT(11)  NOT NULL ,
  `manager_id` INT(11)  NOT NULL ,
  `department_id` INT(11)  NOT NULL ,
  `division_id` INT(11)  NOT NULL ,
  `salary` DECIMAL(12,2) NULL COMMENT 'GROSS salary' ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_jobhist_employee_id`
    FOREIGN KEY (`employee_id` )
    REFERENCES `hr_schema`.`employees` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_department_id`
    FOREIGN KEY (`department_id` )
    REFERENCES `hr_schema`.`departments` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_division_id`
    FOREIGN KEY (`division_id` )
    REFERENCES `hr_schema`.`divisions` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_job_id`
    FOREIGN KEY (`job_id` )
    REFERENCES `hr_schema`.`jobs` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_manager_id`
    FOREIGN KEY (`manager_id` )
    REFERENCES `hr_schema`.`employees` (`id` )
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `fk_jobhist_employee_id` ON `hr_schema`.`job_history` (`employee_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_jobhist_department_id` ON `hr_schema`.`job_history` (`department_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_jobhist_division_id` ON `hr_schema`.`job_history` (`division_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_jobhist_job_id` ON `hr_schema`.`job_history` (`job_id` ASC) ;

SHOW WARNINGS;
CREATE INDEX `fk_jobhist_manager_id` ON `hr_schema`.`job_history` (`manager_id` ASC) ;

SHOW WARNINGS;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
