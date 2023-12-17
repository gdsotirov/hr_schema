DELIMITER //

CREATE FUNCTION calcNetSalaryBG(dBaseSalary DECIMAL,
                                dSeniorityYears DECIMAL)
RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  RETURN calcNetSalaryBGForYear(dBaseSalary, IFNULL(dSeniorityYears, 0), YEAR(NOW()));
END //

DELIMITER ;
