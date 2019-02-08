DELIMITER //

CREATE FUNCTION utl_getDateDiffStr(date1 DATE, date2 DATE)
  RETURNS VARCHAR(30)
  NO SQL
  DETERMINISTIC 
BEGIN
  DECLARE years INTEGER;
  DECLARE months INTEGER;
  DECLARE days INTEGER;

  CALL utl_getDateDiff(date1, date2, years, months, days);

  RETURN CONCAT(years, 'y ', months, 'm ', days, 'd');
END //

DELIMITER ;
