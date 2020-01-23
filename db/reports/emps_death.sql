SELECT CONCAT(PER.first_name, ' ', PER.last_name) nam,
       PER.birth_date, EMP.hire_date,
       (SELECT MIN(hire_date)
          FROM employees
         WHERE person_id = PER.id) first_hired,
       PER.death_date,
       TIMESTAMPDIFF(Year, PER.birth_date, PER.death_date) age,
       utl_getDateDiffStr(PER.birth_date, PER.death_date) age_full,
       utl_getDateDiffStr(EMP.hire_date, EMP.leave_date) internship,
       NULL total_internship
  FROM persons   PER,
       employees EMP
 WHERE EMP.person_id = PER.id
   AND EMP.leave_date = PER.death_date
 ORDER BY PER.death_date DESC;