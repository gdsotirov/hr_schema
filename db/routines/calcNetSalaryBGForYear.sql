DELIMITER //

CREATE FUNCTION calcNetSalaryBGForYear(dGrossSalary DECIMAL, yForYear YEAR) RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  /* Maximal Social Insurance Income */
  DECLARE dMaxInsInc  DECIMAL(10,2) DEFAULT 3000 /* 2019 onwards */;
  /* Percent for State Public Insurance */ 
  DECLARE dPubInsPerc DECIMAL(3,2)  DEFAULT 2.2  /* 2010 onwards */;
  /* Percent for Additional Mandatory Pension Insurance */
  DECLARE dAMPInsPerc DECIMAL(3,2)  DEFAULT 8.38 /* 2018 onwards */;
  /* Percent for Health Insurance */
  DECLARE dHlthInPerc DECIMAL(3,2)  DEFAULT 3.2  /* 2010 onwards */;

  DECLARE dBaseSal    DECIMAL(10,2);
  DECLARE dSPIAmt     DECIMAL(10,2);
  DECLARE dAMPIAmt    DECIMAL(10,2);
  DECLARE dHIAmt      DECIMAL(10,2);
  DECLARE dTaxableAmt DECIMAL(10,2);
  DECLARE dIncomeTax  DECIMAL(10,2);
  DECLARE dNetSalary  DECIMAL(10,2);

  /* Determine Maximal Social Insurance Income per year */
  CASE
    WHEN yForYear BETWEEN 2010 AND 2012 THEN
      SET dMaxInsInc = 2000;
    WHEN yForYear = 2013 THEN
      SET dMaxInsInc = 2200;
    WHEN yForYear = 2014 THEN
      SET dMaxInsInc = 2400;
    WHEN yForYear BETWEEN 2015 AND 2018 THEN
      SET dMaxInsInc = 2600;
    WHEN yForYear BETWEEN 2019 AND 2021 THEN
      SET dMaxInsInc = 3000;
    WHEN yForYear >= 2022 THEN
      SET dMaxInsInc = 3400;
  END CASE;

  CASE
    WHEN yForYear = 2010 THEN
      SET dPubInsPerc = 2.2;
      SET dAMPInsPerc = 6.7;
      SET dHlthInPerc = 3.2;
    WHEN yForYear >= 2011 AND yForYear <= 2016 THEN
      SET dPubInsPerc = 2.2;
      SET dAMPInsPerc = 7.5;
      SET dHlthInPerc = 3.2;
    WHEN yForYear >= 2017 AND yForYear < 2018 THEN
      SET dPubInsPerc = 2.2;
      SET dAMPInsPerc = 7.94;
      SET dHlthInPerc = 3.2;
    WHEN yForYear >= 2018 THEN
      SET dPubInsPerc = 2.2;
      SET dAMPInsPerc = 8.38;
      SET dHlthInPerc = 3.2;
  END CASE;

  /* Determine the base */
  IF dGrossSalary > dMaxInsInc THEN
    SET dBaseSal = dMaxInsInc;
  ELSE
    SET dBaseSal = dGrossSalary;
  END IF;

  /* Calcualte State Public Insurance */
  SET dSPIAmt  = ROUND(dBaseSal * dPubInsPerc / 100, 2);

  /* Calculate Additional Mandatory Pension Insurance */
  SET dAMPIAmt = ROUND(dBaseSal * dAMPInsPerc / 100, 2);

  /* Calculate Health Insurance */
  SET dHIAmt   = ROUND(dBaseSal * dHlthInPerc / 100, 2);

  /* Calculate Taxable Amount */
  SET dTaxableAmt = ROUND(dGrossSalary - dSPIAmt - dAMPIAmt - dHIAmt, 2);

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
  /* Flat Total Income Tax of 10% */
  SET dIncomeTax = ROUND(dTaxableAmt * 10 / 100, 2);

  /* Calcualte Net Salary */
  SET dNetSalary = ROUND(dGrossSalary - dSPIAmt - dAMPIAmt - dHIAmt - dIncomeTax, 2);

  RETURN dNetSalary;
END //

DELIMITER ;
