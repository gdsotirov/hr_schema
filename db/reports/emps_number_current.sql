SELECT ROW_NUMBER() OVER () AS Num,
       CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) emp_internship
  FROM employees EMP,
       persons   PER
 WHERE EMP.person_id = PER.id
   AND EMP.leave_date IS NULL
 ORDER BY emp_internship DESC;
