DELIMITER //

CREATE FUNCTION calcNetSalaryBGForYear(dBaseSalary      DECIMAL(10,2),
                                       dSeniorityYears  DECIMAL(2),
                                       yForYear         YEAR)
RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  /* Maximal Social Insurance Income */
  DECLARE dMaxInsInc  DECIMAL(10,2) DEFAULT 3000 /* 2019 onwards */;
  /* Percent for State Public Insurance */ 
  DECLARE dPubInsPerc DECIMAL(3,2)  DEFAULT 2.2  /* 2009 onwards */;
  /* Percent for Additional Mandatory Pension Insurance */
  DECLARE dAMPInsPerc DECIMAL(3,2)  DEFAULT 8.38 /* 2018 onwards */;
  /* Percent for Health Insurance */
  DECLARE dHlthInPerc DECIMAL(3,2)  DEFAULT 3.2  /* 2009 onwards */;

  DECLARE dInsAmt         DECIMAL(10,2) DEFAULT dBaseSalary;
  DECLARE dSeniorityAmt   DECIMAL(10,2);
  DECLARE dGrossSalary    DECIMAL(10,2) DEFAULT dBaseSalary;
  DECLARE dSPIAmt         DECIMAL(10,2);
  DECLARE dAMPIAmt        DECIMAL(10,2);
  DECLARE dHIAmt          DECIMAL(10,2);
  DECLARE dTaxableAmt     DECIMAL(10,2);
  DECLARE dIncomeTax      DECIMAL(10,2);
  DECLARE dNetSalary      DECIMAL(10,2);

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
    WHEN yForYear BETWEEN 2022 AND 2023 THEN
      SET dMaxInsInc = 3400;
    WHEN yForYear = 2024 THEN
      SET dMaxInsInc = 3750;
    WHEN yForYear = 2025 THEN
      SET dMaxInsInc = 4130;
    WHEN yForYear = 2026 THEN
      SET dMaxInsInc = 4430;
    WHEN yForYear = 2027 THEN
      SET dMaxInsInc = 4730;
    WHEN yForYear >= 2028 THEN
      SET dMaxInsInc = 5030;
  END CASE;

  CASE
    WHEN yForYear = 2009 THEN
      SET dAMPInsPerc = 7.6; /* pension - 5.8, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
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

  /* Calculate and add seniority to gross salary */
  IF dSeniorityYears > 0 THEN
    SET dSeniorityAmt   = ROUND(dBaseSalary * calcSnrtyPrcnt(IFNULL(dSeniorityYears, 0)) / 100, 2);
    SET dGrossSalary    = dGrossSalary + dSeniorityAmt;
  END IF;

  /* Determine the base */
  IF dBaseSalary > dMaxInsInc THEN
    SET dInsAmt = dMaxInsInc;
  END IF;

  /* Calculate State Public Insurance */
  SET dSPIAmt  = ROUND(dInsAmt * dPubInsPerc / 100, 2);

  /* Calculate Additional Mandatory Pension Insurance */
  SET dAMPIAmt = ROUND(dInsAmt * dAMPInsPerc / 100, 2);

  /* Calculate Health Insurance */
  SET dHIAmt   = ROUND(dInsAmt * dHlthInPerc / 100, 2);

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

  /* Calculate Net Salary */
  SET dNetSalary = ROUND(dTaxableAmt - dIncomeTax, 2);

  RETURN dNetSalary;
END //

DELIMITER ;
