﻿CREATE TABLE `job_candidates` (
  `id`                INT(11) NOT NULL  AUTO_INCREMENT,
  `person_id`         INT(11) NOT NULL,
  `cv_doc`            BLOB    COMMENT 'Curriculum Vitae document',
  `cl_doc`            BLOB    COMMENT 'Cover Letter document',
  `job_id`            INT(11) NOT NULL,
  `first_interview`   DATE    NOT NULL,
  `second_interview`  DATE    DEFAULT NULL,
  `third_interview`   DATE    DEFAULT NULL,
  `status`            ENUM('Approved','Rejected','Pending')
                              DEFAULT NULL,
  `employee_id`       INT(11) DEFAULT NULL,

  PRIMARY KEY (`id`),

  KEY `fk_candidate_employee_idx` (`employee_id`),
  KEY `fk_candidate_person_idx`   (`person_id`),
  KEY `fk_candidate_job_idx`      (`job_id`),
  KEY `idx_candidate_interviewed` (`first_interview`),

  CONSTRAINT `fk_candidate_person`
    FOREIGN KEY (`person_id`)
    REFERENCES `persons` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_candidate_job`
    FOREIGN KEY (`job_id`)
    REFERENCES `jobs` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_candidate_employee`
    FOREIGN KEY (`employee_id`)
    REFERENCES `employees` (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COMMENT='Catalog of job candidates';
