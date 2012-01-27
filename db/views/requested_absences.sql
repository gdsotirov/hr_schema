CREATE VIEW requested_absences AS
SELECT DEP.name,
       EAB.emp_name,
       JOB.title job_title,
       EAB.abs_type,
       EAB.from_date,
       EAB.to_date,
       EAB.dur_days,
       EAB.deputy,
       EAB.auth_by
  FROM emp_absences  EAB,
       employees     EMP,
       departments   DEP,
       jobs          JOB
 WHERE EMP.id = EAB.emp_id
   AND DEP.id = EMP.department_id
   AND JOB.id = EMP.job_id
   AND EAB.status = 'Requested'
 ORDER BY EAB.to_date,   /* shorter absences first */
          emp_name       /* alphabetic ordering of employees */
;
