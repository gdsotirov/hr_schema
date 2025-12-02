DELIMITER //

CREATE FUNCTION calcNetSalaryBGForYearMonth(dBaseSalary      DECIMAL(10,2),
                                            dSeniorityYears  DECIMAL(2),
                                            yForYear         YEAR,
                                            yForMonth        INTEGER)
RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  DECLARE yr_bf_2008  CONDITION FOR SQLSTATE '92008';
  DECLARE wrong_month CONDITION FOR SQLSTATE '91012';
  /* Maximal Social Insurance Income */
  DECLARE dMaxInsInc  DECIMAL(10,2) DEFAULT 2352 /* 2026 onwards in EUR */;
  /* Percent for State Public Insurance */
  DECLARE dPubInsPerc DECIMAL(3,2)  DEFAULT 2.2  /* 2009 onwards */;
  /* Percent for Additional Mandatory Pension Insurance */
  DECLARE dAMPInsPerc DECIMAL(4,2)  DEFAULT 9.26 /* 2026 onwards */;
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
  DECLARE dYrMonth        INTEGER;

  IF yForYear IS NULL THEN
    SET yForYear = YEAR(NOW());
  ELSEIF yForYear < 2008 THEN
    SIGNAL yr_bf_2008
      SET MESSAGE_TEXT = 'Calculation is defined since year 2008 onwards only!';
  END IF;

  IF yForMonth IS NULL THEN
    SET yForMonth = MONTH(NOW());
  ELSEIF yForMonth < 1 OR yForMonth > 12 THEN
    SIGNAL wrong_month
      SET MESSAGE_TEXT = 'Wrong month! Only integer numbers between 1 and 12 allowed.';
  END IF;

  SET dYrMonth = yForYear * 100 + yForMonth;

  /* Determine Maximal Social Insurance Income per year */
  CASE
    WHEN dYrMonth BETWEEN 200801 AND 201212 THEN
      SET dMaxInsInc = 2000; /* BGN */
    WHEN dYrMonth BETWEEN 201301 AND 201312 THEN
      SET dMaxInsInc = 2200; /* BGN */
    WHEN dYrMonth BETWEEN 201401 AND 201412 THEN
      SET dMaxInsInc = 2400; /* BGN */
    WHEN dYrMonth BETWEEN 201501 AND 201812 THEN
      SET dMaxInsInc = 2600; /* BGN */
    WHEN dYrMonth BETWEEN 201901 AND 202203 THEN
      SET dMaxInsInc = 3000; /* BGN */
    WHEN dYrMonth BETWEEN 202204 AND 202312 THEN
      SET dMaxInsInc = 3400; /* BGN */
    WHEN dYrMonth BETWEEN 202401 AND 202503 THEN
      SET dMaxInsInc = 3750; /* BGN */
    WHEN dYrMonth BETWEEN 202504 AND 202512 THEN
      SET dMaxInsInc = 4130; /* BGN */
    WHEN dYrMonth BETWEEN 202601 AND 202612 THEN
      SET dMaxInsInc = 2352; /* EUR */
    WHEN dYrMonth BETWEEN 202701 AND 202712 THEN
      SET dMaxInsInc = 2500; /* speculation */
    WHEN dYrMonth >= 202801 THEN
      SET dMaxInsInc = 2650; /* speculation */
  END CASE;

  CASE
    WHEN yForYear = 2008 THEN
      SET dAMPInsPerc = 8.6; /* pension - 6.8, illness - 1.4, unemployment - 0.4 */
      SET dPubInsPerc = 2;
      SET dHlthInPerc = 2.4;
    WHEN yForYear = 2009 THEN
      SET dAMPInsPerc = 7.6; /* pension - 5.8, illness - 1.4, unemployment - 0.4 */
    WHEN yForYear = 2010 THEN
      SET dAMPInsPerc = 6.7; /* pension - 4.9, illness - 1.4, unemployment - 0.4 */
    WHEN yForYear BETWEEN 2011 AND 2016 THEN
      SET dAMPInsPerc = 7.5; /* pension - 5.7, illness - 1.4, unemployment - 0.4 */
    WHEN yForYear = 2017 THEN
      SET dAMPInsPerc = 7.94; /* pension - 6.14, illness - 1.4, unemployment - 0.4 */
    WHEN yForYear BETWEEN 2018 AND 2025 THEN
      SET dAMPInsPerc = 8.38; /* pension - 6.58, illness - 1.4, unemployment - 0.4 */
    WHEN yForYear BETWEEN 2026 AND 2027 THEN
      SET dAMPInsPerc = 9.26; /* pension - 7.46, illness - 1.4, unemployment - 0.4 */
    WHEN yForYear >= 2028 THEN
      SET dAMPInsPerc = 9.7; /* pension - 7.9, illness - 1.4, unemployment - 0.4 */
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
