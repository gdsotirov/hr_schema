SELECT CONCAT(PER.first_name, ' ', PER.last_name) nam,
       ABT.title,
       GREATEST(A.from_date, STR_TO_DATE('2015-02-01 00:00:00', '%Y-%m-%d %H:%i:%s')) from_date,
       LEAST(A.to_date     , STR_TO_DATE('2015-02-28 23:59:59', '%Y-%m-%d %H:%i:%s')) to_date,
       DATEDIFF(   LEAST(A.to_date  , STR_TO_DATE('2015-02-28 00:00:00', '%Y-%m-%d %H:%i:%s')),
                GREATEST(A.from_date, STR_TO_DATE('2015-02-01 00:00:00', '%Y-%m-%d %H:%i:%s'))) + 1 days,
       utl_calcVacDays(A.from_date, A.to_date) total_days
  FROM absences      A,
       absence_types ABT,
       employees     EMP,
       persons       PER
 WHERE A.employee_id = EMP.id
   AND EMP.department_id = 1
   AND A.`type` NOT IN (10, 11) /* exclude compensations and planned paid leaves */
   /*AND CONCAT(PER.first_name, ' ', PER.last_name) LIKE '%%'*/
   AND (   A.from_date BETWEEN STR_TO_DATE('2015-02-01 00:00:00', '%Y-%m-%d %H:%i:%s') AND STR_TO_DATE('2015-02-28 23:59:59', '%Y-%m-%d %H:%i:%s')
        OR A.to_date   BETWEEN STR_TO_DATE('2015-02-01 00:00:00', '%Y-%m-%d %H:%i:%s') AND STR_TO_DATE('2015-02-28 23:59:59', '%Y-%m-%d %H:%i:%s')
        OR (    A.from_date <= STR_TO_DATE('2015-02-01 00:00:00', '%Y-%m-%d %H:%i:%s') AND STR_TO_DATE('2015-02-28 23:59:59', '%Y-%m-%d %H:%i:%s')
            AND A.to_date   >= STR_TO_DATE('2015-02-01 00:00:00', '%Y-%m-%d %H:%i:%s') AND STR_TO_DATE('2015-02-28 23:59:59', '%Y-%m-%d %H:%i:%s')
           )
       )
   AND ABT.id = A.`type`
   AND PER.id = EMP.person_id
   AND A.`status` = 'Authorized'
 ORDER BY nam, from_date;