SELECT HL.yr                    `Year`,
       SUM(IFNULL(HL.hires, 0)) `Hires`,
       SUM(IFNULL(HL.lefts, 0)) `Leaves`,
       SUM(IFNULL(HL.hires, 0)) -
       SUM(IFNULL(HL.lefts, 0)) `Balance`
  FROM (SELECT YEAR(hire_date) yr, sum(1) hires, SUM(0) lefts
          FROM employees
         GROUP BY YEAR(hire_date)
        UNION
        SELECT YEAR(leave_date) yr, SUM(0) hires, SUM(1) lefts
          FROM employees
         WHERE leave_date IS NOT NULL
        GROUP BY YEAR(leave_date)
       ) HL
 GROUP BY HL.yr
 ORDER BY HL.yr;
