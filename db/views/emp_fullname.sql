CREATE VIEW emp_fullname AS
SELECT emp_getFullName(EMP.id) full_name,
       EMP.id emp_id
  FROM employees EMP,
       persons   PER
 WHERE EMP.person_id = PER.id
 ORDER BY full_name;
