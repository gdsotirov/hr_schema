SELECT CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       SUM(utl_calcVacDays(SLV.from_date, SLV.to_date)) tot_dur,
       ROUND(AVG(utl_calcVacDays(SLV.from_date, SLV.to_date)), 1) avg_days
  FROM employees EMP,
       persons   PER,
       absences  SLV /* Sick Leave */
 WHERE PER.id = EMP.person_id
   AND EMP.id = SLV.employee_id
   AND SLV.`type` IN (7, 8, 9) /* all sick leave including maternity and paternity */
   AND EMP.department_id = 1 /* Accounting */
   /*AND SLV.from_date <= '2015-08-01'*/
   AND SLV.`status` != 'Cancelled'
 GROUP BY emp_name
 ORDER BY tot_dur DESC;
