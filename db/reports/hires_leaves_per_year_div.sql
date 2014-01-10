SELECT `Year`,
       `DEV`.`name` `Division`,
       SUM( `Hires` ) `Hires`,
       SUM( `Leaves` ) `Leaves`
  FROM (SELECT YEAR(`hire_date`) `Year`,
               `division_id` `Div`,
               COUNT(*) `Hires`,
               0 `Leaves`
          FROM `employees`
         GROUP BY `Year`,
                  `Div`
        UNION
        SELECT YEAR(`leave_date`) `Year`,
               `division_id` `Div`,
               0 `Hires`,
               COUNT(*) `Leaves`
          FROM `employees`
         WHERE `leave_date` IS NOT NULL
         GROUP BY `Year`, `Div`) `hires_and_leaves`,
       `divisions` `DEV`
  WHERE `DEV`.`id` = `hires_and_leaves`.`div`
  GROUP BY `Year`, `Div`
  ORDER BY `Year` DESC, `Div`;