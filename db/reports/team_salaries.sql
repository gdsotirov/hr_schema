SELECT EMP.id, concat(PER.first_name, ' ', PER.last_name) emp_name,
       utl_getDateDiffStr(EMP.hire_date, NOW()) inership,
       EMP.salary base_sal, EMP.currency,
       CASE
         WHEN EMP.division_id = 1 /* BG */ THEN
           calcNetSalaryBG(EMP.salary)
         WHEN EMP.division_id = 4 /* VN */ THEN
           calcNetSalaryVN(EMP.salary)
         WHEN EMP.division_id = 5 /* TN */ THEN
           calcNetSalaryTN(EMP.salary)
         ELSE EMP.salary
       END net_sal,
       EMP.currency,
       ROUND(curr_conversion(CASE
                               WHEN EMP.division_id = 1 /* BG */ THEN
                                 calcNetSalaryBG(EMP.salary)
                               WHEN EMP.division_id = 4 /* VN */ THEN
                                 calcNetSalaryVN(EMP.salary)
                               WHEN EMP.division_id = 5 /* TN */ THEN
                                 calcNetSalaryTN(EMP.salary)
                               ELSE EMP.salary
                             END, EMP.currency, 'BGN', NOW()), 2) net_sal_in_bgn
  FROM employees EMP,
       persons   PER
 WHERE EMP.person_id = PER.id
   AND EMP.department_id = 1
   AND EMP.leave_date IS NULL
 /*AND EMP.division_id = 1*/
 ORDER BY net_sal_in_bgn DESC, EMP.hire_date;