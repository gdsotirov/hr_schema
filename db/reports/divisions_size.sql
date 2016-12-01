SELECT DV.id, DV.`name`, COUNT(*) emp_cnt
  FROM divisions DV,
       employees EMP
 WHERE DV.id = EMP.division_id
   AND (EMP.leave_date IS NULL OR EMP.leave_date > DATE(NOW()))
   AND EMP.hire_date <= DATE(NOW())
 GROUP BY `name`
UNION ALL
SELECT 9 id, 'Total' `name`, COUNT(*) emp_cnt
  FROM employees EMP
 WHERE EMP.leave_date IS NULL OR EMP.leave_date > DATE(NOW())
   AND EMP.hire_date <= DATE(NOW())
 ORDER BY id;