SELECT CASE GROUPING(DV.id)     WHEN 1 THEN 99      ELSE DV.id     END id,
       CASE GROUPING(DV.`name`) WHEN 1 THEN 'Total' ELSE DV.`name` END dept,
       COUNT(EMP.id) emp_cnt
  FROM divisions DV
       LEFT OUTER JOIN employees EMP
         ON DV.id = EMP.division_id
        AND (EMP.leave_date IS NULL OR EMP.leave_date > DATE(NOW()))
        AND EMP.hire_date <= DATE(NOW())
 WHERE 1=1
 GROUP BY DV.id, DV.`name` WITH ROLLUP
HAVING    (GROUPING(DV.id) = 0 AND GROUPING(DV.`name`) = 0)
       OR (GROUPING(DV.id) = 1 AND GROUPING(DV.`name`) = 1);