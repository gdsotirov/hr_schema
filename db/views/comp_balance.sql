CREATE VIEW comp_balance AS
SELECT EMP.id `Number`,
       CONCAT(PER.first_name, ' ', PER.last_name) `Name`,
       DATE_FORMAT(MAX(from_date), '%Y-%m') `Until`,
       SEC_TO_TIME(SUM(CASE
                         WHEN ABSN.from_date <= ABSN.to_date THEN
                           TIME_TO_SEC(TIMEDIFF(ABSN.to_date, ABSN.from_date))
                         ELSE 0
                       END)
                  ) `HPlus`,
       SEC_TO_TIME(SUM(CASE
                         WHEN ABSN.from_date > ABSN.to_date THEN
                           TIME_TO_SEC(TIMEDIFF(ABSN.from_date, ABSN.to_date))
                         ELSE 0
                       END)
                  ) `HMinus`,
       CONCAT('',
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
                  )
       ) `Balance`
  FROM absences  ABSN,
       employees EMP,
       persons   PER
 WHERE ABSN.type = 10
   AND EMP.id = ABSN.employee_id
   AND PER.id = EMP.person_id
 GROUP BY `Name`
 ORDER BY `Name`;
 