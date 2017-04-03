SELECT EMP.id, SH.from_date, SH.amount, SH.currency, SH.granted_on, GBY.full_name granted_by, SH.approved_on, ABY.full_name approved_by
  FROM sal_history  SH,
       employees    EMP,
       persons      PER,
       emp_fullname GBY,
       emp_fullname ABY
 WHERE SH.employee_id = EMP.id
   AND EMP.person_id = PER.id
   AND SH.granted_by = GBY.emp_id
   AND SH.approved_by = ABY.emp_id
   AND CONCAT(PER.first_name, ' ',
              CASE WHEN PER.middle_name IS NULL THEN '' ELSE CONCAT(PER.middle_name, ' ') END,
              PER.last_name) LIKE '%'
 ORDER BY from_date DESC;
