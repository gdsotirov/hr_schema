SELECT H.yr `Year`, hires `Hires`, IFNULL(lefts, 0) `Leaves`
  FROM (SELECT YEAR(hire_date) yr, count(*) hires
          FROM employees
         GROUP BY YEAR(hire_date)
       ) H
       LEFT OUTER JOIN
       (SELECT YEAR(leave_date) yr, count(*) lefts
          FROM employees
         WHERE leave_date IS NOT NULL
         GROUP BY 1
       ) L ON H.yr = L.yr
 ORDER BY H.yr;