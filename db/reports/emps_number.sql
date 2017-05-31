SELECT @rownum := @rownum + 1 AS num,
       CONCAT(PER.first_name, ' ', PER.last_name) emp_nam,
       EMP.hire_date,
       EMP.leave_date,
       utl_getDateDiffStr(EMP.hire_date, IFNULL(EMP.leave_date, NOW())) intership
  FROM persons   PER,
       employees EMP,
       (SELECT @rownum := 0) R
 WHERE EMP.person_id = PER.id
 ORDER BY EMP.hire_date;