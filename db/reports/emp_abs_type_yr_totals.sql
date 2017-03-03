SELECT EMP.id, emp_getFullName(EMP.id) `Name`,
       YEAR(ABS.from_date) `Year`,
       SUM(IF(ABS.`type` = 1            , utl_calcVacDaysId(ABS.id), 0)) `Paid`,
       SUM(IF(ABS.`type` = 13           , utl_calcVacDaysId(ABS.id), 0)) `KP`,
       SUM(IF(ABS.`type` = 4            , utl_calcVacDaysId(ABS.id), 0)) `Others (paid)`,
       SUM(IF(ABS.`type` IN (2, 3)      , utl_calcVacDaysId(ABS.id), 0)) `Unpaid`,
       SUM(IF(ABS.`type` = 7            , utl_calcVacDaysId(ABS.id), 0)) `Sick`,
       SUM(IF(ABS.`type` = 8            , utl_calcVacDaysId(ABS.id), 0)) `Maternity`,
       SUM(IF(ABS.`type` = 9            , utl_calcVacDaysId(ABS.id), 0)) `Paternity`,
       SUM(IF(ABS.`type` = 5            , utl_calcVacDaysId(ABS.id), 0)) `Trip`,
       SUM(IF(ABS.`type` = 6            , utl_calcVacDaysId(ABS.id), 0)) `FromHome`,
       SUM(IF(ABS.`type` = 12           , utl_calcVacDaysId(ABS.id), 0)) `Compensation`,
       SUM(IF(ABS.`type` NOT IN (10, 11), utl_calcVacDaysId(ABS.id), 0)) `Total`
  FROM employees     EMP,
       absences      ABS,
       absence_types ABT
 WHERE ABS.employee_id = EMP.id
   AND ABS.`status` = 'Authorized'
   AND ABT.id = ABS.`type`
   AND EMP.id IN (SELECT id
                    FROM employees
                   WHERE person_id IN (SELECT id
                                         FROM persons
                                        WHERE CONCAT(first_name, ' ',
                                                     CASE
                                                       WHEN middle_name IS NULL THEN ''
                                                       ELSE CONCAT(middle_name, ' ')
                                                     END, last_name) LIKE '%'
                                      )
                 )
 GROUP BY `Year` DESC;
