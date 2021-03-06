SELECT DENSE_RANK() OVER (ORDER BY SUM(utl_calcVacDays(SLV.from_date, SLV.to_date)) DESC) AS rnk,
       CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       utl_getDateDiffStr(EMP.hire_date, IFNULL(EMP.leave_date, CURDATE())) internship,
       SUM(utl_calcVacDays(SLV.from_date, SLV.to_date)) tot_dur,
       ROUND(AVG(utl_calcVacDays(SLV.from_date, SLV.to_date)), 2) avg_days_per_leave,
       ROUND(SUM(utl_calcVacDays(SLV.from_date, SLV.to_date)) /
             (TIMESTAMPDIFF(YEAR, EMP.hire_date, IFNULL(EMP.leave_date, CURDATE())) + 1), 2) avg_days_per_year
  FROM employees EMP,
       persons   PER,
       absences  SLV /* Sick Leave */
 WHERE PER.id = EMP.person_id
   AND EMP.id = SLV.employee_id
   AND SLV.`type` = 7 /* sick leave */
   AND EMP.department_id = 1 /* Accounting */
   AND SLV.`status` != 'Cancelled'
 GROUP BY EMP.id
 ORDER BY tot_dur DESC;
