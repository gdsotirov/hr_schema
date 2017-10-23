SELECT CONCAT(PER.first_name, ' ',
              CASE
                WHEN PER.middle_name IS NOT NULL THEN CONCAT(PER.middle_name, ' ')
                ELSE ''
              END,
              PER.last_name) nam,
       PER.linkedin_profile
  FROM persons PER
       LEFT OUTER JOIN employees EMP on EMP.person_id = PER.id
 WHERE EMP.id IS NULL;