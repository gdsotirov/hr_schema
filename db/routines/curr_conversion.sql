DELIMITER //

CREATE FUNCTION curr_conversion(amount      DECIMAL,
                                currency    CHAR(3),
                                to_currency CHAR(3),
                                date_for    DATE)
RETURNS DECIMAL(30,10)
BEGIN
  DECLARE conv_rate DECIMAL(10,6)  DEFAULT NULL;
  DECLARE err_msg   VARCHAR(128)   DEFAULT NULL;
  DECLARE result    DECIMAL(30,10) DEFAULT NULL;

  IF date_for IS NULL THEN
    SET date_for := NOW();
  END IF;

  IF currency <> to_currency THEN
    SELECT rate
      INTO conv_rate
      FROM curr_rates
     WHERE from_curr = currency
       AND to_curr = to_currency
       AND for_date <= date_for
     ORDER BY for_date DESC
     LIMIT 1;

    IF conv_rate IS NULL THEN
      SET err_msg := CONCAT('No conversion rate for ', currency, ' to ', to_currency, ' for ', DATE_FORMAT(date_for, '%Y-%m-%d'));
      SIGNAL SQLSTATE '99001' SET MESSAGE_TEXT = err_msg;
    END IF;

    SET result := amount * conv_rate;
  ELSE
    SET result := amount; /* conversion rate is 1 */
  END IF;

  RETURN result;
END //

DELIMITER ;
