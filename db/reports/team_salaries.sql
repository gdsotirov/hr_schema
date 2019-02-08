SELECT EMP.id, concat(PER.first_name, ' ', PER.last_name) emp_name,
       utl_getDateDiffStr(EMP.hire_date, NOW()) inership,
       (SELECT MAX(from_date) from sal_history WHERE employee_id = EMP.id) last_adjustment,
       EMP.salary base_sal, EMP.currency,
       emp_calcSnrtyYrs(EMP.id) snrty_yrs,
       CASE
         WHEN EMP.division_id = 1 /* BG */ THEN
            EMP.salary + caclSnrtyAmt(EMP.salary, emp_calcSnrtyYrs(EMP.id))
         ELSE EMP.salary
       END gross_salary, EMP.currency,
       CASE
         WHEN EMP.division_id = 1 /* BG */ THEN
           calcNetSalaryBG(EMP.salary + caclSnrtyAmt(EMP.salary, emp_calcSnrtyYrs(EMP.id)))
         WHEN EMP.division_id = 4 /* VN */ THEN
           calcNetSalaryVN(EMP.salary)
         WHEN EMP.division_id = 5 /* TN */ THEN
           calcNetSalaryTN(EMP.salary)
         ELSE EMP.salary
       END net_sal,
       EMP.currency,
       ROUND(curr_conversion(CASE
                               WHEN EMP.division_id = 1 /* BG */ THEN
                                 calcNetSalaryBG(EMP.salary + caclSnrtyAmt(EMP.salary, emp_calcSnrtyYrs(EMP.id)))
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
