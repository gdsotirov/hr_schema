DELIMITER //

CREATE FUNCTION calcNetSalaryVN(dGrossSalary DECIMAL) RETURNS DECIMAL(10,2)
BEGIN
  /* See http://nicvn.com/net-gross-salary-converter.html */
  /* See https://www.hr2b.com/salary-calculator */
  DECLARE dSocIns    DECIMAL(10,2);
  DECLARE dHlthIns   DECIMAL(10,2);
  DECLARE dUnEmplIns DECIMAL(10,2);
  DECLARE dTrdeUn    DECIMAL(10,2);
  DECLARE dNetSalary DECIMAL(10,2);

  SET dSocIns    = dGrossSalary * 8 / 100;
  SET dHlthIns   = dGrossSalary * 1.5 / 100;
  SET dUnEmplIns = dGrossSalary * 1 / 100;
  SET dTrdeUn    = dGrossSalary * 1 / 100;

  SET dNetSalary = dGrossSalary - dSocIns - dHlthIns - dUnEmplIns - dTrdeUn;

  RETURN dNetSalary;
END //

DELIMITER ;
