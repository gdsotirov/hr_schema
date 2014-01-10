SELECT `Year`          `Year`,
       `DEP`.`name`    `Department`,
       SUM( `Hires` )  `Hires`,
       SUM( `Leaves` ) `Leaves`
  FROM (SELECT YEAR(`hire_date`)  `Year`,
               `department_id`    `Dep`,
               COUNT(*)           `Hires`,
               0                  `Leaves`
          FROM `employees`
         GROUP BY `Year`,
                  `Dep`
        UNION
        SELECT YEAR(`leave_date`) `Year`,
               `department_id`    `Dep`,
               0                  `Hires`,
               COUNT(*)           `Leaves`
          FROM `employees`
         WHERE `leave_date` IS NOT NULL
         GROUP BY `Year`, `Dep`) `HL`,
       `departments` `DEP`
  WHERE `DEP`.`id` = `HL`.`Dep`
    AND `Year` = '2013'
  GROUP BY `Year`, `Department`
  ORDER BY `Hires` DESC;
  /*ORDER BY `Year` DESC, `Department`;*/