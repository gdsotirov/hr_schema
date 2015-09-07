SELECT EMP.id, CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       EMP.hire_date, SH.amount, SH.currency
  FROM sal_history SH,
       employees   EMP,
       persons     PER,
       departments DEP
 WHERE SH.id = (SELECT id
                  FROM sal_history
                 WHERE employee_id = EMP.id
                   AND from_date = (SELECT MIN(from_date)
                                      FROM sal_history
                                     WHERE employee_id = EMP.id
                                   )
               )
   AND EMP.department_id = DEP.id
   AND (   DEP.`name` = 'Accounting'
        OR PER.id = 8)
   AND PER.id = EMP.person_id
 ORDER BY SH.amount DESC;