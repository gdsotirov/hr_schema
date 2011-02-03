DELIMITER //

CREATE PROCEDURE mgmt_promote(IN iEmpID INTEGER,
                              IN iJobID INTEGER,
                              IN dBeginDate DATE,
                              IN nNewSalary DECIMAL)
BEGIN
  IF dBeginDate IS NULL THEN
    SET dBeginDate := CURDATE();
  END IF;

  /* log into history */
  INSERT INTO job_history
    (employee_id, from_date, job_id, manager_id, department_id, division_id, salary)
  SELECT
     id, dBeginDate, job_id, manager_id, department_id, division_id, salary
    FROM employees
   WHERE id = iEmpID;

  /* change job */
  UPDATE employees
     SET job_id = iJobID
   WHERE id = iEmpID;

  IF nNewSalary IS NOT NULL THEN
    UPDATE employees
       SET salary = nNewSalary
     WHERE id = iEmpID;
  END IF;
END //

DELIMITER ;
