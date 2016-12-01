SELECT CONCAT(PER.first_name, ' ',
              CASE
                WHEN PER.middle_name IS NOT NULL THEN CONCAT(PER.middle_name, ' ')
                ELSE ''
              END,
              PER.last_name) emp_name,
       DEP.`name` dep_name,
       EMP.leave_date,
       utl_getDateDiffStr(NOW(), EMP.leave_date) leaving_in
  FROM persons     PER,
       employees   EMP,
       departments DEP
 WHERE EMP.person_id = PER.id
   AND EMP.department_id = DEP.id
   AND EMP.leave_date >= DATE(NOW()) /*STR_TO_DATE('2016-12-01', '%Y-%m-%d')*/
 ORDER BY EMP.leave_date;