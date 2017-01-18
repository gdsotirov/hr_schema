SELECT EMP.id, emp_getFullName(EMP.id)  full_name,
       DEP.`name`                       currently_in,
       EMP.hire_date,
       getPositionStartDate(EMP.id, 30) started_on,
       getPositionEndDate(EMP.id,   30) changed_on,
       utl_getDateDiffStr(getPositionStartDate(EMP.id, 30),
                          IFNULL(getPositionEndDate(EMP.id, 30), NOW()))
                                        on_the_position,
       EMP.leave_date,
       emp_getServiceLength(EMP.id)     total_service
  FROM employees   EMP,
       departments DEP
 WHERE DEP.id = EMP.department_id
   AND (   EMP.job_id = (SELECT id
                           FROM jobs
                          WHERE title = 'Administrative assitant'
                        )
        OR EXISTS (SELECT 1
                     FROM job_history
                    WHERE employee_id = EMP.id
                      AND job_id = (SELECT id
                                      FROM jobs
                                     WHERE title = 'Administrative assitant'
                                   )
                  )
       )
 ORDER BY started_on DESC, full_name ASC;
