SELECT dat.yr_mnth_1,
       (SELECT COUNT(*)
          FROM employees EMP
         WHERE EMP.hire_date <= DATE(dat.yr_mnth_1)
           AND (EMP.leave_date IS NULL
                OR (DATE(dat.yr_mnth_1) = DATE(NOW()) AND EMP.leave_date > NOW())
                OR EMP.leave_date > LAST_DAY(dat.yr_mnth_1)
               )
       ) emp_cnt
  FROM (WITH RECURSIVE years AS
        (
         SELECT 1989 AS n
         UNION ALL
         SELECT n + 1 FROM years
          WHERE n < YEAR(NOW())
        ),
        months AS
        (
         SELECT 1 AS n
         UNION ALL
         SELECT n + 1 FROM months
          WHERE n <= 12
        )
        SELECT STR_TO_DATE(CONCAT(YR.n, '-', MTH.n, '-', 1), '%Y-%m-%d') yr_mnth_1
          FROM years  YR,
               months MTH
         WHERE STR_TO_DATE(CONCAT(YR.n, '-', MTH.n, '-', 1), '%Y-%m-%d') <= CURDATE()
        UNION
        SELECT CURDATE() yr_mnth_1
       ) dat
 ORDER BY dat.yr_mnth_1 ASC;
