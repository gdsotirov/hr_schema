DELIMITER //

CREATE FUNCTION calcNetSalaryBGForYear( dBaseSalary     DECIMAL(10,2),
                                        dSeniorityYears DECIMAL(2),
                                        yForYear        YEAR)
RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  RETURN calcNetSalaryBGForYearMonth(dBaseSalary,
    CASE WHEN dSeniorityYears IS NULL THEN 0            ELSE dSeniorityYears END,
    CASE WHEN yForYear        IS NULL THEN YEAR(NOW())  ELSE yForYear END,
    MONTH(NOW()));
END //

DELIMITER ;
