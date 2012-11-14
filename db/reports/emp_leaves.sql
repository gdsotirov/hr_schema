SELECT CONCAT(PER.first_name, ' ', PER.last_name) nam, A.from_date, A.to_date, ABT.title
  FROM absences      A,
       absence_types ABT,
       employees     EMP,
       persons       PER
 WHERE A.employee_id = EMP.id
   AND EMP.department_id = 1
   AND A.`type` NOT IN (10, 11) -- exclude compensations and planned paid leaves
   AND ABT.id = A.type
   AND PER.id = EMP.person_id
 ORDER BY A.from_date;
