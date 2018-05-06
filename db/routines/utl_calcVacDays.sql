DELIMITER //

CREATE FUNCTION utl_calcVacDays(dStartDate DATETIME, dEndDate DATETIME)
  RETURNS DECIMAL(5,1)
  NO SQL
BEGIN
  DECLARE tInterval  TIME DEFAULT NULL;

  /* Whole days */
  IF DATE_FORMAT(dStartDate, '%H:%i') = '00:00'
     AND DATE_FORMAT(dEndDate, '%H:%i') = '00:00'
  THEN
    RETURN DATEDIFF(dEndDate, dStartDate) + 1;
  END IF;

  /* half day */
  IF DATE_FORMAT(dStartDate, '%H:%i') != '00:00'
     AND DATE_FORMAT(dEndDate, '%H:%i') != '00:00'
     AND DATEDIFF(dEndDate, dStartDate) = 0
  THEN
    SET tInterval := TIMEDIFF(dEndDate, dStartDate);
    IF TIME_FORMAT(tInterval, '%H:%i') = '04:00' THEN
      RETURN 0.5;
    ELSE
      RETURN NULL;
    END IF;
  END IF;

  RETURN NULL;
END //

DELIMITER ;
