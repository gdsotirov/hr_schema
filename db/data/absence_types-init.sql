INSERT INTO `absence_types`
  (`id`, `title`, `description`, days_type)
VALUES
  ( 1, 'Paid leave'              , NULL, 'work'),
  ( 2, 'Unpaid leave with auth'  , NULL, 'work'),
  ( 3, 'Unpaid leave w/o auth'   , NULL, 'work'),
  ( 4, 'Others, with certificate', 'Please, specify type and number of the legal document', 'work'),
  ( 5, 'Business trip'           , NULL, 'cal' ),
  ( 6, 'Work from home'          , NULL, 'work'),
  ( 7, 'Sick leave'              , 'Please, specify the details of the medical document', 'cal'),
  ( 8, 'Maternity leave'         , NULL, 'cal' ),
  ( 9, 'Parternity leave'        , NULL, 'cal' ),
  (10, 'Compensation'            , 'Compensations (hours minus/hours plus) for short absences from office', 'work'),
  (11, 'Planned paid leave'      , 'Planning', 'work');
