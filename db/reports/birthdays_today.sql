SELECT CONCAT(PER.first_name, ' ', PER.last_name) nam,
       PER.birth_date,
       YEAR(CURDATE()) - YEAR(PER.birth_date) age
  FROM employees EMP,
       persons   PER
 WHERE PER.id = EMP.person_id
   AND PER.birth_date IS NOT NULL
   AND EXTRACT(DAY   FROM PER.birth_date) = EXTRACT(DAY   FROM CURDATE())
   AND EXTRACT(MONTH FROM PER.birth_date) = EXTRACT(MONTH FROM CURDATE());
