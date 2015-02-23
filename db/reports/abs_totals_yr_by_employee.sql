SELECT CONCAT(PER.first_name, ' ', PER.last_name) emp_name,
       ATD.for_year,
       SUM(IF(ABT.id = 1 , ATD.days, 0)) `Paid`,
       SUM(IF(ABT.id = 13, ATD.days, 0)) `KP`
  FROM absence_totals ATD,
       absence_types  ABT,
       employees      EMP,
       persons        PER
 WHERE ATD.type_id     = ABT.id
   AND EMP.person_id   = PER.id
   AND (   ATD.employee_id = EMP.id
        OR (    ATD.division_id = EMP.division_id
            AND NOT EXISTS (SELECT 1
                              FROM absence_totals
                             WHERE employee_id = EMP.id
                               AND type_id     = ATD.type_id
                               AND for_year    = ATD.for_year
                           )
           )
       )
   AND EMP.id = 1
   AND ATD.from_date >= EMP.hire_date
   AND ATD.from_date <= IF(EMP.leave_date IS NOT NULL, EMP.leave_date, NOW())
 GROUP BY EMP.id, ATD.for_year;