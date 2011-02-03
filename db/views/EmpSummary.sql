CREATE VIEW EmpSummary AS
SELECT CONCAT(EMP.last_name, ', ', EMP.first_name) fullname,
       POS.title position,
       EMP.contract_date contracted,
       EMP.hire_date hired,
       utl_getDateDiffStr(EMP.hire_date, CURDATE()) service_length,
       utl_getDateDiffStr(EMP.birth_date, CURDATE()) age,
       (SELECT MAX(JH.from_date)
          FROM job_history JH
         WHERE JH.employee_id = EMP.id
           AND JH.salary != EMP.salary
       ) last_annex,
       EMP.salary salary
  FROM employees   EMP,
       jobs POS
 WHERE POS.id = EMP.job_id
 ORDER BY hired DESC, fullname ASC;
