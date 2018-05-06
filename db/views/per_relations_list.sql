CREATE OR REPLACE VIEW per_relations_list AS
SELECT CONCAT(P1.last_name, ', ', P1.first_name) p1_name,
       CONCAT('is ', PRT.title, ' of') relation,
       CONCAT(P2.last_name, ', ', P2.first_name) p2_name,
       CASE
         WHEN from_date IS NOT NULL THEN
           CONCAT('since ', DATE_FORMAT(PR.from_date, '%Y-%m-%d'))
       END since
  FROM person_relations PR,
       person_relation_types PRT,
       persons P1,
       persons P2
 WHERE PR.type = PRT.id
   AND PR.person1 = P1.id
   AND PR.person2 = P2.id
;
