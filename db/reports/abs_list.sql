SELECT AB.id, ABT.title,
       DATE_FORMAT(AB.from_date, '%d %b %Y') `From`,
       DATE_FORMAT(AB.to_date  , '%d %b %Y') `To`,
       utl_calcVacDaysId(AB.id) `Days`
  FROM absences AB,
       absence_types ABT
 WHERE AB.`type` = ABT.id
   AND AB.`type` NOT IN (10, 11) -- planned and compensation
   AND AB.employee_id IN (SELECT id
                            FROM employees
                           WHERE person_id IN (SELECT id
                                                 FROM persons
                                                WHERE CONCAT(first_name, ' ', IFNULL(middle_name, ''), ' ', last_name) LIKE '%'))
   AND AB.from_date >= '2012-01-01'
 ORDER BY AB.from_date;
