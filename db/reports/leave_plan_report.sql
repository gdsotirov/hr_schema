SELECT CONCAT(PER.first_name, ' ', PER.last_name) `Name`,
       for_year `Year`,
       MONTH(VAC.from_date) `Month`,
       DATE_FORMAT(from_date, '%d/%m/%Y') `Date from`,
       DATE_FORMAT(to_date, '%d/%m/%Y') `Date to`,
       DATEDIFF(to_date, from_date) + 1 `Days`
  FROM absences  VAC,
       employees EMP,
       persons   PER
 WHERE VAC.`type` = 11
   AND VAC.for_year = '2014'
   AND EMP.id = VAC.employee_id
   AND PER.id = EMP.person_id
   AND VAC.`status` = 'Authorized'
 ORDER BY `Name`, VAC.from_date;