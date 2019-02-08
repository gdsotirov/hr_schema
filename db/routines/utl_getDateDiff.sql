DELIMITER //

CREATE PROCEDURE utl_getDateDiff(IN date1 DATE, IN date2 DATE, OUT yrs INT, OUT mnths INT, OUT dys INT)
  NO SQL
  DETERMINISTIC
BEGIN
  DECLARE years INTEGER;
  DECLARE months INTEGER;
  DECLARE days INTEGER;

  /* Years between */
  SET yrs   := TIMESTAMPDIFF(YEAR, date1, date2);
  /* Months between */
  SET mnths := TIMESTAMPDIFF(MONTH, DATE_ADD(date1, INTERVAL years YEAR), date2);
  /* Days between */
  SET dys   := TIMESTAMPDIFF(DAY, DATE_ADD(date1, INTERVAL years * 12 + months MONTH), date2);
END //

DELIMITER ;
