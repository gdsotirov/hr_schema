-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: hr_schema
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `hr_schema`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `hr_schema` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `hr_schema`;

--
-- Table structure for table `absence_totals`
--

DROP TABLE IF EXISTS `absence_totals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `absence_totals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  `division_id` int DEFAULT NULL,
  `days` int NOT NULL,
  `for_year` year NOT NULL,
  `from_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_abstot_type_idx` (`type_id`),
  KEY `fk_abstot_user_idx` (`employee_id`),
  KEY `fk_abstot_division_idx` (`division_id`),
  CONSTRAINT `fk_abstot_division` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_abstot_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_abstot_type` FOREIGN KEY (`type_id`) REFERENCES `absence_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Defines the maximum days per absence type, user or division to be used in a calendar year';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `absence_types`
--

DROP TABLE IF EXISTS `absence_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `absence_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `description` text,
  `days_type` enum('work','cal') DEFAULT NULL COMMENT 'Whether leave should be specified in working or calendar days',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `absences`
--

DROP TABLE IF EXISTS `absences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `absences` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `from_date` datetime NOT NULL,
  `to_date` datetime DEFAULT NULL,
  `type` int NOT NULL,
  `for_year` int DEFAULT NULL COMMENT 'In case of paid leave, for which year is valid',
  `description` text COMMENT 'Additional information about the absence',
  `authorized_by` int NOT NULL,
  `deputy_id` int DEFAULT NULL,
  `status` enum('Requested','Authorized','Unauthorized','Cancelled') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_vacation_date` (`from_date`),
  KEY `fk_absence_employee_idx` (`employee_id`),
  KEY `fk_absence_deputy_idx` (`deputy_id`),
  KEY `fk_absence_type_idx` (`type`),
  KEY `fk_absence_authorized_idx` (`authorized_by`),
  CONSTRAINT `fk_absence_authorized` FOREIGN KEY (`authorized_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_absence_deputy` FOREIGN KEY (`deputy_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_absence_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_absence_type` FOREIGN KEY (`type`) REFERENCES `absence_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Emplooyees vacations registry';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `appraisal_period_types`
--

DROP TABLE IF EXISTS `appraisal_period_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appraisal_period_types` (
  `id` varchar(16) NOT NULL,
  `title` varchar(64) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `appraisal_types`
--

DROP TABLE IF EXISTS `appraisal_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appraisal_types` (
  `id` varchar(16) NOT NULL,
  `title` varchar(64) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `appraisals`
--

DROP TABLE IF EXISTS `appraisals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appraisals` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `period_type` varchar(16) NOT NULL,
  `type` varchar(16) NOT NULL,
  `period_from` date NOT NULL,
  `period_to` date NOT NULL,
  `interview_date` date NOT NULL,
  `appriser` int NOT NULL,
  `overall_eval` decimal(2,1) NOT NULL,
  `document` blob,
  PRIMARY KEY (`id`),
  KEY `idx_appraisal_date` (`interview_date`),
  KEY `fk_appraisal_employee_idx` (`employee_id`),
  KEY `fk_appraisal_appriser_idx` (`appriser`),
  KEY `fk_appraisal_period_type_idx` (`period_type`),
  KEY `fk_appraisal_type_idx` (`type`),
  CONSTRAINT `fk_appraisal_appriser` FOREIGN KEY (`appriser`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appraisal_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appraisal_period_type` FOREIGN KEY (`period_type`) REFERENCES `appraisal_period_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_appraisal_type` FOREIGN KEY (`type`) REFERENCES `appraisal_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Employees appraisls';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bonus_distribution`
--

DROP TABLE IF EXISTS `bonus_distribution`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bonus_distribution` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bonus_id` int NOT NULL,
  `employee_id` int NOT NULL,
  `amount` decimal(12,2) NOT NULL COMMENT 'Amount in GROSS',
  `currency` char(3) DEFAULT 'BGN',
  `granted_on` date NOT NULL,
  `granted_by` int NOT NULL,
  `approved_on` date DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  `details` text,
  PRIMARY KEY (`id`),
  KEY `idx_granted_date` (`granted_on`),
  KEY `idx_approved_date` (`approved_on`),
  KEY `fk_bondtl_employee_idx` (`employee_id`),
  KEY `fk_bondtl_granted_idx` (`granted_by`),
  KEY `fk_bondtl_approved_idx` (`approved_by`),
  KEY `fk_bondtl_bonus_idx` (`bonus_id`),
  KEY `fk_bondtl_currency_idx` (`currency`),
  CONSTRAINT `fk_bondtl_approved` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_bonus` FOREIGN KEY (`bonus_id`) REFERENCES `bonuses` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_currency` FOREIGN KEY (`currency`) REFERENCES `currencies` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bondtl_granted` FOREIGN KEY (`granted_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Bonueses history';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bonuses`
--

DROP TABLE IF EXISTS `bonuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bonuses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `granted_on` date DEFAULT NULL,
  `granted_by` int DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `currency` char(3) DEFAULT 'BGN',
  PRIMARY KEY (`id`),
  KEY `fk_bonuses_granted_idx` (`granted_by`),
  KEY `fk_bonuses_currency_idx` (`currency`),
  CONSTRAINT `fk_bonuses_currency` FOREIGN KEY (`currency`) REFERENCES `currencies` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_bonuses_granted` FOREIGN KEY (`granted_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `comp_balance`
--

DROP TABLE IF EXISTS `comp_balance`;
/*!50001 DROP VIEW IF EXISTS `comp_balance`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `comp_balance` AS SELECT 
 1 AS `Number`,
 1 AS `Name`,
 1 AS `Until`,
 1 AS `HPlus`,
 1 AS `HMinus`,
 1 AS `Balance`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `comp_list`
--

DROP TABLE IF EXISTS `comp_list`;
/*!50001 DROP VIEW IF EXISTS `comp_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `comp_list` AS SELECT 
 1 AS `Name`,
 1 AS `Day`,
 1 AS `Start`,
 1 AS `End`,
 1 AS `Total`,
 1 AS `Projects`,
 1 AS `Tasks`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` int NOT NULL AUTO_INCREMENT,
  `iso_num3` char(3) NOT NULL COMMENT 'ISO 3166-1 numeric 3 code',
  `iso_code2` char(2) NOT NULL COMMENT 'ISO 3166-1 alpha-2 code',
  `iso_code3` char(3) NOT NULL COMMENT 'ISO 3166-1 alpha-3 code',
  `name_en` varchar(64) NOT NULL COMMENT 'English short name',
  `name_fr` varchar(64) NOT NULL COMMENT 'French short name',
  `fullname_en` varchar(128) DEFAULT NULL COMMENT 'English full name',
  `fullname_fr` varchar(128) DEFAULT NULL COMMENT 'French full name',
  `remark_en` varchar(64) DEFAULT NULL,
  `remark_fr` varchar(64) DEFAULT NULL,
  `adm_lang2` char(2) DEFAULT NULL,
  `adm_lang3` char(3) DEFAULT NULL,
  `shortname_local` varchar(64) DEFAULT NULL,
  `un_member_since` date DEFAULT NULL,
  `un_member_until` date DEFAULT NULL,
  `tld` char(3) DEFAULT NULL COMMENT 'Top level domain',
  `calling_code` varchar(10) DEFAULT NULL,
  `region_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_iso_num3` (`iso_num3`),
  UNIQUE KEY `idx_iso_code2` (`iso_code2`),
  UNIQUE KEY `idx_iso_code3` (`iso_code3`),
  UNIQUE KEY `idx_tld` (`tld`),
  KEY `idx_name_en` (`name_en`),
  KEY `fk_ctry_region_idx` (`region_id`),
  CONSTRAINT `fk_ctry_region` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='List of coutries where the company has activities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `curr_rates`
--

DROP TABLE IF EXISTS `curr_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `curr_rates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `from_curr` char(3) NOT NULL,
  `to_curr` char(3) NOT NULL,
  `for_date` date NOT NULL,
  `rate` decimal(10,7) NOT NULL,
  `country` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_curr_rates_country_idx` (`country`),
  KEY `fk_curr_rates_from_curr_idx` (`from_curr`),
  KEY `fk_curr_rates_to_curr_idx` (`to_curr`),
  CONSTRAINT `fk_curr_rates_country` FOREIGN KEY (`country`) REFERENCES `countries` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_curr_rates_from_curr` FOREIGN KEY (`from_curr`) REFERENCES `currencies` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_curr_rates_to_curr` FOREIGN KEY (`to_curr`) REFERENCES `currencies` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Currency conversion rates register';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `currencies`
--

DROP TABLE IF EXISTS `currencies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `currencies` (
  `id` char(3) NOT NULL COMMENT 'ISO code',
  `name` varchar(32) NOT NULL COMMENT 'Currency full name',
  `symbol` varchar(3) NOT NULL COMMENT 'Currency symbol',
  `fraction` varchar(32) DEFAULT NULL COMMENT 'Fractional unit',
  `basis` int DEFAULT NULL COMMENT 'Basic amount or conversion',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Currencies register';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `current_absences`
--

DROP TABLE IF EXISTS `current_absences`;
/*!50001 DROP VIEW IF EXISTS `current_absences`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `current_absences` AS SELECT 
 1 AS `name`,
 1 AS `emp_name`,
 1 AS `job_title`,
 1 AS `abs_type`,
 1 AS `from_date`,
 1 AS `to_date`,
 1 AS `days_left`,
 1 AS `deputy`,
 1 AS `auth_by`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `established` date DEFAULT NULL COMMENT 'Date on which the department was created',
  `closed` date DEFAULT NULL COMMENT 'Date on which the department was closed or disbanded',
  `size` int DEFAULT NULL COMMENT 'Current number of employees working in the department',
  `manager_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_department_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `division_change`
--

DROP TABLE IF EXISTS `division_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `division_change` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `from_date` date NOT NULL,
  `division_id` int NOT NULL,
  `granted_on` date DEFAULT NULL,
  `granted_by` int DEFAULT NULL,
  `approved_on` date DEFAULT NULL,
  `approved_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_div_chng_emp_idx` (`employee_id`),
  KEY `fk_div_chng_div_idx` (`division_id`),
  KEY `fk_div_chng_granted_idx` (`granted_by`),
  KEY `fk_div_chng_approved_idx` (`approved_by`),
  CONSTRAINT `fk_div_chng_approved` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_div_chng_div` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_div_chng_emp` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_div_chng_granted` FOREIGN KEY (`granted_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Employees division change register';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `divisions`
--

DROP TABLE IF EXISTS `divisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `divisions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `established` date DEFAULT NULL COMMENT 'Date on which the division was created',
  `closed` date DEFAULT NULL,
  `size` int DEFAULT NULL COMMENT 'Current number of employees in the division',
  `location_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_division_name` (`name`),
  KEY `fk_division_location_idx` (`location_id`),
  CONSTRAINT `fk_division_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Company''s divisions';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `emp_absences`
--

DROP TABLE IF EXISTS `emp_absences`;
/*!50001 DROP VIEW IF EXISTS `emp_absences`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `emp_absences` AS SELECT 
 1 AS `emp_id`,
 1 AS `emp_name`,
 1 AS `abs_type`,
 1 AS `from_date`,
 1 AS `to_date`,
 1 AS `for_year`,
 1 AS `dur_days`,
 1 AS `deputy`,
 1 AS `auth_by`,
 1 AS `status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `emp_fullname`
--

DROP TABLE IF EXISTS `emp_fullname`;
/*!50001 DROP VIEW IF EXISTS `emp_fullname`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `emp_fullname` AS SELECT 
 1 AS `full_name`,
 1 AS `emp_id`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `emp_history`
--

DROP TABLE IF EXISTS `emp_history`;
/*!50001 DROP VIEW IF EXISTS `emp_history`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `emp_history` AS SELECT 
 1 AS `emp_id`,
 1 AS `name`,
 1 AS `date`,
 1 AS `type`,
 1 AS `what`,
 1 AS `detail`,
 1 AS `status`,
 1 AS `who`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `emp_resigned`
--

DROP TABLE IF EXISTS `emp_resigned`;
/*!50001 DROP VIEW IF EXISTS `emp_resigned`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `emp_resigned` AS SELECT 
 1 AS `fullname`,
 1 AS `last_position`,
 1 AS `last_department`,
 1 AS `last_division`,
 1 AS `hired`,
 1 AS `resigned`,
 1 AS `reason`,
 1 AS `service_length`,
 1 AS `age_at_leave`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `emp_summary`
--

DROP TABLE IF EXISTS `emp_summary`;
/*!50001 DROP VIEW IF EXISTS `emp_summary`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `emp_summary` AS SELECT 
 1 AS `fullname`,
 1 AS `position`,
 1 AS `contracted`,
 1 AS `hired`,
 1 AS `service_length`,
 1 AS `age`,
 1 AS `last_job_change`,
 1 AS `last_sal_change`,
 1 AS `salary`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `contract_date` date NOT NULL COMMENT 'Date when contract was signed',
  `hire_date` date NOT NULL COMMENT 'Date from which the employee started work',
  `trial_period` int DEFAULT NULL COMMENT 'Trial Periods in months',
  `leave_date` date DEFAULT NULL COMMENT 'Date on which the employee left company',
  `leave_reason` text COMMENT 'Reason for leave',
  `job_id` int NOT NULL COMMENT 'Current job',
  `manager_id` int DEFAULT NULL COMMENT 'Current manager',
  `department_id` int DEFAULT NULL COMMENT 'Current department',
  `division_id` int NOT NULL COMMENT 'Current division',
  `salary` decimal(14,3) DEFAULT NULL COMMENT 'Current GROSS salary',
  `currency` char(3) DEFAULT NULL,
  `newcomer_issue_id` varchar(16) DEFAULT NULL COMMENT 'Related newcomer issue identifier (TTS key)',
  PRIMARY KEY (`id`),
  KEY `fk_emp_job_id_idx` (`job_id`),
  KEY `fk_emp_manager_id_idx` (`manager_id`),
  KEY `fk_emp_department_id_idx` (`department_id`),
  KEY `fk_emp_division_id_idx` (`division_id`),
  KEY `fk_emp_person_id_idx` (`person_id`),
  KEY `fk_emp_currency_idx` (`currency`),
  CONSTRAINT `fk_emp_currency` FOREIGN KEY (`currency`) REFERENCES `currencies` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_department_id` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_division_id` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_manager_id` FOREIGN KEY (`manager_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_emp_person_id` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Catalog of company''s most valuable resource';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `employee_add` AFTER INSERT ON `employees` FOR EACH ROW BEGIN
  UPDATE departments
     SET size = CASE
                  WHEN size IS NULL THEN 0
                  ELSE size
                END + 1
   WHERE id = NEW.department_id;

  UPDATE divisions
     SET size = CASE
                  WHEN size IS NULL THEN 0
                  ELSE size
                END + 1
   WHERE id = NEW.division_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `employee_change` AFTER UPDATE ON `employees` FOR EACH ROW BEGIN
  IF OLD.department_id != NEW.department_id THEN
    UPDATE departments
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END - 1
     WHERE id = OLD.department_id;

    UPDATE departments
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END + 1
     WHERE id = NEW.department_id;
  END IF;

  IF OLD.division_id != NEW.division_id THEN
    UPDATE divisions
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END - 1
     WHERE id = OLD.division_id;

    UPDATE divisions
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END + 1
     WHERE id = NEW.division_id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `job_candidates`
--

DROP TABLE IF EXISTS `job_candidates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_candidates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `person_id` int NOT NULL,
  `cv_doc` blob COMMENT 'Curriculum Vitae document',
  `cl_doc` blob COMMENT 'Cover Letter document',
  `job_id` int NOT NULL,
  `first_interview` date NOT NULL,
  `second_interview` date DEFAULT NULL,
  `third_interview` date DEFAULT NULL,
  `status` enum('Approved','Rejected','Pending') DEFAULT NULL,
  `employee_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_candidate_interviewed` (`first_interview`),
  KEY `fk_candidate_employee_idx` (`employee_id`),
  KEY `fk_candidate_job_idx` (`job_id`),
  KEY `fk_candidate_person_idx` (`person_id`),
  CONSTRAINT `fk_candidate_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_candidate_job` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_candidate_person` FOREIGN KEY (`person_id`) REFERENCES `persons` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Catalog of job candidates';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_history`
--

DROP TABLE IF EXISTS `job_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `from_date` date NOT NULL,
  `job_id` int NOT NULL,
  `granted_on` date DEFAULT NULL,
  `granted_by` int NOT NULL,
  `approved_on` date DEFAULT NULL,
  `approved_by` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_jobhist_employee_idx` (`employee_id`),
  KEY `fk_jobhist_job_idx` (`job_id`),
  KEY `fk_jobhist_approved_idx` (`approved_by`),
  KEY `fk_jobhist_granted_idx` (`granted_by`),
  CONSTRAINT `fk_jobhist_approved` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_granted` FOREIGN KEY (`granted_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_jobhist_job` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `job_offers`
--

DROP TABLE IF EXISTS `job_offers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_offers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `description` blob NOT NULL,
  `job_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_job_offer_job_id_idx` (`job_id`),
  CONSTRAINT `fk_job_offer_job_id` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  `description` blob,
  `min_salary` decimal(12,2) DEFAULT NULL,
  `max_salary` decimal(12,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_job_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='List of jobs within the company';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `leaves_plan`
--

DROP TABLE IF EXISTS `leaves_plan`;
/*!50001 DROP VIEW IF EXISTS `leaves_plan`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `leaves_plan` AS SELECT 
 1 AS `emp_name`,
 1 AS `for_year`,
 1 AS `MONTH(AB.from_date)`,
 1 AS `from_date`,
 1 AS `to_date`,
 1 AS `dur_days`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `country_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_location_name` (`name`),
  KEY `fk_loc_country_idx` (`country_id`),
  CONSTRAINT `fk_loc_country` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Locations of companys offices, wharehouses, etc.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `memos`
--

DROP TABLE IF EXISTS `memos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `memos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL COMMENT 'Related employee',
  `comment` text NOT NULL,
  `from_date` date NOT NULL COMMENT 'Associative date',
  `type` enum('Behaviour','Casus','Problem','Etics','Personal','Note') NOT NULL COMMENT 'Defines the main subject of the memo',
  `written_by` int NOT NULL COMMENT 'The author of the memo/note',
  PRIMARY KEY (`id`),
  KEY `idx_memo_from` (`from_date`),
  KEY `fk_memo_employee_idx` (`employee_id`),
  KEY `fk_memo_written_idx` (`written_by`),
  CONSTRAINT `fk_memo_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_memo_written` FOREIGN KEY (`written_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Notes on employees behviour, attitude, problematics, etc.';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `pending_absences`
--

DROP TABLE IF EXISTS `pending_absences`;
/*!50001 DROP VIEW IF EXISTS `pending_absences`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `pending_absences` AS SELECT 
 1 AS `name`,
 1 AS `emp_name`,
 1 AS `job_title`,
 1 AS `abs_type`,
 1 AS `from_date`,
 1 AS `to_date`,
 1 AS `dur_days`,
 1 AS `deputy`,
 1 AS `auth_by`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `per_relations_list`
--

DROP TABLE IF EXISTS `per_relations_list`;
/*!50001 DROP VIEW IF EXISTS `per_relations_list`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `per_relations_list` AS SELECT 
 1 AS `p1_name`,
 1 AS `relation`,
 1 AS `p2_name`,
 1 AS `since`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `person_relation_types`
--

DROP TABLE IF EXISTS `person_relation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_relation_types` (
  `id` varchar(16) NOT NULL,
  `title` varchar(64) NOT NULL,
  `reverse_id` varchar(16) DEFAULT NULL COMMENT 'Used to define the reverse relation',
  PRIMARY KEY (`id`),
  UNIQUE KEY `fk_prel_type_rev_idx` (`id`),
  CONSTRAINT `fk_prel_type_rev` FOREIGN KEY (`id`) REFERENCES `person_relation_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_relations`
--

DROP TABLE IF EXISTS `person_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_relations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `person1` int NOT NULL,
  `type` varchar(16) NOT NULL,
  `person2` int NOT NULL,
  `from_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_prel_person1_idx` (`person1`),
  KEY `fk_prel_type_idx` (`type`),
  KEY `fk_prel_person2_idx` (`person2`),
  CONSTRAINT `fk_prel_person1` FOREIGN KEY (`person1`) REFERENCES `persons` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_prel_person2` FOREIGN KEY (`person2`) REFERENCES `persons` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_prel_type` FOREIGN KEY (`type`) REFERENCES `person_relation_types` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `persons`
--

DROP TABLE IF EXISTS `persons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `persons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(64) NOT NULL,
  `middle_name` varchar(64) DEFAULT NULL,
  `maiden_name` varchar(32) DEFAULT NULL,
  `last_name` varchar(64) NOT NULL,
  `sex` enum('Male','Female') NOT NULL,
  `birth_date` date DEFAULT NULL,
  `death_date` date DEFAULT NULL,
  `picture` blob,
  `martial_status` enum('Single','Married','Cohabitation','Divorced','Widowed','Separated') DEFAULT NULL,
  `children` decimal(2,0) DEFAULT NULL,
  `personal_id` varchar(32) DEFAULT NULL,
  `short_bio` text,
  `cv_doc` longblob,
  `linkedin_profile` varchar(256) DEFAULT NULL COMMENT 'URL to LinkedIn profile',
  `prior_internship_yrs` int DEFAULT NULL COMMENT 'Prior internship in years',
  `prior_internship_mns` int DEFAULT NULL COMMENT 'Prior internship in months',
  `prior_internship_dys` int DEFAULT NULL COMMENT 'Prior internship in days',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_person_names` (`first_name`,`middle_name`,`last_name`),
  KEY `idx_person_bd` (`birth_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_reg_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='List of country regions where the company has activities';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `requested_absences`
--

DROP TABLE IF EXISTS `requested_absences`;
/*!50001 DROP VIEW IF EXISTS `requested_absences`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `requested_absences` AS SELECT 
 1 AS `name`,
 1 AS `emp_name`,
 1 AS `job_title`,
 1 AS `abs_type`,
 1 AS `from_date`,
 1 AS `to_date`,
 1 AS `dur_days`,
 1 AS `deputy`,
 1 AS `auth_by`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `sal_history`
--

DROP TABLE IF EXISTS `sal_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sal_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `from_date` date NOT NULL,
  `amount` decimal(14,3) NOT NULL,
  `currency` char(3) DEFAULT NULL,
  `granted_on` date DEFAULT NULL,
  `granted_by` int NOT NULL,
  `approved_on` date DEFAULT NULL,
  `approved_by` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_salhist_employee_idx` (`employee_id`),
  KEY `fk_salhist_approved_idx` (`approved_by`),
  KEY `fk_salhist_granted_idx` (`granted_by`),
  KEY `fk_salhist_currency_idx` (`currency`),
  CONSTRAINT `fk_salhist_approved` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_salhist_currency` FOREIGN KEY (`currency`) REFERENCES `currencies` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_salhist_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_salhist_granted` FOREIGN KEY (`granted_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `team_change`
--

DROP TABLE IF EXISTS `team_change`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team_change` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `from_date` date NOT NULL,
  `department` int NOT NULL,
  `granted_on` date DEFAULT NULL,
  `granted_by` int NOT NULL,
  `approved_on` date DEFAULT NULL,
  `approved_by` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_tmchng_employee_idx` (`employee_id`),
  KEY `fk_tmchng_department_idx` (`department`),
  KEY `fk_tmchng_granted_idx` (`granted_by`),
  KEY `fk_tmchng_approved_idx` (`approved_by`),
  CONSTRAINT `fk_tmchng_approved` FOREIGN KEY (`approved_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_tmchng_department` FOREIGN KEY (`department`) REFERENCES `departments` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_tmchng_employee` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_tmchng_granted` FOREIGN KEY (`granted_by`) REFERENCES `employees` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'hr_schema'
--

--
-- Dumping routines for database 'hr_schema'
--
/*!50003 DROP FUNCTION IF EXISTS `caclSnrtyAmt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `caclSnrtyAmt`(nSalary DECIMAL(14,2), nSnrtyYrs INT) RETURNS decimal(14,2)
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE nSnrtyPrcnt DECIMAL(3,1) DEFAULT calcSnrtyPrcnt(nSnrtyYrs);
  DECLARE nSnrtyAmt DECIMAL(14,2) DEFAULT nSalary * nSnrtyPrcnt/100;

  RETURN nSnrtyAmt;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calcNetSalaryBG` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calcNetSalaryBG`(dBaseSalary     DECIMAL(10,2),
                                dSeniorityYears DECIMAL(2)) RETURNS decimal(10,2)
    NO SQL
    DETERMINISTIC
BEGIN
  RETURN calcNetSalaryBGForYear(dBaseSalary, IFNULL(dSeniorityYears, 0), YEAR(NOW()));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calcNetSalaryBGForYear` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calcNetSalaryBGForYear`(dBaseSalary      DECIMAL(10,2),
                                       dSeniorityYears  DECIMAL(2),
                                       yForYear         YEAR) RETURNS decimal(10,2)
    NO SQL
    DETERMINISTIC
BEGIN
  /* Maximal Social Insurance Income */
  DECLARE dMaxInsInc  DECIMAL(10,2) DEFAULT 4130 /* 2025 onwards */;
  /* Percent for State Public Insurance */
  DECLARE dPubInsPerc DECIMAL(3,2)  DEFAULT 2.2  /* 2009 onwards */;
  /* Percent for Additional Mandatory Pension Insurance */
  DECLARE dAMPInsPerc DECIMAL(4,2)  DEFAULT 8.38 /* 2018 onwards */;
  /* Percent for Health Insurance */
  DECLARE dHlthInPerc DECIMAL(3,2)  DEFAULT 3.2  /* 2009 onwards */;

  DECLARE dInsAmt         DECIMAL(10,2) DEFAULT dBaseSalary;
  DECLARE dSeniorityAmt   DECIMAL(10,2);
  DECLARE dGrossSalary    DECIMAL(10,2) DEFAULT dBaseSalary;
  DECLARE dSPIAmt         DECIMAL(10,2);
  DECLARE dAMPIAmt        DECIMAL(10,2);
  DECLARE dHIAmt          DECIMAL(10,2);
  DECLARE dTaxableAmt     DECIMAL(10,2);
  DECLARE dIncomeTax      DECIMAL(10,2);
  DECLARE dNetSalary      DECIMAL(10,2);

  /* Determine Maximal Social Insurance Income per year */
  CASE
    WHEN yForYear BETWEEN 2010 AND 2012 THEN
      SET dMaxInsInc = 2000;
    WHEN yForYear = 2013 THEN
      SET dMaxInsInc = 2200;
    WHEN yForYear = 2014 THEN
      SET dMaxInsInc = 2400;
    WHEN yForYear BETWEEN 2015 AND 2018 THEN
      SET dMaxInsInc = 2600;
    WHEN yForYear BETWEEN 2019 AND 2021 THEN
      SET dMaxInsInc = 3000;
    WHEN yForYear BETWEEN 2022 AND 2023 THEN
      SET dMaxInsInc = 3400;
    WHEN yForYear = 2024 THEN
      SET dMaxInsInc = 3750;
    WHEN yForYear = 2025 THEN
      SET dMaxInsInc = 4130;
    WHEN yForYear = 2026 THEN
      SET dMaxInsInc = 4430;
    WHEN yForYear = 2027 THEN
      SET dMaxInsInc = 4730;
    WHEN yForYear >= 2028 THEN
      SET dMaxInsInc = 5030;
  END CASE;

  CASE
    WHEN yForYear = 2009 THEN
      SET dAMPInsPerc = 7.6; /* pension - 5.8, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear = 2010 THEN
      SET dAMPInsPerc = 6.7; /* pension - 4.9, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear BETWEEN 2011 AND 2016 THEN
      SET dAMPInsPerc = 7.5; /* pension - 5.7, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear = 2017 THEN
      SET dAMPInsPerc = 7.94; /* pension - 6.14, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear BETWEEN 2018 AND 2025 THEN
      SET dAMPInsPerc = 8.38; /* pension - 6.58, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear = 2026 THEN
      SET dAMPInsPerc = 9.71; /* pension - 7.91, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear >= 2027 THEN
      SET dAMPInsPerc = 10.6; /* pension - 8.80, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
  END CASE;

  /* Calculate and add seniority to gross salary */
  IF dSeniorityYears > 0 THEN
    SET dSeniorityAmt   = ROUND(dBaseSalary * calcSnrtyPrcnt(IFNULL(dSeniorityYears, 0)) / 100, 2);
    SET dGrossSalary    = dGrossSalary + dSeniorityAmt;
  END IF;

  /* Determine the base */
  IF dBaseSalary > dMaxInsInc THEN
    SET dInsAmt = dMaxInsInc;
  END IF;

  /* Calculate State Public Insurance */
  SET dSPIAmt  = ROUND(dInsAmt * dPubInsPerc / 100, 2);

  /* Calculate Additional Mandatory Pension Insurance */
  SET dAMPIAmt = ROUND(dInsAmt * dAMPInsPerc / 100, 2);

  /* Calculate Health Insurance */
  SET dHIAmt   = ROUND(dInsAmt * dHlthInPerc / 100, 2);

  /* Calculate Taxable Amount */
  SET dTaxableAmt = ROUND(dGrossSalary - dSPIAmt - dAMPIAmt - dHIAmt, 2);

  /* Calculate Income Tax *
  CASE
    WHEN dTaxableAmt < 180.0 THEN
      SET dIncomeTax = 0.0;
    WHEN dTaxableAmt >= 180.0 AND dTaxableAmt < 250.0 THEN
      SET dIncomeTax = ROUND((dTaxableAmt - 180.0) * 20 / 100, 1);
    WHEN dTaxableAmt >= 250.0 AND dTaxableAmt < 600.0 THEN
      SET dIncomeTax = ROUND((dTaxableAmt - 250.0) * 22 / 100, 1)
                        + ROUND((250 - 180) * 20 / 100, 1);
    WHEN dTaxableAmt > 600.0 THEN
      SET dIncomeTax = ROUND((dTaxableAmt - 600.0) * 24 / 100, 1)
                        + ROUND((600 - 250) * 22 / 100, 1)
                        + ROUND((250 - 180) * 20 / 100, 1);
  END CASE;*/
  /* Flat Total Income Tax of 10% */
  SET dIncomeTax = ROUND(dTaxableAmt * 10 / 100, 2);

  /* Calculate Net Salary */
  SET dNetSalary = ROUND(dTaxableAmt - dIncomeTax, 2);

  RETURN dNetSalary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calcNetSalaryTN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calcNetSalaryTN`(dGrossSalary DECIMAL) RETURNS decimal(10,2)
    NO SQL
    DETERMINISTIC
BEGIN
  /* See http://taxsummaries.pwc.com/uk/taxsummaries/wwts.nsf/ID/Tunisia-Individual-Income-determination */
  /* See http://taxsummaries.pwc.com/uk/taxsummaries/wwts.nsf/ID/Tunisia-Individual-Taxes-on-personal-income */
  DECLARE dAnnGrossSal  DECIMAL(10,2);
  DECLARE dAnnSocSec    DECIMAL(10,2);
  DECLARE dMthSocSec    DECIMAL(10,2);
  DECLARE dAnnProfExp   DECIMAL(10,2);
  DECLARE dAnnTaxSal    DECIMAL(10,2);
  DECLARE dAnnTaxAmt    DECIMAL(10,2) DEFAULT 0;
  DECLARE dMthTaxAmt    DECIMAL(10,2);
  DECLARE dMthNetSalary DECIMAL(10,2);

  /* Calcualte annual gross salary */
  SET dAnnGrossSal = dGrossSalary * 12;
  /* Calcualte annual and monthly social contributions */
  SET dAnnSocSec = ROUND(dAnnGrossSal * 9.18 / 100, 2);
  SET dMthSocSec = ROUND(dAnnSocSec / 12, 2);
  /* Calcaulte annual professional expenses */
  SET dAnnProfExp = ROUND((dAnnGrossSal - dAnnSocSec) * 10 / 100, 2);
  /* Calcualte taxable salary amount by deducting annul social contributions and annual professional expenses */
  SET dAnnTaxSal = ROUND(dAnnGrossSal - dAnnSocSec - dAnnProfExp - 150 - 90 - 75, 2);

  /* Apply progressive personal income scale */
  IF dAnnTaxSal <= 1500 THEN
    SET dAnnTaxAmt = 0;
    SET dMthTaxAmt = 0;
  ELSE
    IF dAnnTaxSal <= 5000 THEN
      SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 1500) * 15 / 100, 2);
    ELSE
      SET dAnnTaxAmt = dAnnTaxAmt + ROUND((5000 - 1500) * 15 / 100, 2);

      IF dAnnTaxSal <= 10000 THEN
        SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 5000) * 20 / 100, 2);
      ELSE
        SET dAnnTaxAmt = dAnnTaxAmt + ROUND((10000 - 5000) * 20 / 100, 2);

        IF dAnnTaxSal <= 20000 THEN
          SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 10000) * 25 / 100, 2);
        ELSE
          SET dAnnTaxAmt = dAnnTaxAmt + ROUND((20000 - 10000) * 25 / 100, 2);

          IF dAnnTaxSal <= 50000 THEN
            SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 20000) * 30 / 100, 2);
          ELSE
            SET dAnnTaxAmt = dAnnTaxAmt + ROUND((50000 - 20000) * 30 / 100, 2);
            SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 50000) * 35 / 100, 2);
          END IF;
        END IF;
      END IF;
    END IF;

    /* Calcualte monthly income tax */
    SET dMthTaxAmt = ROUND(dAnnTaxAmt / 12, 2);
  END IF;

  /* Calcualte Net Salary */
  SET dMthNetSalary = dGrossSalary - dMthSocSec - dMthTaxAmt;

  RETURN dMthNetSalary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calcNetSalaryVN` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calcNetSalaryVN`(dGrossSalary DECIMAL) RETURNS decimal(10,2)
    NO SQL
    DETERMINISTIC
BEGIN
  /* See http://nicvn.com/net-gross-salary-converter.html */
  /* See https://www.hr2b.com/salary-calculator */
  DECLARE dSocIns    DECIMAL(10,2);
  DECLARE dHlthIns   DECIMAL(10,2);
  DECLARE dUnEmplIns DECIMAL(10,2);
  DECLARE dTrdeUn    DECIMAL(10,2);
  DECLARE dNetSalary DECIMAL(10,2);

  SET dSocIns    = dGrossSalary * 8 / 100;
  SET dHlthIns   = dGrossSalary * 1.5 / 100;
  SET dUnEmplIns = dGrossSalary * 1 / 100;
  SET dTrdeUn    = dGrossSalary * 1 / 100;

  SET dNetSalary = dGrossSalary - dSocIns - dHlthIns - dUnEmplIns - dTrdeUn;

  RETURN dNetSalary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `calcSnrtyPrcnt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `calcSnrtyPrcnt`(yrs INT) RETURNS decimal(3,1)
    NO SQL
    DETERMINISTIC
BEGIN
  RETURN yrs * 0.6;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `curr_conversion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `curr_conversion`(amount      DECIMAL(30,10),
                                currency    CHAR(3),
                                to_currency CHAR(3),
                                date_for    DATE) RETURNS decimal(30,10)
    READS SQL DATA
BEGIN
  DECLARE conv_rate DECIMAL(10,6)  DEFAULT NULL;
  DECLARE err_msg   VARCHAR(128)   DEFAULT NULL;
  DECLARE result    DECIMAL(30,10) DEFAULT NULL;

  IF date_for IS NULL THEN
    SET date_for := NOW();
  END IF;

  IF currency <> to_currency THEN
    SELECT rate
      INTO conv_rate
      FROM curr_rates
     WHERE from_curr = currency
       AND to_curr = to_currency
       AND for_date <= date_for
     ORDER BY for_date DESC
     LIMIT 1;

    IF conv_rate IS NULL THEN
      SET err_msg := CONCAT('No conversion rate for ', currency, ' to ', to_currency, ' for ', DATE_FORMAT(date_for, '%Y-%m-%d'));
      SIGNAL SQLSTATE '99001' SET MESSAGE_TEXT = err_msg;
    END IF;

    SET result := amount * conv_rate;
  ELSE
    SET result := amount; /* conversion rate is 1 */
  END IF;

  RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `emp_calcSnrtyYrs` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `emp_calcSnrtyYrs`(EmpID INT) RETURNS int
    DETERMINISTIC
BEGIN
  DECLARE iTotalYrs INT DEFAULT 0;
  DECLARE iTotalMns INT DEFAULT 0;
  DECLARE iTotalDys INT DEFAULT 0;

  CALL emp_calcTotalSnrty(EmpID, iTotalYrs, iTotalMns, iTotalDys);

  RETURN iTotalYrs;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `emp_getFullName` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `emp_getFullName`(EmpID INTEGER) RETURNS varchar(256) CHARSET utf8mb3
    READS SQL DATA
BEGIN
  DECLARE vcResult   VARCHAR(256) DEFAULT NULL;
  DECLARE vcFrstName VARCHAR(64) DEFAULT NULL;
  DECLARE vcMdleName VARCHAR(64) DEFAULT NULL;
  DECLARE vcMaidName VARCHAR(32) DEFAULT NULL;
  DECLARE vcLastName VARCHAR(64) DEFAULT NULL;
  DECLARE dEmpLeaveDate DATE DEFAULT NULL;

  SELECT PER.first_name,
         PER.middle_name,
         PER.maiden_name,
         PER.last_name,
         EMP.leave_date
    INTO vcFrstName,
         vcMdleName,
         vcMaidName,
         vcLastName,
         dEmpLeaveDate
    FROM employees EMP,
         persons   PER
   WHERE EMP.id = EmpID
     AND EMP.person_id = PER.id;

  IF vcMaidName IS NOT NULL THEN
    SET vcLastName := CONCAT(vcMaidName, '-', vcLastName);
  END IF;

  IF vcMdleName IS NOT NULL THEN
    SET vcResult := CONCAT(vcLastName, ', ', vcFrstName, ' ', vcMdleName);
  ELSE
    SET vcResult := CONCAT(vcLastName, ', ', vcFrstName);
  END IF;

  IF dEmpLeaveDate IS NOT NULL THEN
    SET vcResult := CONCAT(vcResult, ' (until ', DATE_FORMAT(dEmpLeaveDate, '%Y-%m-%d'), ')');
  END IF;

  RETURN vcResult;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `emp_getServiceLength` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `emp_getServiceLength`(EmpID INTEGER) RETURNS varchar(20) CHARSET utf8mb3
    READS SQL DATA
BEGIN
  DECLARE vcResult VARCHAR(20) DEFAULT NULL;
  DECLARE dEmpHireDate DATE DEFAULT NULL;
  DECLARE dEmpLeaveDate DATE DEFAULT NULL;

  SELECT hire_date,
         CASE
           WHEN leave_date IS NULL THEN CURDATE()
           ELSE leave_date
         END
    INTO dEmpHireDate,
         dEmpLeaveDate
    FROM employees
   WHERE ID = EmpID;

  SET vcResult := utl_getDateDiffStr(dEmpHireDate, dEmpLeaveDate);

  RETURN vcResult;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `emp_getTimeCurPosition` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `emp_getTimeCurPosition`(EmpID INTEGER) RETURNS varchar(20) CHARSET utf8mb3
    READS SQL DATA
BEGIN
  DECLARE vcResult VARCHAR(20) DEFAULT NULL;
  DECLARE dEmpLeaveDate DATE DEFAULT NULL;
  DECLARE dLastPosFromDate DATE DEFAULT NULL;
  DECLARE dLastPosToDate DATE DEFAULT NULL;

  SELECT EMP.leave_date,
         JH.from_date
    INTO dEmpLeaveDate,
         dLastPosFromDate
    FROM employees   EMP
         LEFT OUTER JOIN job_history JH  ON JH.employee_id = EMP.id
                                        AND JH.job_id = EMP.job_id
                                        AND JH.from_date = (SELECT MAX(from_date)
                                                              FROM job_history
                                                             WHERE employee_id = EMP.id
                                                               AND job_id      = EMP.job_id
                                                           )
   WHERE EMP.id = EmpID;

  IF dLastPosFromDate IS NULL THEN
    SET vcResult := 'n/a';
  ELSE
    IF dEmpLeaveDate IS NULL THEN
      SET dLastPosToDate := CURDATE();
    ELSE
      SET dLastPosToDate := dEmpLeaveDate;
    END IF;

    SET vcResult := utl_getDateDiffStr(dLastPosFromDate, dLastPosToDate);
  END IF;

  RETURN vcResult;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getPositionEndDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getPositionEndDate`(iEmpID INTEGER,
                                   iJobID INTEGER) RETURNS date
    READS SQL DATA
BEGIN
  DECLARE dLeaveDate DATE DEFAULT NULL;
  DECLARE dEndDate   DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iJobID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of job change */
  SELECT MIN(from_date)
    INTO dEndDate
    FROM job_history JH
   WHERE employee_id = iEmpID
     AND job_id      <> iJobID
     AND from_date >= (SELECT MAX(from_date)
                         FROM job_history
                        WHERE employee_id = JH.employee_id
                          AND job_id      = iJobID);

  /* if no date of team change */
  IF dEndDate IS NULL THEN
    /* select hire date, but only if current job is the same */
    SELECT leave_date
      INTO dLeaveDate
      FROM employees
     WHERE id     = iEmpID
       AND job_id = iJobID;

    /* if hire date found presume it as team join date */
    IF dLeaveDate IS NOT NULL THEN
      SET dEndDate = dLeaveDate;
    END IF;
  END IF;

  RETURN dEndDate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getPositionStartDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getPositionStartDate`(iEmpID INTEGER,
                                     iJobID INTEGER) RETURNS date
    READS SQL DATA
BEGIN
  DECLARE dHireDate  DATE DEFAULT NULL;
  DECLARE dStartDate DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iJobID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of job change */
  SELECT MAX(from_date)
    INTO dStartDate
    FROM job_history
   WHERE employee_id = iEmpID
     AND job_id      = iJobID;

  /* if no date of team change */
  IF dStartDate IS NULL THEN
    /* select hire date, but only if current job is the same */
    SELECT hire_date
      INTO dHireDate
      FROM employees
     WHERE id = iEmpID
       AND job_id = iJobID;

    /* if hire date found presume it as job start date */
    IF dHireDate IS NOT NULL THEN
      SET dStartDate = dHireDate;
    END IF;
  END IF;

  RETURN dStartDate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getTeamExitDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTeamExitDate`(iEmpID INTEGER,
                                iDepID INTEGER) RETURNS date
    READS SQL DATA
BEGIN
  DECLARE dLeaveDate DATE DEFAULT NULL;
  DECLARE dExitDate  DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iDepID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of team change */
  SELECT MIN(from_date)
    INTO dExitDate
    FROM team_change TE
   WHERE employee_id = iEmpID
     AND department <> iDepID
     AND from_date >= (SELECT MAX(from_date)
                         FROM team_change
                        WHERE employee_id = TE.employee_id
                          AND department = iDepID);

  /* if no date of team change */
  IF dExitDate IS NULL THEN
    /* select leave date, but only if current team is the same */
    SELECT leave_date
      INTO dLeaveDate
      FROM employees
     WHERE id = iEmpID
       AND department_id = iDepID;

	/* if leave date found presume it as team exit date */
	IF dLeaveDate IS NOT NULL THEN
      SET dExitDate = dLeaveDate;
    END IF;
  END IF;

  RETURN dExitDate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `getTeamJoinDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `getTeamJoinDate`(iEmpID INTEGER,
                                iDepID INTEGER) RETURNS date
    READS SQL DATA
BEGIN
  DECLARE dHireDate DATE DEFAULT NULL;
  DECLARE dJoinDate DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iDepID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of team change */
  SELECT MAX(from_date)
    INTO dJoinDate
    FROM team_change
   WHERE employee_id = iEmpID
     AND department = iDepID;

  /* if no date of team change */
  IF dJoinDate IS NULL THEN
    /* select hire date, but only if current team is the same */
    SELECT hire_date
      INTO dHireDate
      FROM employees
     WHERE id = iEmpID
       AND department_id = iDepID;

	/* if hire date found presume it as team join date */
	IF dHireDate IS NOT NULL THEN
      SET dJoinDate = dHireDate;
    END IF;
  END IF;

  RETURN dJoinDate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `utl_calcVacDays` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `utl_calcVacDays`(dStartDate DATETIME, dEndDate DATETIME) RETURNS decimal(5,1)
    NO SQL
BEGIN
  DECLARE tInterval  TIME DEFAULT NULL;

  /* Whole days */
  IF DATE_FORMAT(dStartDate, '%H:%i') = '00:00'
     AND DATE_FORMAT(dEndDate, '%H:%i') = '00:00'
  THEN
    RETURN DATEDIFF(dEndDate, dStartDate) + 1;
  END IF;

  /* half day */
  IF DATE_FORMAT(dStartDate, '%H:%i') != '00:00'
     AND DATE_FORMAT(dEndDate, '%H:%i') != '00:00'
     AND DATEDIFF(dEndDate, dStartDate) = 0
  THEN
    SET tInterval := TIMEDIFF(dEndDate, dStartDate);
    IF TIME_FORMAT(tInterval, '%H:%i') = '04:00' THEN
      RETURN 0.5;
    ELSE
      RETURN NULL;
    END IF;
  END IF;

  RETURN NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `utl_calcVacDaysId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `utl_calcVacDaysId`(VacId INTEGER) RETURNS decimal(5,1)
    READS SQL DATA
BEGIN
  DECLARE dStartDate DATETIME DEFAULT NULL;
  DECLARE dEndDate   DATETIME DEFAULT NULL;
  DECLARE tInterval  TIME DEFAULT NULL;

  SELECT from_date,
         to_date
    INTO dStartDate,
         dEndDate
    FROM absences
   WHERE id = VacId;

  RETURN utl_calcVacDays(dStartDate, dEndDate);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `utl_getDateDiffStr` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `utl_getDateDiffStr`(date1 DATE, date2 DATE) RETURNS varchar(30) CHARSET utf8mb3
    NO SQL
    DETERMINISTIC
BEGIN
  DECLARE years INTEGER;
  DECLARE months INTEGER;
  DECLARE days INTEGER;

  CALL utl_getDateDiff(date1, date2, years, months, days);

  RETURN CONCAT(years, 'y ', months, 'm ', days, 'd');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `emp_calcTotalSnrty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_calcTotalSnrty`(IN EmpID INT, OUT SenYrs INT, OUT SenMns INT, OUT SenDys INT)
    READS SQL DATA
    DETERMINISTIC
BEGIN
  DECLARE dFromDt   DATE;
  DECLARE dToDt     DATE;
  DECLARE iEmpYrs   INT DEFAULT 0;
  DECLARE iEmpMns   INT DEFAULT 0;
  DECLARE iEmpDys   INT DEFAULT 0;
  DECLARE done INT DEFAULT FALSE;
  DECLARE emps_cur CURSOR FOR
  SELECT EMP.hire_date, IFNULL(EMP.leave_date, NOW())
    FROM persons   PER,
         employees EMP
   WHERE EMP.person_id = PER.id
     AND EMP.person_id = (SELECT person_id
                            FROM employees
                           WHERE id = EmpID);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  /* Initialize with prior internship period */
  SELECT IFNULL(prior_internship_yrs, 0), IFNULL(prior_internship_mns, 0), IFNULL(prior_internship_dys, 0)
    INTO SenYrs, SenMns, SenDys
    FROM persons P
   WHERE P.id = (SELECT E.person_id
                   FROM employees E
                  WHERE E.id = EmpID);

  OPEN emps_cur;

  /* A person could have been employee more than once, so loop employees */
  emps_loop: LOOP
    FETCH emps_cur INTO dFromDt, dToDt;

    IF done THEN
      LEAVE emps_loop;
    END IF;

    CALL utl_getDateDiff(dFromDt, dToDt, iEmpYrs, iEmpMns, iEmpDys);

    SET SenDys = SenDys + iEmpDys;
    /* 30 days are considered 1 month */
    IF SenDys > 30 THEN
      SET SenMns = SenMns + 1;
      SET SenDys = SenDys - 30;
    END IF;

    SET SenMns = SenMns + iEmpMns;
    /* 12 months are definitelly a year */
    IF SenMns > 12 THEN
      SET SenYrs = SenYrs + 1;
      SET SenMns = SenMns - 12;
    END IF;

    SET SenYrs = SenYrs + iEmpYrs;
  END LOOP;

  CLOSE emps_cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `emp_transfer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `emp_transfer`(IN iEmpID     INTEGER,
                              IN dBeginDate DATE,
                              IN iJobID     INTEGER,
                              IN iTeamID    INTEGER,
                              IN nSalary    DECIMAL,
                              IN cCurrency  CHAR(3),
                              IN dGrantedOn DATE,
                              IN iGrantedBy INTEGER,
                              IN dApprOn    DATE,
                              IN iApprBy    INTEGER)
    MODIFIES SQL DATA
BEGIN
  DECLARE emp_cnt INTEGER DEFAULT 0;
  DECLARE job_cnt INTEGER DEFAULT 0;
  DECLARE tm_cnt  INTEGER DEFAULT 0;

  SELECT COUNT(*)
    INTO emp_cnt
    FROM employees
   WHERE id = iEmpID;

  IF ( emp_cnt = 0 ) THEN
    SET @msg = CONCAT('Unknown employee with identifier <', iEmpID, '>!');
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = @msg;
  END IF;

  IF dBeginDate IS NULL THEN
    SET dBeginDate := CURDATE();
  END IF;

  /* log into history and than do changes */
  IF iJobID IS NOT NULL THEN
    SELECT COUNT(*)
      INTO job_cnt
      FROM jobs
     WHERE id = iJobID;

    IF ( job_cnt = 0 ) THEN
      SET @msg = CONCAT('Unknown job with identifier <', iJobID, '>!');
      SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = @msg;
    END IF;

    INSERT INTO job_history
      (employee_id, from_date, job_id, granted_on, granted_by, approved_on, approved_by)
    SELECT
      EMP.id, dBeginDate, iJobID, dGrantedOn, iGrantedBy, dApprOn, iApprBy
      FROM employees EMP
     WHERE id = iEmpID
       AND NOT EXISTS (SELECT 1
                         FROM job_history
                        WHERE employee_id = EMP.id
                          AND from_date = dBeginDate
                          AND job_id = iJobID);
  END IF;

  IF iTeamID IS NOT NULL THEN
    SELECT COUNT(*)
      INTO tm_cnt
      FROM departments
     WHERE id = iTeamID;

    IF ( tm_cnt = 0 ) THEN
      SET @msg = CONCAT('Unknown department with identifier <', iJobID, '>!');
      SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = @msg;
    END IF;

    INSERT INTO team_change
      (employee_id, from_date, department, granted_on, granted_by, approved_on, approved_by)
    SELECT
       EMP.id, dBeginDate, iTeamID, dGrantedOn, iGrantedBy, dApprOn, iApprBy
      FROM employees EMP
     WHERE id = iEmpID
       AND NOT EXISTS (SELECT 1
                         FROM team_change
                        WHERE employee_id = EMP.id
                          AND from_date = dBeginDate
                          AND department = iTeamID);
  END IF;

  IF nSalary IS NOT NULL AND cCurrency IS NOT NULL THEN
    INSERT INTO sal_history
      (employee_id, from_date, amount, currency, granted_on, granted_by, approved_on, approved_by)
    SELECT
       EMP.id, dBeginDate, nSalary, cCurrency, dGrantedOn, iGrantedBy, dApprOn, iApprBy
      FROM employees EMP
     WHERE id = iEmpID
       AND NOT EXISTS (SELECT 1
                         FROM sal_history
                        WHERE employee_id = EMP.id
                          AND from_date = dBeginDate
                          AND salary = nSalary);
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `mgmt_promote` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `mgmt_promote`(IN iEmpID INTEGER,
                              IN dBeginDate DATE,
                              IN iNewJobID INTEGER,
                              IN nNewSalary DECIMAL)
    MODIFIES SQL DATA
BEGIN
  IF dBeginDate IS NULL THEN
    SET dBeginDate := CURDATE();
  END IF;

  /* log into history and than do changes */
  IF iNewJobID IS NOT NULL THEN
    INSERT INTO job_history
      (employee_id, from_date, job_id)
    SELECT
       id, dBeginDate, job_id
      FROM employees
     WHERE id = iEmpID;

   UPDATE employees
      SET job_id = iJobID
    WHERE id = iEmpID;
  END IF;

  IF nNewSalary IS NOT NULL THEN
    INSERT INTO sal_history
      (employee_id, from_date, salary)
    SELECT
      id, dBeginDate, salary
      FROM employees
     WHERE id = iEmpID;

    UPDATE employees
       SET salary = nNewSalary
     WHERE id = iEmpID;
  END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `utl_getDateDiff` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `utl_getDateDiff`(IN date1 DATE, IN date2 DATE, OUT yrs INT, OUT mnths INT, OUT dys INT)
    NO SQL
    DETERMINISTIC
BEGIN
  /* Years between */
  SET yrs   := TIMESTAMPDIFF(YEAR, date1, date2);
  /* Months between */
  SET mnths := TIMESTAMPDIFF(MONTH, DATE_ADD(date1, INTERVAL yrs YEAR), date2);
  /* Days between */
  SET dys   := TIMESTAMPDIFF(DAY, DATE_ADD(date1, INTERVAL yrs * 12 + mnths MONTH), date2);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `hr_schema`
--

USE `hr_schema`;

--
-- Final view structure for view `comp_balance`
--

/*!50001 DROP VIEW IF EXISTS `comp_balance`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `comp_balance` AS select `emp`.`id` AS `Number`,concat(`per`.`first_name`,' ',`per`.`last_name`) AS `Name`,date_format(max(`absn`.`from_date`),'%Y-%m') AS `Until`,sec_to_time(sum((case when (`absn`.`from_date` <= `absn`.`to_date`) then time_to_sec(timediff(`absn`.`to_date`,`absn`.`from_date`)) else 0 end))) AS `HPlus`,sec_to_time(sum((case when (`absn`.`from_date` > `absn`.`to_date`) then time_to_sec(timediff(`absn`.`from_date`,`absn`.`to_date`)) else 0 end))) AS `HMinus`,concat('',sec_to_time((sum((case when (`absn`.`from_date` <= `absn`.`to_date`) then time_to_sec(timediff(`absn`.`to_date`,`absn`.`from_date`)) else 0 end)) - sum((case when (`absn`.`from_date` > `absn`.`to_date`) then time_to_sec(timediff(`absn`.`from_date`,`absn`.`to_date`)) else 0 end))))) AS `Balance` from ((`absences` `absn` join `employees` `emp`) join `persons` `per`) where ((`absn`.`type` = 10) and (`emp`.`id` = `absn`.`employee_id`) and (`per`.`id` = `emp`.`person_id`)) group by `Name` order by `Name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `comp_list`
--

/*!50001 DROP VIEW IF EXISTS `comp_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `comp_list` AS select concat(`per`.`first_name`,' ',`per`.`last_name`) AS `Name`,date_format(`ab`.`from_date`,'%d/%m/%Y') AS `Day`,time_format(`ab`.`from_date`,'%H:%i') AS `Start`,time_format(`ab`.`to_date`,'%H:%i') AS `End`,sec_to_time(time_to_sec(timediff(`ab`.`to_date`,`ab`.`from_date`))) AS `Total`,(case when (`ab`.`description` like 'Proj%') then replace(substr(`ab`.`description`,1,(locate(';',`ab`.`description`) - 1)),'Projects: ','') when (`ab`.`description` like 'Offline%') then ltrim(substr(`ab`.`description`,(locate(':',`ab`.`description`) + 1))) else `ab`.`description` end) AS `Projects`,(case when (`ab`.`description` like 'Proj%') then ltrim(replace(substr(`ab`.`description`,(locate(';',`ab`.`description`) + 1)),'Tasks: ','')) when (`ab`.`description` like 'Offline%') then '' else `ab`.`description` end) AS `Tasks` from ((`absences` `ab` join `employees` `emp`) join `persons` `per`) where ((`ab`.`employee_id` = `emp`.`id`) and (`emp`.`person_id` = `per`.`id`) and (`ab`.`type` = 10)) order by `ab`.`from_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `current_absences`
--

/*!50001 DROP VIEW IF EXISTS `current_absences`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `current_absences` AS select `dep`.`name` AS `name`,`eab`.`emp_name` AS `emp_name`,`job`.`title` AS `job_title`,`eab`.`abs_type` AS `abs_type`,`eab`.`from_date` AS `from_date`,`eab`.`to_date` AS `to_date`,(to_days(`eab`.`to_date`) - to_days(curdate())) AS `days_left`,`eab`.`deputy` AS `deputy`,`eab`.`auth_by` AS `auth_by` from (((`emp_absences` `eab` join `employees` `emp`) join `departments` `dep`) join `jobs` `job`) where ((`emp`.`id` = `eab`.`emp_id`) and (`dep`.`id` = `emp`.`department_id`) and (`job`.`id` = `emp`.`job_id`) and (`eab`.`from_date` <= curdate()) and (`eab`.`to_date` >= curdate()) and (`eab`.`status` = 'Authorized')) order by `eab`.`to_date`,`eab`.`dur_days` desc,`eab`.`emp_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `emp_absences`
--

/*!50001 DROP VIEW IF EXISTS `emp_absences`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `emp_absences` AS select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `emp_name`,`abt`.`title` AS `abs_type`,`abr`.`from_date` AS `from_date`,`abr`.`to_date` AS `to_date`,`abr`.`for_year` AS `for_year`,`UTL_CALCVACDAYSID`(`abr`.`id`) AS `dur_days`,(case when (`dpty`.`id` is not null) then concat(`dpp`.`last_name`,', ',`dpp`.`first_name`) else 'n/a' end) AS `deputy`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `auth_by`,`abr`.`status` AS `status` from (((((`employees` `emp` join `persons` `per`) join ((`absences` `abr` left join `employees` `dpty` on((`abr`.`deputy_id` = `dpty`.`id`))) left join `persons` `dpp` on((`dpty`.`person_id` = `dpp`.`id`)))) join `absence_types` `abt`) join `employees` `auth`) join `persons` `app`) where ((`emp`.`id` = `abr`.`employee_id`) and (`emp`.`person_id` = `per`.`id`) and (`abr`.`type` = `abt`.`id`) and (`auth`.`id` = `abr`.`authorized_by`) and (`auth`.`person_id` = `app`.`id`) and (`abr`.`type` not in (10,11))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `emp_fullname`
--

/*!50001 DROP VIEW IF EXISTS `emp_fullname`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `emp_fullname` AS select `emp_getFullName`(`emp`.`id`) AS `full_name`,`emp`.`id` AS `emp_id` from (`employees` `emp` join `persons` `per`) where (`emp`.`person_id` = `per`.`id`) order by `emp_getFullName`(`emp`.`id`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `emp_history`
--

/*!50001 DROP VIEW IF EXISTS `emp_history`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `emp_history` AS select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `name`,`emp`.`contract_date` AS `date`,'Employment' AS `type`,`job`.`title` AS `what`,concat('Salary: ',convert(format(`sh`.`amount`,2) using utf8mb4)) AS `detail`,'Hired' AS `status`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `who` from (((((`job_history` `jh` join (`employees` `emp` left join `sal_history` `sh` on(((`sh`.`employee_id` = `emp`.`id`) and (`sh`.`from_date` = `emp`.`hire_date`))))) join `persons` `per`) join `jobs` `job`) join `employees` `apb`) join `persons` `app`) where ((`emp`.`id` = `jh`.`employee_id`) and (`job`.`id` = `jh`.`job_id`) and (`emp`.`person_id` = `per`.`id`) and (`jh`.`approved_by` = `apb`.`id`) and (`apb`.`person_id` = `app`.`id`) and (`jh`.`from_date` = `emp`.`hire_date`)) union all select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `name`,`tc`.`from_date` AS `date`,'Team' AS `type`,'Starts in' AS `what`,`dep`.`name` AS `detail`,'Approved' AS `status`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `who` from (((((`team_change` `tc` join `employees` `emp`) join `persons` `per`) join `departments` `dep`) join `employees` `apb`) join `persons` `app`) where ((`emp`.`id` = `tc`.`employee_id`) and (`dep`.`id` = `tc`.`department`) and (`emp`.`person_id` = `per`.`id`) and (`tc`.`approved_by` = `apb`.`id`) and (`apb`.`person_id` = `app`.`id`) and (`tc`.`from_date` = `emp`.`hire_date`)) union all select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `name`,`jh`.`from_date` AS `date`,'Job' AS `type`,'Position change' AS `what`,`job`.`title` AS `detail`,'Approved' AS `status`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `who` from (((((`job_history` `jh` join `employees` `emp`) join `persons` `per`) join `jobs` `job`) join `employees` `apb`) join `persons` `app`) where ((`emp`.`id` = `jh`.`employee_id`) and (`job`.`id` = `jh`.`job_id`) and (`emp`.`person_id` = `per`.`id`) and (`jh`.`approved_by` = `apb`.`id`) and (`apb`.`person_id` = `app`.`id`) and (`jh`.`from_date` <> `emp`.`hire_date`)) union all select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `name`,`tc`.`from_date` AS `date`,'Team' AS `type`,'Department change' AS `what`,`dep`.`name` AS `detail`,'Approved' AS `status`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `who` from (((((`team_change` `tc` join `employees` `emp`) join `persons` `per`) join `departments` `dep`) join `employees` `apb`) join `persons` `app`) where ((`emp`.`id` = `tc`.`employee_id`) and (`dep`.`id` = `tc`.`department`) and (`emp`.`person_id` = `per`.`id`) and (`tc`.`approved_by` = `apb`.`id`) and (`apb`.`person_id` = `app`.`id`) and (`tc`.`from_date` <> `emp`.`hire_date`)) union all select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `name`,`sh`.`from_date` AS `date`,'Salary' AS `type`,'Adjustment' AS `what`,concat('Amount: ',convert(format(`sh`.`amount`,2) using utf8mb4)) AS `detail`,'Approved' AS `status`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `who` from ((((`sal_history` `sh` join `employees` `emp`) join `persons` `per`) join `employees` `apb`) join `persons` `app`) where ((`emp`.`id` = `sh`.`employee_id`) and (`emp`.`person_id` = `per`.`id`) and (`sh`.`approved_by` = `apb`.`id`) and (`apb`.`person_id` = `app`.`id`) and (`sh`.`from_date` <> `emp`.`hire_date`)) union all select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `name`,`bd`.`approved_on` AS `date`,'Bonus' AS `type`,`b`.`title` AS `what`,concat('Amount: ',convert(format(`bd`.`amount`,2) using utf8mb4)) AS `detail`,'Approved' AS `status`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `who` from (((((`bonus_distribution` `bd` join `bonuses` `b`) join `employees` `emp`) join `persons` `per`) join `employees` `apb`) join `persons` `app`) where ((`b`.`id` = `bd`.`bonus_id`) and (`emp`.`id` = `bd`.`employee_id`) and (`emp`.`person_id` = `per`.`id`) and (`bd`.`approved_by` = `apb`.`id`) and (`apb`.`person_id` = `app`.`id`)) union all select `emp`.`id` AS `emp_id`,concat(`per`.`last_name`,', ',`per`.`first_name`) AS `name`,`apr`.`interview_date` AS `date`,'Appraisal' AS `type`,concat(`apt`.`title`,' ',`atp`.`title`) AS `what`,concat('Overal: ',convert(format(`apr`.`overall_eval`,1) using utf8mb4)) AS `detail`,NULL AS `status`,concat(`app`.`last_name`,', ',`app`.`first_name`) AS `who` from ((((((`appraisals` `apr` join `appraisal_types` `atp`) join `appraisal_period_types` `apt`) join `employees` `emp`) join `persons` `per`) join `employees` `apb`) join `persons` `app`) where ((`emp`.`id` = `apr`.`employee_id`) and (`emp`.`person_id` = `per`.`id`) and (`apr`.`appriser` = `apb`.`id`) and (`apb`.`person_id` = `app`.`id`) and (`apr`.`type` = `atp`.`id`) and (`apr`.`period_type` = `apt`.`id`)) order by `name`,`date` desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `emp_resigned`
--

/*!50001 DROP VIEW IF EXISTS `emp_resigned`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `emp_resigned` AS select concat(`per`.`last_name`,', ',`per`.`first_name`) AS `fullname`,`pos`.`title` AS `last_position`,`dep`.`name` AS `last_department`,`dvs`.`name` AS `last_division`,`emp`.`hire_date` AS `hired`,`emp`.`leave_date` AS `resigned`,(case when (`emp`.`leave_reason` is null) then 'n/a' when (char_length(`emp`.`leave_reason`) > 32) then concat(substr(`emp`.`leave_reason`,1,32),'...') else `emp`.`leave_reason` end) AS `reason`,`utl_getDateDiffStr`(`emp`.`hire_date`,`emp`.`leave_date`) AS `service_length`,`utl_getDateDiffStr`(`per`.`birth_date`,`emp`.`leave_date`) AS `age_at_leave` from (`persons` `per` join (((`employees` `emp` left join `jobs` `pos` on((`pos`.`id` = `emp`.`job_id`))) left join `departments` `dep` on((`dep`.`id` = `emp`.`department_id`))) left join `divisions` `dvs` on((`dvs`.`id` = `emp`.`division_id`)))) where ((`emp`.`leave_date` is not null) and (`per`.`id` = `emp`.`person_id`)) order by `emp`.`leave_date` desc,concat(`per`.`last_name`,', ',`per`.`first_name`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `emp_summary`
--

/*!50001 DROP VIEW IF EXISTS `emp_summary`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `emp_summary` AS select concat(`per`.`last_name`,', ',`per`.`first_name`) AS `fullname`,`pos`.`title` AS `position`,`emp`.`contract_date` AS `contracted`,`emp`.`hire_date` AS `hired`,`utl_getDateDiffStr`(`emp`.`hire_date`,curdate()) AS `service_length`,`utl_getDateDiffStr`(`per`.`birth_date`,curdate()) AS `age`,(select max(`jh`.`from_date`) from `job_history` `jh` where ((`jh`.`employee_id` = `emp`.`id`) and (`jh`.`job_id` = `emp`.`job_id`))) AS `last_job_change`,(select max(`sh`.`from_date`) from `sal_history` `sh` where ((`sh`.`employee_id` = `emp`.`id`) and (`sh`.`amount` = `emp`.`salary`))) AS `last_sal_change`,`emp`.`salary` AS `salary` from ((`employees` `emp` join `persons` `per`) join `jobs` `pos`) where ((`pos`.`id` = `emp`.`job_id`) and (`emp`.`person_id` = `per`.`id`) and (`emp`.`leave_date` is null)) order by `emp`.`hire_date` desc,concat(`per`.`last_name`,', ',`per`.`first_name`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `leaves_plan`
--

/*!50001 DROP VIEW IF EXISTS `leaves_plan`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `leaves_plan` AS select concat(`per`.`first_name`,' ',`per`.`last_name`) AS `emp_name`,`ab`.`for_year` AS `for_year`,month(`ab`.`from_date`) AS `MONTH(AB.from_date)`,`ab`.`from_date` AS `from_date`,`ab`.`to_date` AS `to_date`,((to_days(`ab`.`to_date`) - to_days(`ab`.`from_date`)) + 1) AS `dur_days` from ((`absences` `ab` join `employees` `emp`) join `persons` `per`) where ((`ab`.`status` = 'Requested') and (`ab`.`for_year` = year(curdate())) and (`emp`.`id` = `ab`.`employee_id`) and (`per`.`id` = `emp`.`person_id`)) order by concat(`per`.`first_name`,' ',`per`.`last_name`),`ab`.`from_date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pending_absences`
--

/*!50001 DROP VIEW IF EXISTS `pending_absences`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pending_absences` AS select `dep`.`name` AS `name`,`eab`.`emp_name` AS `emp_name`,`job`.`title` AS `job_title`,`eab`.`abs_type` AS `abs_type`,`eab`.`from_date` AS `from_date`,`eab`.`to_date` AS `to_date`,`eab`.`dur_days` AS `dur_days`,`eab`.`deputy` AS `deputy`,`eab`.`auth_by` AS `auth_by` from (((`emp_absences` `eab` join `employees` `emp`) join `departments` `dep`) join `jobs` `job`) where ((`emp`.`id` = `eab`.`emp_id`) and (`dep`.`id` = `emp`.`department_id`) and (`job`.`id` = `emp`.`job_id`) and (`eab`.`from_date` > curdate()) and (`eab`.`status` = 'Authorized')) order by `eab`.`from_date`,`eab`.`dur_days` desc,`eab`.`emp_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `per_relations_list`
--

/*!50001 DROP VIEW IF EXISTS `per_relations_list`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `per_relations_list` AS select concat(`p1`.`last_name`,', ',`p1`.`first_name`) AS `p1_name`,concat('is ',`prt`.`title`,' of') AS `relation`,concat(`p2`.`last_name`,', ',`p2`.`first_name`) AS `p2_name`,(case when (`pr`.`from_date` is not null) then concat('since ',convert(date_format(`pr`.`from_date`,'%Y-%m-%d') using utf8mb4)) end) AS `since` from (((`person_relations` `pr` join `person_relation_types` `prt`) join `persons` `p1`) join `persons` `p2`) where ((`pr`.`type` = `prt`.`id`) and (`pr`.`person1` = `p1`.`id`) and (`pr`.`person2` = `p2`.`id`)) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `requested_absences`
--

/*!50001 DROP VIEW IF EXISTS `requested_absences`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `requested_absences` AS select `dep`.`name` AS `name`,`eab`.`emp_name` AS `emp_name`,`job`.`title` AS `job_title`,`eab`.`abs_type` AS `abs_type`,`eab`.`from_date` AS `from_date`,`eab`.`to_date` AS `to_date`,`eab`.`dur_days` AS `dur_days`,`eab`.`deputy` AS `deputy`,`eab`.`auth_by` AS `auth_by` from (((`emp_absences` `eab` join `employees` `emp`) join `departments` `dep`) join `jobs` `job`) where ((`emp`.`id` = `eab`.`emp_id`) and (`dep`.`id` = `emp`.`department_id`) and (`job`.`id` = `emp`.`job_id`) and (`eab`.`status` = 'Requested')) order by `eab`.`to_date`,`eab`.`emp_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-01-16 18:15:47
