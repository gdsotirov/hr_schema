SELECT CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       SUM(utl_calcVacDays(SLV.from_date, SLV.to_date)) tot_dur
  FROM employees EMP,
       persons   PER,
       absences  SLV /* Sick Leave */
 WHERE PER.id = EMP.person_id
   AND EMP.id = SLV.employee_id
   AND SLV.`type` = 7 /* sick leave */
   AND EMP.department_id = 1 /* Accounting */
 GROUP BY emp_name
 ORDER BY tot_dur DESC;