INSERT INTO person_relation_types
  (`id`, title, reverse_id)
VALUES
  ('aunt'       , 'Aunt'                      , 'niece'),
  ('b-in-law'   , 'Brother-in-law'            , NULL),
  ('child'      , 'Child'                     , 'parent'),
  ('concestor'  , 'Last Common Ancestor (LCA)', NULL),
  ('cousin'     , 'Cousin'                    , NULL),
  ('f-in-law'   , 'Father-in-law'             , NULL),
  ('grandchild' , 'Grandchild'                , 'grandparent'),
  ('grandparent', 'Grandparent'               , 'grandchild'),
  ('m-in-law'   , 'Mother-in-law'             , NULL),
  ('nephew'     , 'Nephew'                    , 'uncle'),
  ('niece'      , 'Niece'                     , 'aunt'),
  ('parent'     , 'Parent'                    , 'child'),
  ('s-in-law'   , 'Sister-in-law'             , NULL),
  ('sibling'    , 'Sigling'                   , NULL),
  ('spouse'     , 'Spouse'                    , NULL),
  ('uncle'      , 'Uncle'                     , 'nephew');
