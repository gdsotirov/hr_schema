SELECT DV.id, DV.`name`, COUNT(*) emp_cnt
  FROM divisions DV,
       employees EMP
 WHERE DV.id = EMP.division_id
   AND (EMP.leave_date IS NULL OR EMP.leave_date >= NOW())
   AND EMP.hire_date <= NOW()
 GROUP BY DV.`name`
 ORDER BY emp_cnt DESC;
