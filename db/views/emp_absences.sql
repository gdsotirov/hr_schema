CREATE OR REPLACE VIEW emp_absences AS
SELECT EMP.id emp_id,
       CONCAT(PER.last_name, ', ', PER.first_name) emp_name,
       ABT.title abs_type,
       ABR.from_date,
       ABR.to_date,
       ABR.for_year,
       utl_calcVacDaysId(ABR.id) dur_days,
       CASE
         WHEN DPTY.id IS NOT NULL THEN
           CONCAT(DPP.last_name, ', ', DPP.first_name)
         ELSE 'n/a'
       END deputy,
       CONCAT(APP.last_name, ', ', APP.first_name) auth_by,
       ABR.status
  FROM employees     EMP,
       persons       PER,
       absences      ABR
       LEFT OUTER JOIN employees DPTY ON ABR.deputy_id = DPTY.id
       LEFT OUTER JOIN persons   DPP  ON DPTY.person_id = DPP.id,
       absence_types ABT,
       employees     AUTH,
       persons       APP
 WHERE EMP.id = ABR.employee_id
   AND EMP.person_id = PER.id
   AND ABR.type = ABT.id
   AND AUTH.id = ABR.authorized_by
   AND AUTH.person_id = APP.id
   AND ABR.type NOT IN (10, 11) /* compensations and planned leave */
;
