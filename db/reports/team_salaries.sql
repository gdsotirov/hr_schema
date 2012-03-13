select EMP.id, concat(PER.first_name, ' ', PER.last_name),
       EMP.salary, calcNetSalaryBG(EMP.salary) net_sal
  from employees EMP,
       persons   PER
 WHERE EMP.person_id = PER.id
   and EMP.department_id = 1
   and EMP.leave_date IS NULL
   and EMP.division_id = 1;