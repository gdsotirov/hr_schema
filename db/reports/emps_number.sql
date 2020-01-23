SELECT ROW_NUMBER() OVER () AS num,
       CONCAT(PER.first_name, ' ', PER.last_name) emp_nam,
       EMP.hire_date,
       EMP.leave_date,
       utl_getDateDiffStr(EMP.hire_date, IFNULL(EMP.leave_date, NOW())) internship
  FROM persons   PER,
       employees EMP
 WHERE EMP.person_id = PER.id
 ORDER BY EMP.hire_date;