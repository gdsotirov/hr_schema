SELECT EMP.id, emp_getFullName(EMP.id) full_name,
       EMP.hire_date, EMP.leave_date,
       CASE
         WHEN EMP.leave_date IS NOT NULL THEN utl_getDateDiffStr(EMP.hire_date, EMP.leave_date)
         ELSE 'n/a'
       END service
  FROM employees   EMP,
       departments DEP
 WHERE DEP.id = EMP.department_id
   AND DEP.`name` = 'Accounting'
 ORDER BY EMP.hire_date DESC;