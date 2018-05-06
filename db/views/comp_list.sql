CREATE OR REPLACE VIEW comp_list AS
SELECT CONCAT(PER.first_name, ' ', PER.last_name) `Name`,
       DATE_FORMAT(AB.from_date, '%d/%m/%Y') `Day`,
       TIME_FORMAT(AB.from_date, '%H:%i') `Start`,
       TIME_FORMAT(AB.to_date, '%H:%i') `End`,
       SEC_TO_TIME(TIME_TO_SEC(TIMEDIFF(AB.to_date, AB.from_date))) `Total`,
       CASE
         WHEN AB.description LIKE 'Proj%' THEN
           REPLACE(SUBSTR(AB.description, 1, INSTR(AB.description, ';') - 1), 'Projects: ', '')
         WHEN AB.description LIKE 'Offline%' THEN
           LTRIM(SUBSTR(AB.description, INSTR(AB.description, ':') + 1))
         ELSE AB.description
       END `Projects`,
       CASE
         WHEN AB.description LIKE 'Proj%' THEN
           LTRIM(REPLACE(SUBSTR(AB.description, INSTR(AB.description, ';') + 1), 'Tasks: ', ''))
         WHEN AB.description LIKE 'Offline%' THEN
           ''
         ELSE AB.description
       END `Tasks`
  FROM absences  AB,
       employees EMP,
       persons   PER
 WHERE AB.employee_id = EMP.id
   AND EMP.person_id = PER.id
   AND AB.type = 10
 ORDER BY AB.from_date;
