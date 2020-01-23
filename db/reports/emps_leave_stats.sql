/* Internship at leave date with TIMESTAMPDIFF */

SELECT CASE
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) < 1                  THEN '<01 year'
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) BETWEEN 1 AND 2.99   THEN '<03 years'
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) BETWEEN 3 and 4.99   THEN '<05 years'
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) BETWEEN 5 and 7.99   THEN '<07 years'
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) BETWEEN 7 and 8.99   THEN '<09 years'
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) BETWEEN 9 and 10.99  THEN '<11 years'
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) BETWEEN 11 and 14.99 THEN '<15 years'
         WHEN TIMESTAMPDIFF(YEAR, EMP.hire_date, EMP.leave_date) BETWEEN 15 and 19.99 THEN '<20 years'
         ELSE '>20 years'
       END internship, COUNT(*) nb_emps
  FROM employees EMP
 WHERE leave_date IS NOT NULL
 GROUP BY internship
 ORDER BY internship;

/* Internship at leave date with DATEDIFF */

SELECT CASE
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 1  THEN '<=01 year'
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) > 1
          AND ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 3  THEN '<=03 years'
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) > 3
          AND ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 5  THEN '<=05 years'
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) > 5
          AND ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 7  THEN '<=07 years'
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) > 7
          AND ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 9  THEN '<=09 years'
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) > 9
          AND ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 11 THEN '<=11 years'
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) > 11
          AND ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 15 THEN '<=15 years'
         WHEN ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) > 15
          AND ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) <= 20 THEN '<=20 years'
         ELSE '>20 years'
       END internship, COUNT(*) nb_emps
  FROM employees EMP
 WHERE leave_date IS NOT NULL
 GROUP BY internship
 ORDER BY internship;

/* Employees that left by length of internship */

SELECT CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       ROUND(DATEDIFF(EMP.leave_date, EMP.hire_date)/365, 2) emp_internship
  FROM employees EMP,
       persons   PER
 WHERE EMP.person_id = PER.id
   AND EMP.leave_date IS NOT NULL
 ORDER BY emp_internship DESC;

/* Shortest internships up to 31 days */

SELECT ROW_NUMBER() OVER () `rank`,
       CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       DEP.`name` dep_name,
       EMP.hire_date, EMP.leave_date,
       DATEDIFF(EMP.leave_date, EMP.hire_date) emp_internship
  FROM employees   EMP
       LEFT OUTER JOIN
       departments DEP ON EMP.department_id = DEP.id,
       persons     PER
 WHERE EMP.person_id = PER.id
   AND EMP.leave_date IS NOT NULL
   AND DATEDIFF(EMP.leave_date, EMP.hire_date) BETWEEN 0 AND 31
 ORDER BY emp_internship ASC;
