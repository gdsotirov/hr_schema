DELIMITER //

CREATE PROCEDURE mgmt_promote(IN iEmpID INTEGER,
                              IN dBeginDate DATE,
                              IN iNewJobID INTEGER,
                              IN nNewSalary DECIMAL)
  READS SQL DATA
  MODIFIES SQL DATA
BEGIN
  IF dBeginDate IS NULL THEN
    SET dBeginDate := CURDATE();
  END IF;

  /* log into history and than do changes */
  IF iNewJobID IS NOT NULL THEN
    INSERT INTO job_history
      (employee_id, from_date, job_id)
    SELECT
       id, dBeginDate, job_id
      FROM employees
     WHERE id = iEmpID;

   UPDATE employees
      SET job_id = iJobID
    WHERE id = iEmpID;
  END IF;

  IF nNewSalary IS NOT NULL THEN
    INSERT INTO sal_history
      (employee_id, from_date, salary)
    SELECT
      id, dBeginDate, salary
      FROM employees
     WHERE id = iEmpID;

    UPDATE employees
       SET salary = nNewSalary
     WHERE id = iEmpID;
  END IF;
END //

DELIMITER ;
