SELECT CASE
         WHEN FLOOR(DATEDIFF(NOW(), PER.birth_date)/365)       < 18        THEN '<18'
         WHEN FLOOR(DATEDIFF(NOW(), PER.birth_date)/365) BETWEEN 18 AND 24 THEN '18_24'
         WHEN FLOOR(DATEDIFF(NOW(), PER.birth_date)/365) BETWEEN 25 AND 34 THEN '25_34'
         WHEN FLOOR(DATEDIFF(NOW(), PER.birth_date)/365) BETWEEN 35 AND 44 THEN '35_44'
         WHEN FLOOR(DATEDIFF(NOW(), PER.birth_date)/365) BETWEEN 45 AND 54 THEN '45_54'
         WHEN FLOOR(DATEDIFF(NOW(), PER.birth_date)/365) BETWEEN 55 AND 64 THEN '55_64'
         WHEN FLOOR(DATEDIFF(NOW(), PER.birth_date)/365)             >= 65 THEN '>=65'
       END age_group,
       ROUND(COUNT(*) / (SELECT COUNT(*) FROM employees WHERE (leave_date IS NULL OR leave_date >= CURDATE())) * 100, 2) percent,
       COUNT(*) cnt
  FROM persons   PER,
       employees EMP
 WHERE EMP.person_id = PER.id
   AND EMP.hire_date <= NOW()
   AND (EMP.leave_date IS NULL OR EMP.leave_date >= NOW())
   AND PER.birth_date IS NOT NULL
 GROUP BY age_group
 ORDER BY age_group;