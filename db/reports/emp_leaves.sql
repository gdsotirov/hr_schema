SELECT CONCAT(PER.first_name, ' ', PER.last_name) nam, A.from_date, utl_calcVacDays(A.id) dur, A.to_date, ABT.title, A.`status`
  FROM absences      A,
       absence_types ABT,
       employees     EMP,
       persons       PER
 WHERE A.employee_id = EMP.id
   AND EMP.department_id = 1
   AND A.`type` NOT IN (10, 11) /* exclude compensations and planned paid leaves */
   /*AND CONCAT(PER.first_name, ' ', PER.last_name) LIKE '%%'*/
   AND (   (    A.from_date >= STR_TO_DATE('2014-05-01 00:00:00', '%Y-%m-%d %H:%i:%s')
            AND A.from_date <= STR_TO_DATE('2014-05-31 23:59:59', '%Y-%m-%d %H:%i:%s')
           )
        OR (    A.to_date   >= STR_TO_DATE('2014-05-01 00:00:00', '%Y-%m-%d %H:%i:%s')
            AND A.to_date   <= STR_TO_DATE('2014-05-31 23:59:59', '%Y-%m-%d %H:%i:%s')
           )
        OR (    A.from_date <  STR_TO_DATE('2014-05-01 00:00:00', '%Y-%m-%d %H:%i:%s')
            AND A.to_date   >  STR_TO_DATE('2014-05-31 23:59:59', '%Y-%m-%d %H:%i:%s')
           )
       )
   AND ABT.id = A.`type`
   AND PER.id = EMP.person_id
 ORDER BY nam, A.from_date;