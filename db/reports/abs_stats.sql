SELECT CONCAT(P.first_name, ' ', P.last_name) `Name`,
       A.for_year `Year`,
       SUM(TIMESTAMPDIFF(DAY, A.from_date, A.to_date) + 1)
  FROM absences  A,
       employees E,
       persons   P
 WHERE A.type       = 7 -- paid leave
   AND A.status     = 'Authorized'
   AND A.for_year   = 2011
   AND A.employee_id= E.id
   AND E.person_id  = P.id
   AND E.department_id IN (1, 2)
 GROUP BY `Name`, `Year`
 ORDER BY `Year` DESC, 3 desc, `Name`;
