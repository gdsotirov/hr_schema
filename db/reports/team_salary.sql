select DEP.name, SUM(EMP.salary) gross, SUM(calcNetSalaryBG(EMP.salary)) net
  from employees   EMP,
       departments DEP
 WHERE EMP.department_id = DEP.id
   AND DEP.id = 1
   AND EMP.division_id = 1;