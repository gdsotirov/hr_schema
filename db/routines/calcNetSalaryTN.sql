DELIMITER //

CREATE FUNCTION calcNetSalaryTN(dGrossSalary DECIMAL) RETURNS DECIMAL(10,2)
  NO SQL
  DETERMINISTIC
BEGIN
  /* See http://taxsummaries.pwc.com/uk/taxsummaries/wwts.nsf/ID/Tunisia-Individual-Income-determination */
  /* See http://taxsummaries.pwc.com/uk/taxsummaries/wwts.nsf/ID/Tunisia-Individual-Taxes-on-personal-income */
  DECLARE dAnnGrossSal  DECIMAL(10,2);   
  DECLARE dAnnSocSec    DECIMAL(10,2);
  DECLARE dMthSocSec    DECIMAL(10,2);
  DECLARE dAnnProfExp   DECIMAL(10,2);
  DECLARE dAnnTaxSal    DECIMAL(10,2);
  DECLARE dAnnTaxAmt    DECIMAL(10,2) DEFAULT 0;
  DECLARE dMthTaxAmt    DECIMAL(10,2);
  DECLARE dMthNetSalary DECIMAL(10,2);

  /* Calcualte annual gross salary */
  SET dAnnGrossSal = dGrossSalary * 12;
  /* Calcualte annual and monthly social contributions */
  SET dAnnSocSec = ROUND(dAnnGrossSal * 9.18 / 100, 2);
  SET dMthSocSec = ROUND(dAnnSocSec / 12, 2);
  /* Calcaulte annual professional expenses */
  SET dAnnProfExp = ROUND((dAnnGrossSal - dAnnSocSec) * 10 / 100, 2);
  /* Calcualte taxable salary amount by deducting annul social contributions and annual professional expenses */
  SET dAnnTaxSal = ROUND(dAnnGrossSal - dAnnSocSec - dAnnProfExp - 150 - 90 - 75, 2);

  /* Apply progressive personal income scale */
  IF dAnnTaxSal <= 1500 THEN
    SET dAnnTaxAmt = 0;
    SET dMthTaxAmt = 0;
  ELSE
    IF dAnnTaxSal <= 5000 THEN
      SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 1500) * 15 / 100, 2);
    ELSE
      SET dAnnTaxAmt = dAnnTaxAmt + ROUND((5000 - 1500) * 15 / 100, 2);

      IF dAnnTaxSal <= 10000 THEN
        SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 5000) * 20 / 100, 2);
      ELSE
        SET dAnnTaxAmt = dAnnTaxAmt + ROUND((10000 - 5000) * 20 / 100, 2);

        IF dAnnTaxSal <= 20000 THEN
          SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 10000) * 25 / 100, 2);
        ELSE
          SET dAnnTaxAmt = dAnnTaxAmt + ROUND((20000 - 10000) * 25 / 100, 2);

          IF dAnnTaxSal <= 50000 THEN
            SET dAnnTaxAmt = dAnnTaxAmt + ROUND((dAnnTaxSal - 20000) * 30 / 100, 2);
          ELSE
            SET dAnnTaxAmt = dAnnTaxAmt + ROUND((50000 - 20000) * 30 / 100, 2);
            SET dAnnTaxAmt = dAnnTaxAmt + ROUND(dAnnTaxSal - 50000 * 35 / 100, 2);
          END IF;
        END IF;
      END IF;
    END IF;

	/* Calcualte monthly income tax */
    SET dMthTaxAmt = ROUND(dAnnTaxAmt / 12, 2);
  END IF;

  /* Calcualte Net Salary */
  SET dMthNetSalary = dGrossSalary - dMthSocSec - dMthTaxAmt;

  RETURN dMthNetSalary;
END //

DELIMITER ;
