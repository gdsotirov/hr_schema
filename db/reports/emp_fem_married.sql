select *
  from persons   PER,
       employees EMP
 WHERE (   PER.maiden_name IS NOT NULL
        OR PER.sex = 'female' AND INSTR(PER.last_name, '-')
       )
   AND PER.id = EMP.person_id
   AND EMP.leave_date IS NULL
 order by first_name, last_name;