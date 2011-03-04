SELECT CONCAT(EMP.last_name, ', ', EMP.first_name) full_name,
       EMP.birth_date,
       utl_getDateDiffStr(EMP.birth_date, CURDATE()) age
  FROM employees EMP
 WHERE birth_date IS NOT NULL
   AND CURDATE() = STR_TO_DATE(CONCAT(YEAR(CURDATE()), '-', MONTH(EMP.birth_date), '-', DAY(EMP.birth_date)), '%Y-%m-%d');