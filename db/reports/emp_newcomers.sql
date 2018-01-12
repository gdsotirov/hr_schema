SELECT EMP.id,
       CONCAT(PER.first_name, ' ',
              CASE
                WHEN PER.middle_name IS NOT NULL THEN CONCAT(PER.middle_name, ' ')
                ELSE ''
              END,
              PER.last_name) emp_name,
       DEP.`name` dep_name,
       EMP.hire_date,
       utl_getDateDiffStr(NOW(), EMP.hire_date) time_to_start
  FROM persons     PER,
       employees   EMP
       LEFT OUTER JOIN
       departments DEP ON EMP.department_id = DEP.id
 WHERE EMP.person_id = PER.id
 /*AND EMP.hire_date >= CURDATE()*/
   AND EMP.hire_date >= STR_TO_DATE('2018-01-01', '%Y-%m-%d')
 ORDER BY EMP.hire_date, emp_name;
