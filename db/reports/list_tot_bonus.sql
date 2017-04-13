SELECT EMP.id, CONCAT(PER.first_name, ' ', PER.last_name) nam, SUM(amount) total, COUNT(*) cnt
  FROM bonus_distribution BD,
       employees          EMP,
       persons            PER
 WHERE BD.employee_id = EMP.id
   AND PER.id = EMP.person_id
   AND BD.approved_on IS NOT NULL
   /*AND BD.approved_on < '2017-03-29'*/
 GROUP BY EMP.id
 ORDER BY total DESC;
