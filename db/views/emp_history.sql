CREATE OR REPLACE VIEW emp_history AS
SELECT EMP.id            `emp_id`,
       CONCAT(PER.last_name, ', ', PER.first_name)
                         `name`,
       EMP.contract_date `date`,
       'Employment'      `type`,
       JOB.title         `what`,
       CONCAT('Salary: ', FORMAT(SH.amount, 2))
                         `detail`,
       'Hired'           `status`,
       CONCAT(APP.last_name, ', ', APP.first_name)
                         `who`
  FROM job_history  JH,
       employees    EMP LEFT OUTER JOIN sal_history  SH
                         ON SH.employee_id = EMP.id
                        AND SH.from_date = EMP.hire_date,
       persons      PER,
       jobs         JOB,
       employees    APB,
       persons      APP
 WHERE EMP.id = JH.employee_id
   AND JOB.id = JH.job_id
   AND EMP.person_id = PER.id
   AND JH.approved_by = APB.id
   AND APB.person_id = APP.id
   AND JH.from_date = EMP.hire_date

UNION ALL

SELECT EMP.id            `emp_id`,
       CONCAT(PER.last_name, ', ', PER.first_name)
                         `name`,
       TC.from_date      `date`,
       'Team'            `type`,
       'Starts in' `what`,
       DEP.name          `detail`,
       'Approved'        `status`,
       CONCAT(APP.last_name, ', ', APP.first_name)
                         `who`
  FROM team_change  TC,
       employees    EMP,
       persons      PER,
       departments  DEP,
       employees    APB,
       persons      APP
 WHERE EMP.id = TC.employee_id
   AND DEP.id = TC.department
   AND EMP.person_id = PER.id
   AND TC.approved_by = APB.id
   AND APB.person_id = APP.id
   AND TC.from_date = EMP.hire_date

UNION ALL

SELECT EMP.id            `emp_id`,
       CONCAT(PER.last_name, ', ', PER.first_name)
                         `name`,
       JH.from_date      `date`,
       'Job'             `type`,
       'Position change' `what`,
       JOB.title         `detail`,
       'Approved'        `status`,
       CONCAT(APP.last_name, ', ', APP.first_name)
                         `who`
  FROM job_history  JH,
       employees    EMP,
       persons      PER,
       jobs         JOB,
       employees    APB,
       persons      APP
 WHERE EMP.id = JH.employee_id
   AND JOB.id = JH.job_id
   AND EMP.person_id = PER.id
   AND JH.approved_by = APB.id
   AND APB.person_id = APP.id
   AND JH.from_date != EMP.hire_date

UNION ALL

SELECT EMP.id            `emp_id`,
       CONCAT(PER.last_name, ', ', PER.first_name)
                         `name`,
       TC.from_date      `date`,
       'Team'            `type`,
       'Department change' `what`,
       DEP.name          `detail`,
       'Approved'        `status`,
       CONCAT(APP.last_name, ', ', APP.first_name)
                         `who`
  FROM team_change  TC,
       employees    EMP,
       persons      PER,
       departments  DEP,
       employees    APB,
       persons      APP
 WHERE EMP.id = TC.employee_id
   AND DEP.id = TC.department
   AND EMP.person_id = PER.id
   AND TC.approved_by = APB.id
   AND APB.person_id = APP.id
   AND TC.from_date != EMP.hire_date

UNION ALL

SELECT EMP.id            `emp_id`,
       CONCAT(PER.last_name, ', ', PER.first_name)
                         `name`,
       SH.from_date      `date`,
       'Salary'          `type`,
       'Adjustment'      `what`,
       CONCAT('Amount: ', FORMAT(SH.amount, 2))
                         `detail`,
       'Approved'        `status`,
       CONCAT(APP.last_name, ', ', APP.first_name)
                         `who`
  FROM sal_history  SH,
       employees    EMP,
       persons      PER,
       employees    APB,
       persons      APP
 WHERE EMP.id = SH.employee_id
   AND EMP.person_id = PER.id
   AND SH.approved_by = APB.id
   AND APB.person_id = APP.id
   AND SH.from_date != EMP.hire_date

UNION ALL

SELECT EMP.id            `emp_id`,
       CONCAT(PER.last_name, ', ', PER.first_name)
                         `name`,
       BD.approved_on    `date`,
       'Bonus'           `type`,
       B.title           `what`,
       CONCAT('Amount: ', FORMAT(BD.amount, 2))
                         `detail`,
       'Approved'        `status`,
       CONCAT(APP.last_name, ', ', APP.first_name)
                         `who`
  FROM bonus_distribution   BD,
       bonuses              B,
       employees            EMP,
       persons              PER,
       employees            APB,
       persons              APP
 WHERE B.id = BD.bonus_id
   AND EMP.id = BD.employee_id
   AND EMP.person_id = PER.id
   AND BD.approved_by = APB.id
   AND APB.person_id = APP.id

UNION ALL

SELECT EMP.id             `emp_id`,
       CONCAT(PER.last_name, ', ', PER.first_name)
                          `name`,
       APR.interview_date `date`,
       'Appraisal'        `type`,
       CONCAT(APT.title, ' ', ATP.title)
                          `what`,
       CONCAT('Overal: ', FORMAT(overall_eval, 1))
                          `detail`,
       NULL               `status`,
       CONCAT(APP.last_name, ', ', APP.first_name)
                          `who`
  FROM appraisals   APR,
       appraisal_types ATP,
       appraisal_period_types APT,
       employees    EMP,
       persons      PER,
       employees    APB,
       persons      APP
 WHERE EMP.id = APR.employee_id
   AND EMP.person_id = PER.id
   AND APR.appriser = APB.id
   AND APB.person_id = APP.id
   AND APR.type = ATP.id
   AND APR.period_type = APT.id

 /* global order */
 ORDER BY `name` ASC, `date` DESC;
