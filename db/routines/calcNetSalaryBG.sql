DELIMITER //

CREATE FUNCTION calcNetSalaryBG(dBaseSalary     DECIMAL(10,2),
                                dSeniorityYears DECIMAL(2))
RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  RETURN calcNetSalaryBGForYear(dBaseSalary, IFNULL(dSeniorityYears, 0), YEAR(NOW()));
END //

DELIMITER ;
