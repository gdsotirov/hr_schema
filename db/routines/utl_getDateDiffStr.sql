DELIMITER //

CREATE FUNCTION utl_getDateDiffStr(date1 DATE, date2 DATE)
  RETURNS VARCHAR(30)
  NO SQL
  DETERMINISTIC 
BEGIN
  DECLARE years INTEGER;
  DECLARE months INTEGER;
  DECLARE days INTEGER;

  /* Years between */
  SET years = TIMESTAMPDIFF(YEAR, date1, date2);
  /* Months between */
  SET months := TIMESTAMPDIFF(MONTH, DATE_ADD(date1, INTERVAL years YEAR), date2);
  /* Days between */
  SET days := TIMESTAMPDIFF(DAY, DATE_ADD(date1, INTERVAL years * 12 + months MONTH), date2);

  RETURN CONCAT(years, 'y ', months, 'm ', days, 'd');
END //

DELIMITER ;
