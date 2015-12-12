DELIMITER //

CREATE FUNCTION calcNetSalaryBG(dGrossSalary DECIMAL) RETURNS DECIMAL(10,2)
BEGIN
  DECLARE dBaseSal    DECIMAL(10,2);
  DECLARE dSPIAmt     DECIMAL(10,2);
  DECLARE dAMPIAmt    DECIMAL(10,2);
  DECLARE dHIAmt      DECIMAL(10,2);
  DECLARE dTaxableAmt DECIMAL(10,2);
  DECLARE dIncomeTax  DECIMAL(10,2);
  DECLARE dNetSalary  DECIMAL(10,2);

  /* Determine the base */
  IF dGrossSalary > 2600.0 THEN
    SET dBaseSal = 2600.0;
  ELSE
    SET dBaseSal = dGrossSalary;
  END IF;

  /* Calcualte State Public Insurance */
  SET dSPIAmt  = ROUND(dBaseSal * 7.5 / 100, 2);

  /* Calculate Additional Mandatory Pension Insurance */
  SET dAMPIAmt = ROUND(dBaseSal * 2.2 / 100, 2);

  /* Calculate Health Insurance */
  SET dHIAmt   = ROUND(dBaseSal * 3.2 / 100);

  /* Calculate Taxable Amount */
  SET dTaxableAmt = ROUND(dGrossSalary - dSPIAmt - dAMPIAmt - dHIAmt, 1);

  /* Calculate Income Tax *
  CASE
    WHEN dTaxableAmt < 180.0 THEN
      SET dIncomeTax = 0.0;
    WHEN dTaxableAmt >= 180.0 AND dTaxableAmt < 250.0 THEN
      SET dIncomeTax = ROUND((dTaxableAmt - 180.0) * 20 / 100, 1);
    WHEN dTaxableAmt >= 250.0 AND dTaxableAmt < 600.0 THEN
      SET dIncomeTax = ROUND((dTaxableAmt - 250.0) * 22 / 100, 1)
                        + ROUND((250 - 180) * 20 / 100, 1);
    WHEN dTaxableAmt > 600.0 THEN
      SET dIncomeTax = ROUND((dTaxableAmt - 600.0) * 24 / 100, 1)
                        + ROUND((600 - 250) * 22 / 100, 1)
                        + ROUND((250 - 180) * 20 / 100, 1);
  END CASE;*/
  SET dIncomeTax = dTaxableAmount * 10 / 100;

  /* Calcualte Net Salary */
  SET dNetSalary = dGrossSalary - dSPIAmt - dAMPIAmt - dHIAmt - dIncomeTax;

  RETURN dNetSalary;
END //

DELIMITER ;
