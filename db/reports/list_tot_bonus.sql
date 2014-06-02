SELECT EMP.id, CONCAT(PER.first_name, ' ', PER.last_name) nam, SUM(amount) total
  FROM bonus_distribution BD,
       employees          EMP,
       persons            PER
 WHERE BD.employee_id = EMP.id
   AND PER.id = EMP.person_id
 GROUP BY EMP.id
 ORDER BY total desc;