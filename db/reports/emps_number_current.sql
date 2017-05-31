SELECT @rownum := @rownum + 1 AS Num,
       CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) emp_intership
  FROM employees EMP,
       persons   PER,
       (SELECT @rownum := 0) R
 WHERE EMP.person_id = PER.id
   AND EMP.leave_date IS NULL
 ORDER BY emp_intership DESC;
