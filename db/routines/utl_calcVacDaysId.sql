DELIMITER //

CREATE FUNCTION utl_calcVacDaysId(VacId INTEGER)
RETURNS DECIMAL(5,1)
BEGIN
  DECLARE dStartDate DATETIME DEFAULT NULL;
  DECLARE dEndDate   DATETIME DEFAULT NULL;
  DECLARE tInterval  TIME DEFAULT NULL;

  SELECT from_date,
         to_date
    INTO dStartDate,
         dEndDate
    FROM absences
   WHERE id = VacId;

  RETURN utl_calcVacDays(dStartDate, dEndDate);
END //

DELIMITER ;
