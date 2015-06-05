DELIMITER //

CREATE FUNCTION calcNetSalaryTN(dGrossSalary DECIMAL) RETURNS DECIMAL(10,2)
BEGIN
  /* See http://taxsummaries.pwc.com/uk/taxsummaries/wwts.nsf/ID/Tunisia-Individual-Income-determination */
  /* See http://taxsummaries.pwc.com/uk/taxsummaries/wwts.nsf/ID/Tunisia-Individual-Taxes-on-personal-income */
  DECLARE dSocSec     DECIMAL(10,2);
  DECLARE dProfExp    DECIMAL(10,2);
  DECLARE dTaxSal     DECIMAL(10,2);
  DECLARE dNetSalary  DECIMAL(10,2);
  DECLARE dIncTaxBase DECIMAL(10,2);
  DECLARE dIncTaxAmt  DECIMAL(10,2) DEFAULT 0;

  /* Calcualte social contributions */
  SET dSocSec  = ROUND(dGrossSalary * 9.18 / 100, 2);
  /* Calcaulte professional expenses */
  SET dProfExp = ROUND((dGrossSalary - dSocSec) * 10 / 100, 2);
  /* Calcualte taxable amount by deducting social contributions and professional expenses */
  SET dTaxSal  = ROUND(dGrossSalary - dSocSec - dProfExp, 2);

  SET dIncTaxBase = dTaxSal;

  /* Apply progressive personal income scale */
  IF dIncTaxBase <= 1500 THEN
    SET dIncTaxAmt = 0;
  ELSE
    IF dIncTaxBase <= 5000 THEN
      SET dIncTaxAmt = dIncTaxAmt + ROUND((dIncTaxBase - 1500) * 15 / 100, 2);
    ELSE
      SET dIncTaxAmt = dIncTaxAmt + ROUND((5000 - 1500) * 15 / 100, 2);
      SET dIncTaxBase = dIncTaxBase - 5000;

      IF dIncTaxBase <= 10000 THEN
        SET dIncTaxAmt = dIncTaxAmt + ROUND((dIncTaxBase - 5000) * 20 / 100, 2);
    ELSE
        SET dIncTaxAmt = dIncTaxAmt + ROUND((10000 - 5000) * 20 / 100, 2);
        SET dIncTaxBase = dIncTaxBase - 10000;

        IF dIncTaxBase <= 20000 THEN
          SET dIncTaxAmt = dIncTaxAmt + ROUND((dIncTaxBase - 10000) * 25 / 100, 2);
        ELSE
          SET dIncTaxAmt = dIncTaxAmt + ROUND((20000 - 10000) * 25 / 100, 2);
          SET dIncTaxBase = dIncTaxBase - 20000;

          IF dIncTaxBase <= 50000 THEN
            SET dIncTaxAmt = dIncTaxAmt + ROUND((dIncTaxBase - 10000) * 30 / 100, 2);
          ELSE
            SET dIncTaxAmt = dIncTaxAmt + ROUND((50000 - 20000) * 30 / 100, 2);
            SET dIncTaxAmt = dIncTaxAmt + ROUND(dIncTaxBase - 50000 * 35 / 100, 2);
          END IF;
        END IF;
      END IF;
    END IF;
  END IF;

  /* Calcualte Net Salary */
  SET dNetSalary = dTaxSal - dIncTaxAmt;

  RETURN dNetSalary;
END //

DELIMITER ;
