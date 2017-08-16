SELECT dat.yr_mnth_1,
       (SELECT COUNT(*)
          FROM employees EMP
         WHERE EMP.hire_date <= dat.yr_mnth_1
           AND (EMP.leave_date IS NULL OR EMP.leave_date > dat.yr_mnth_1)
       ) emp_cnt
  FROM (SELECT hire_date yr_mnth_1
          FROM employees
        UNION
        SELECT leave_date yr_mnth_1
          FROM employees
         WHERE leave_date IS NOT NULL
       ) dat
 ORDER BY dat.yr_mnth_1 ASC;