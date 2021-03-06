CREATE OR REPLACE VIEW emp_resigned AS
SELECT CONCAT(PER.last_name, ', ', PER.first_name) fullname,
       POS.title last_position,
       DEP.name last_department,
       DVS.name last_division,
       EMP.hire_date hired,
       EMP.leave_date resigned,
       CASE
         WHEN EMP.leave_reason IS NULL
           THEN 'n/a'
         WHEN CHAR_LENGTH(EMP.leave_reason) > 32
           THEN CONCAT(SUBSTR(EMP.leave_reason, 1, 32), '...')
         ELSE
           EMP.leave_reason
       END reason,
       utl_getDateDiffStr(EMP.hire_date, leave_date) service_length,
       utl_getDateDiffStr(PER.birth_date, leave_date) age_at_leave
  FROM persons      PER,
       employees    EMP
       LEFT OUTER JOIN jobs         POS ON POS.id = EMP.job_id
       LEFT OUTER JOIN departments  DEP ON DEP.id = EMP.department_id
       LEFT OUTER JOIN divisions    DVS ON DVS.id = EMP.division_id
 WHERE EMP.leave_date IS NOT NULL
   AND PER.id = EMP.person_id
 ORDER BY resigned DESC, fullname ASC;
