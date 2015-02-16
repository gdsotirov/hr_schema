SELECT DATE_FORMAT(ABS.from_date, '%Y-%m') mnth,
       SUM(CASE
             WHEN ABT.id = 1
               THEN utl_calcVacDaysId(ABS.id)
             ELSE 0
           END) `Paid`,
       SUM(CASE
             WHEN ABT.id IN (2, 3)
               THEN utl_calcVacDaysId(ABS.id)
             ELSE 0
           END) `Unpaid`,
       SUM(CASE
             WHEN ABT.id IN (7, 8, 9)
               THEN utl_calcVacDaysId(ABS.id)
             ELSE 0
           END) `Sick`
  FROM absences      ABS,
       absence_types ABT
 WHERE ABT.id IN (1 /* paid */,
                  2 /* unpaid auth */,
                  3 /* unpaid unauth */,
                  7 /* sick */,
                  8 /* matern */,
                  9 /* patern */)
   AND ABT.id = ABS.`type`
   AND ABS.employee_id = 1
   AND ABS.`status` = 'Authorized'
 GROUP BY mnth
 ORDER BY mnth;
