SELECT EMP.id, PER.first_name, PER.last_name,
       PER.birth_date,
       EMP.hire_date,
       getTeamJoinDate(EMP.id, DEP.id)  joined_on,
       getTeamExitDate(EMP.id, DEP.id)  exited_on,
       utl_getDateDiffStr(getTeamJoinDate(EMP.id, DEP.id),
                          IFNULL(getTeamExitDate(EMP.id, DEP.id), NOW()))
                                        in_the_team,
       EMP.leave_date,
       emp_getServiceLength(EMP.id)     total_service
  FROM employees   EMP,
       departments DEP,
       persons     PER
 WHERE (   DEP.id = EMP.department_id /* currently in the department */
           /* or have been member of the department */
        OR DEP.id IN (SELECT department
                        FROM team_change
                       WHERE employee_id = EMP.id
                     )
       )
   AND PER.id = EMP.person_id
   AND DEP.`name` LIKE '%Accounting%'
   /*AND EMP.leave_date IS NULL
   AND getTeamExitDate(EMP.id, DEP.id) IS NULL*/
   /*AND EMP.leave_date IS [NOT] NULL*/
   /*AND getTeamExitDate(EMP.id, DEP.id) IS NULL*/
 ORDER BY joined_on DESC;
