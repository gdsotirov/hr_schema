SELECT CONCAT(PER1.first_name, ' ', PER1.last_name) per1_name,
       PER1.birth_date,
       PRT.title,
       CONCAT(PER2.first_name, ' ', PER2.last_name) per2_name,
       PR.from_date since,
       PER2.birth_date
  FROM persons PER1,
       person_relations PR,
       person_relation_types PRT,
       persons PER2
 WHERE PR.person1 = PER1.id
   AND PR.person2 = PER2.id
   AND PR.`type` = PRT.id;