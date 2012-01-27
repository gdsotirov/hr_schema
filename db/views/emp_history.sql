CREATE VIEW EmpHistory AS
SELECT EMP.id            `emp_id`,
       CONCAT(EMP.last_name, ', ', EMP.first_name)
                         `name`,
       EMP.contract_date `date`,
       'Hired'           `type`,
       JOB.title         `what`,
       'Signed'          `status`,
       JH.salary         `amount`
  FROM job_history  JH,
       employees    EMP,
       jobs         JOB
 WHERE EMP.id = JH.employee_id
   AND JOB.id = JH.job_id
   AND JH.from_date = EMP.hire_date

UNION ALL

SELECT EMP.id            `emp_id`,
       CONCAT(EMP.last_name, ', ', EMP.first_name)
                         `name`,
       JH.from_date      `date`,
       'Salary'          `type`,
       JOB.title         `what`,
       'Approved'        `status`,
       JH.salary         `amount`
  FROM job_history  JH,
       employees    EMP,
       jobs         JOB
 WHERE EMP.id = JH.employee_id
   AND JOB.id = JH.job_id
   AND JH.from_date != EMP.hire_date

UNION ALL

SELECT EMP.id            `emp_id`,
       CONCAT(EMP.last_name, ', ', EMP.first_name)
                         `name`,
       BD.approved_date  `date`,
       'Bonus'           `type`,
       B.title           `what`,
       'Granted'         `status`,
       BD.amount         `amount`
  FROM bonus_distribution   BD,
       bonuses              B,
       employees            EMP
 WHERE B.id = BD.bonus_id
   AND EMP.id = BD.employee_id

UNION ALL

SELECT EMP.id             `emp_id`,
       CONCAT(EMP.last_name, ', ', EMP.first_name)
                          `name`,
       APR.interview_date `date`,
       'Appraisal'        `type`,
       NULL               `what`,
       CONCAT('Overal: ', FORMAT(overall_eval, 1))
                          `status`,
       NULL               `amount`
  FROM appraisals   APR,
       employees    EMP
 WHERE EMP.id = APR.employee_id

 /* global order */
 ORDER BY `name` ASC, `date` DESC;
