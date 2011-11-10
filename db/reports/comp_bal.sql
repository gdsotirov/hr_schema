SELECT CONCAT(PER.first_name, ' ', PER.last_name) nam,
       date_format(ABSN.from_date, '%Y-%m') for_period,
       SEC_TO_TIME(SUM(CASE
                         WHEN ABSN.from_date <= ABSN.to_date THEN
                           TIME_TO_SEC(TIMEDIFF(ABSN.to_date, ABSN.from_date))
                         ELSE 0
                       END)
                  ) plus,
       SEC_TO_TIME(SUM(CASE
                         WHEN ABSN.from_date > ABSN.to_date THEN
                           TIME_TO_SEC(TIMEDIFF(ABSN.from_date, ABSN.to_date))
                         ELSE 0
                       END)
                  ) minus,
       SEC_TO_TIME(SUM(CASE
                         WHEN ABSN.from_date <= ABSN.to_date THEN
                           TIME_TO_SEC(TIMEDIFF(ABSN.to_date, ABSN.from_date))
                         ELSE 0
                       END)
                   -
                   SUM(CASE
                         WHEN ABSN.from_date > ABSN.to_date THEN
                           TIME_TO_SEC(TIMEDIFF(ABSN.from_date, ABSN.to_date))
                         ELSE 0
                       END)
                  ) bal
  FROM absences  ABSN,
       employees EMP,
       persons   PER
 WHERE ABSN.type = 10
   AND EMP.id = 1
   AND EMP.id = ABSN.employee_id
   AND PER.id = EMP.person_id
 GROUP BY nam, for_period
 ORDER BY for_period DESC;
