DELIMITER //

CREATE FUNCTION getPositionStartDate(iEmpID INTEGER,
                                     iJobID INTEGER) RETURNS DATE
BEGIN
  DECLARE dHireDate  DATE DEFAULT NULL;
  DECLARE dStartDate DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iJobID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of job change */
  SELECT MAX(from_date)
    INTO dStartDate
    FROM job_history
   WHERE employee_id = iEmpID
     AND job_id      = iJobID;

  /* if no date of team change */
  IF dStartDate IS NULL THEN
    /* select hire date, but only if current job is the same */
    SELECT hire_date
      INTO dHireDate
      FROM employees
     WHERE id = iEmpID
       AND job_id = iJobID;

    /* if hire date found presume it as job start date */
    IF dHireDate IS NOT NULL THEN
      SET dStartDate = dHireDate;
    END IF;
  END IF;

  RETURN dStartDate;
END //

DELIMITER ;
