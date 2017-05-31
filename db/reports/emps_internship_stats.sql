SELECT CASE
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 1  THEN '<=01 year'
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) > 1
          AND ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 3  THEN '<=03 years'
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) > 3
          AND ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 5  THEN '<=05 years'
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) > 5
          AND ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 7  THEN '<=07 years'
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) > 7
          AND ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 9  THEN '<=09 years'
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) > 9
          AND ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 11 THEN '<=11 years'
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) > 11
          AND ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 15 THEN '<=15 years'
         WHEN ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) > 15
          AND ROUND(DATEDIFF(NOW(), EMP.hire_date)/365, 2) <= 20 THEN '<=20 years'
         ELSE '>20 years'
       END intership, COUNT(*) nb_emps
  FROM employees EMP
 WHERE leave_date IS NULL
 GROUP BY intership;
