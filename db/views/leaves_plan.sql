CREATE OR REPLACE VIEW leaves_plan AS
SELECT CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       AB.for_year,
       MONTH(AB.from_date),
       AB.from_date,
       AB.to_date,
       DATEDIFF(AB.to_date, AB.from_date) + 1 dur_days
  FROM absences  AB,
       employees EMP,
       persons   PER
 WHERE AB.status = 'Requested'
   AND AB.for_year = YEAR(CURDATE())
   AND EMP.id = AB.employee_id
   AND PER.id = EMP.person_id
 ORDER BY emp_name, AB.from_date;
