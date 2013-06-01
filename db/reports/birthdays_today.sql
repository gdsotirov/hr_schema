SELECT CONCAT(PER.last_name, ', ', PER.first_name) full_name,
       PER.birth_date,
       utl_getDateDiffStr(PER.birth_date, CURDATE()) age
  FROM employees EMP,
       persons   PER
 WHERE PER.id = EMP.person_id
   AND PER.birth_date IS NOT NULL
   AND CURDATE() = STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-', MONTH(PER.birth_date), '-', DAY(PER.birth_date)), '%Y-%m-%d');
