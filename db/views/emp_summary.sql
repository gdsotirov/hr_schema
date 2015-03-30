CREATE VIEW emp_summary AS
SELECT CONCAT(PER.last_name, ', ', PER.first_name) fullname,
       POS.title position,
       EMP.contract_date contracted,
       EMP.hire_date hired,
       utl_getDateDiffStr(EMP.hire_date, CURDATE()) service_length,
       utl_getDateDiffStr(PER.birth_date, CURDATE()) age,
       (SELECT MAX(JH.from_date)
          FROM job_history JH
         WHERE JH.employee_id = EMP.id
           AND JH.job_id = EMP.job_id
       ) last_job_change,
       (SELECT MAX(SH.from_date)
          FROM sal_history SH
         WHERE SH.employee_id = EMP.id
           AND SH.amount = EMP.salary
       ) last_sal_change,
       EMP.salary salary
  FROM employees   EMP,
       persons     PER,
       jobs        POS
 WHERE POS.id = EMP.job_id
   AND EMP.person_id = PER.id
   AND EMP.leave_date IS NULL
 ORDER BY hired DESC, fullname ASC;
