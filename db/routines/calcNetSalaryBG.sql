DELIMITER //

CREATE FUNCTION calcNetSalaryBG(dGrossSalary DECIMAL) RETURNS DECIMAL(10,2)
BEGIN
  RETURN hr_schema.calcNetSalaryBGForYear(dGrossSalary, YEAR(NOW()));
END //

DELIMITER ;
