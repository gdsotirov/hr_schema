DELIMITER //

CREATE FUNCTION calcNetSalaryBGBegin( dBaseSalary DECIMAL(10,2),
                                      dStartDate  DATE)
RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  DECLARE dSeniorityYears INTEGER DEFAULT 0;

  IF dStartDate IS NOT NULL THEN
    SET dSeniorityYears = TIMESTAMPDIFF(YEAR, dStartDate, NOW());
  END IF;

  RETURN calcNetSalaryBGForYear(dBaseSalary, dSeniorityYears, YEAR(NOW()));
END //

DELIMITER ;
