SELECT yr `Year`, SUM(hires) `Hires`, SUM(`leaves`) `Leaves`, SUM(hires) - SUM(`leaves`) Balance
  FROM (SELECT YEAR(hire_date) yr, count(*) hires, 0        `leaves`
          FROM employees
         GROUP BY yr
        UNION
        SELECT YEAR(leave_date) yr, 0       hires, count(*) `leaves`
          FROM employees
         WHERE leave_date IS NOT NULL
         GROUP BY yr
       ) HL
 GROUP BY yr
 ORDER BY yr DESC;
