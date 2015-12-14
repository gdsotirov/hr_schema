SELECT date_field
  FROM (SELECT MAKEDATE(YEAR(NOW()),1) + INTERVAL (MONTH(NOW())-1) MONTH + INTERVAL daynum DAY date_field
          FROM (SELECT t*10+u daynum
                  FROM (SELECT 0 t
                         UNION SELECT 1
                         UNION SELECT 2
                         UNION SELECT 3) A,
                       (SELECT 0 u
                         UNION SELECT 1
                         UNION SELECT 2
                         UNION SELECT 3
                         UNION SELECT 4
                         UNION SELECT 5
                         UNION SELECT 6
                         UNION SELECT 7
                         UNION SELECT 8
                         UNION SELECT 9) B
                  ORDER BY daynum
               ) AA
         WHERE daynum <= 30
      ) AAA
 WHERE 1=1/*MONTH(date_field) = MONTH(NOW())*/;
