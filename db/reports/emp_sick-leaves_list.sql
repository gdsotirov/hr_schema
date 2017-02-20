SELECT AB.id, CONCAT(ABT.title, ' (', ABT.id, ')') `type`, AB.from_date, AB.to_date,
       utl_calcVacDaysId(AB.id) days,
       AB.description, AB.`status`
  FROM absences      AB,
       absence_types ABT,
       employees     EMP
 WHERE ABT.id = AB.`type`
   AND EMP.id = AB.employee_id
   AND EMP.id IN (SELECT id
                    FROM employees
                   WHERE person_id IN (SELECT id
                                         FROM persons
                                        WHERE CONCAT(first_name, ' ',
                                                     CASE WHEN middle_name IS NULL THEN '' ELSE CONCAT(middle_name, ' ') END,
                                                     CASE WHEN maiden_name IS NOT NULL THEN CONCAT(maiden_name, '-', last_name) ELSE last_name END)
                                              LIKE '%'
                                      )
                    AND leave_date IS NULL
                 )
   AND AB.`type` IN (7, 8, 9)
 ORDER BY AB.from_date ASC;
