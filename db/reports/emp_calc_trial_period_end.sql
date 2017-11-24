SELECT EMP.id,
       CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       EMP.hire_date, EMP.trial_period,
       DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH) trial_end_orig,
       (SELECT IFNULL(SUM(utl_calcVacDays(LVP.from_date, LVP.to_date)), 0)
                 FROM absences LVP
                WHERE LVP.employee_id = EMP.id
                  AND LVP.`type` = 1 /* paid */
                  AND LVP.from_date >= EMP.hire_date
                  AND LVP.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) paid,
       (SELECT IFNULL(SUM(utl_calcVacDays(LVU.from_date, LVU.to_date)), 0)
          FROM absences LVU
         WHERE LVU.employee_id = EMP.id
           AND LVU.`type` IN (2, 3) /* unpaid with and without authorization */
           AND LVU.from_date >= EMP.hire_date
           AND LVU.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) unpaid,
       (SELECT IFNULL(SUM(utl_calcVacDays(LVS.from_date, LVS.to_date)), 0)
          FROM absences LVS
         WHERE LVS.employee_id = EMP.id
           AND LVS.`type` = 7 /* sick-leave */
           AND LVS.from_date >= EMP.hire_date
           AND LVS.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) sickleave,
       ((SELECT IFNULL(SUM(utl_calcVacDays(LVP.from_date, LVP.to_date)), 0)
                 FROM absences LVP
                WHERE LVP.employee_id = EMP.id
                  AND LVP.`type` = 1 /* paid */
                  AND LVP.from_date >= EMP.hire_date
                  AND LVP.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) +
       (SELECT IFNULL(SUM(utl_calcVacDays(LVU.from_date, LVU.to_date)), 0)
          FROM absences LVU
         WHERE LVU.employee_id = EMP.id
           AND LVU.`type` IN (2, 3) /* unpaid with and without authorization */
           AND LVU.from_date >= EMP.hire_date
           AND LVU.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) +
       (SELECT IFNULL(SUM(utl_calcVacDays(LVS.from_date, LVS.to_date)), 0)
          FROM absences LVS
         WHERE LVS.employee_id = EMP.id
           AND LVS.`type` = 7 /* sick-leave */
           AND LVS.from_date >= EMP.hire_date
           AND LVS.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       )) total,
       DATE_ADD(DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH), INTERVAL
       (SELECT IFNULL(SUM(utl_calcVacDays(LVP.from_date, LVP.to_date)), 0)
                 FROM absences LVP
                WHERE LVP.employee_id = EMP.id
                  AND LVP.`type` = 1 /* paid */
                  AND LVP.from_date >= EMP.hire_date
                  AND LVP.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) +
       (SELECT IFNULL(SUM(utl_calcVacDays(LVU.from_date, LVU.to_date)), 0)
          FROM absences LVU
         WHERE LVU.employee_id = EMP.id
           AND LVU.`type` IN (2, 3) /* unpaid with and without authorization */
           AND LVU.from_date >= EMP.hire_date
           AND LVU.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) +
       (SELECT IFNULL(SUM(utl_calcVacDays(LVS.from_date, LVS.to_date)), 0)
          FROM absences LVS
         WHERE LVS.employee_id = EMP.id
           AND LVS.`type` = 7 /* sick-leave */
           AND LVS.from_date >= EMP.hire_date
           AND LVS.to_date   <= DATE_ADD(EMP.hire_date, INTERVAL EMP.trial_period MONTH)
       ) DAY) trial_end_recalc
  FROM employees   EMP,
       persons     PER,
       departments DEP
 WHERE (   DEP.id = EMP.department_id /* currently in the department */
           /* or have been member of the department */
        OR DEP.id IN (SELECT department
                        FROM team_change
                       WHERE employee_id = EMP.id
                     )
       )
   AND PER.id = EMP.person_id
   AND DEP.`name` LIKE '%Accounting%'
   AND EMP.trial_period IS NOT NULL
 ORDER BY EMP.hire_date;