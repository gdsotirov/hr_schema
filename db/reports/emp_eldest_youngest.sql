SELECT emp_name,
       CASE
         WHEN emp_age.birth_date = emp_age.eldest THEN 'eldest'
         ELSE 'youngest'
       END emp_rank,
       birth_date, age, hire_date, internship
  FROM (SELECT CONCAT(P.first_name, ' ', P.last_name) emp_name,
               P.birth_date,
               FIRST_VALUE(P.birth_date) OVER(ORDER BY P.birth_date
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) eldest,
               LAST_VALUE(P.birth_date) OVER(ORDER BY P.birth_date
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) youngest,
               utl_getDateDiffStr(P.birth_date, CURDATE()) age,
               E.hire_date,
               utl_getDateDiffStr(E.hire_date, CURDATE()) internship
          FROM employees E,
               persons   P
         WHERE P.id = E.person_id
           AND P.birth_date IS NOT NULL
           AND P.death_date IS NULL
           AND E.leave_date IS NULL
        ) emp_age
 WHERE emp_age.birth_date = emp_age.eldest
    OR emp_age.birth_date = emp_age.youngest;
