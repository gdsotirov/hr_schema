INSERT INTO `absence_types`
  (`id`, `title`, `description`)
VALUES
  ( 1, 'Paid leave'              , NULL),
  ( 2, 'Unpaid leave with auth'  , NULL),
  ( 3, 'Unpaid leave w/o auth'   , NULL),
  ( 4, 'Others, with certificate', 'Please, specify type and number of the legal document'),
  ( 5, 'Business trip'           , NULL),
  ( 6, 'Work from home'          , NULL),
  ( 7, 'Sick leave'              , 'Please, specify the details of the medical document'),
  ( 8, 'Maternity leave'         , NULL),
  ( 9, 'Parternity leave'        , NULL),
  (10, 'Compensation'            , 'Compensations (hours minus/hours plus) for short absences from office'),
  (11, 'Planned paid leave'      , 'Planning');
