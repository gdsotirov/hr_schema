DELIMITER //

CREATE FUNCTION calcNetSalaryBGForYear(dBaseSalary      DECIMAL(10,2),
                                       dSeniorityYears  DECIMAL(2),
                                       yForYear         YEAR)
RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  /* Maximal Social Insurance Income */
  DECLARE dMaxInsInc  DECIMAL(10,2) DEFAULT 4130 /* 2025 onwards */;
  /* Percent for State Public Insurance */
  DECLARE dPubInsPerc DECIMAL(3,2)  DEFAULT 2.2  /* 2009 onwards */;
  /* Percent for Additional Mandatory Pension Insurance */
  DECLARE dAMPInsPerc DECIMAL(4,2)  DEFAULT 8.38 /* 2018 onwards */;
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
    WHEN yForYear BETWEEN 2008 AND 2012 THEN
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
      SET dMaxInsInc = 2352;
    WHEN yForYear = 2027 THEN
      SET dMaxInsInc = 2500; /* speculation */
    WHEN yForYear >= 2028 THEN
      SET dMaxInsInc = 2650; /* speculation */
  END CASE;

  CASE
    WHEN yForYear = 2008 THEN
      SET dAMPInsPerc = 8.6; /* pension - 6.8, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2;
      SET dHlthInPerc = 2.4;
    WHEN yForYear = 2009 THEN
      SET dAMPInsPerc = 7.6; /* pension - 5.8, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear = 2010 THEN
      SET dAMPInsPerc = 6.7; /* pension - 4.9, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear BETWEEN 2011 AND 2016 THEN
      SET dAMPInsPerc = 7.5; /* pension - 5.7, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear = 2017 THEN
      SET dAMPInsPerc = 7.94; /* pension - 6.14, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear BETWEEN 2018 AND 2025 THEN
      SET dAMPInsPerc = 8.38; /* pension - 6.58, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear BETWEEN 2026 AND 2027 THEN
      SET dAMPInsPerc = 9.26; /* pension - 7.46, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
    WHEN yForYear >= 2028 THEN
      SET dAMPInsPerc = 9.7; /* pension - 7.9, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2.2;
      SET dHlthInPerc = 3.2;
  END CASE;

  /* Bulgaria adopts Euro as of 2026-01-01 */
  IF yForYear >= 2026 THEN
    SET dBaseSalary   = utl_roundUp(dBaseSalary / 1.95583, 2);
    SET dGrossSalary  = utl_roundUp(dGrossSalary / 1.95583, 2);
  END IF;

  /* Calculate and add seniority to gross salary */
  IF dSeniorityYears > 0 THEN
    SET dSeniorityAmt = utl_roundUp(dBaseSalary * calcSnrtyPrcnt(IFNULL(dSeniorityYears, 0)) / 100, 2);
    SET dGrossSalary  = dGrossSalary + dSeniorityAmt;
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
