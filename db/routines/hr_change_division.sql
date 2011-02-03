DELIMITER //

CREATE PROCEDURE hr_change_division(IN iEmpID INTEGER,
                                    IN iDivID INTEGER,
                                    IN dBeginDate DATE)
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

  /* change division */
  UPDATE employees
     SET division_id = iDivID
   WHERE id = iEmpID;
END //

DELIMITER ;
