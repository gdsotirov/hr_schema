SELECT EMP.id, CONCAT(PER.first_name, ' ', PER.last_name) nam,
       BON.title, BD.granted_on, BD.details `granted for`, BD.amount
  FROM bonuses            BON,
       bonus_distribution BD,
       employees          EMP,
       persons            PER
 WHERE BON.id = BD.bonus_id
   AND BD.employee_id = EMP.id
   AND PER.id = EMP.person_id
   AND CONCAT(PER.first_name, ' ', PER.last_name) LIKE '%'
   AND BD.approved_on IS NOT NULL
 ORDER BY BD.granted_on DESC;
