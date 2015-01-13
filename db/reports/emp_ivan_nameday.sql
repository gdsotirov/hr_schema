select CONCAT(PER.first_name, ' ', PER.last_name) nam, PER.birth_date, EMP.hire_date
  from persons   PER,
       employees EMP
 where PER.id = EMP.person_id
   AND EMP.division_id = 1
   AND EMP.leave_date IS NULL
   AND (   PER.first_name LIKE 'Iva%'
        OR PER.first_name LIKE 'Ive%'
        OR PER.first_name LIKE 'Ivo%'
        OR PER.first_name LIKE 'Jan%'
        OR PER.first_name LIKE 'Joa%'
        OR PER.first_name LIKE 'Jov%'
        OR PER.first_name LIKE 'Van%');
