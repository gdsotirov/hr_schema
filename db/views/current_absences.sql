CREATE OR REPLACE VIEW current_absences AS
SELECT DEP.name,
       EAB.emp_name,
       JOB.title job_title,
       EAB.abs_type,
       EAB.from_date,
       EAB.to_date,
       DATEDIFF(EAB.to_date, CURDATE()) days_left,
       EAB.deputy,
       EAB.auth_by
  FROM emp_absences  EAB,
       employees     EMP,
       departments   DEP,
       jobs          JOB
 WHERE EMP.id = EAB.emp_id
   AND DEP.id = EMP.department_id
   AND JOB.id = EMP.job_id
   AND EAB.from_date <= CURDATE()
   AND EAB.to_date >= CURDATE()
   AND EAB.status = 'Authorized'
 ORDER BY EAB.to_date,   /* shorter absences first */
          dur_days DESC, /* longer durations first */
          emp_name       /* alphabetic ordering of employees */
;
