DELIMITER //

CREATE FUNCTION getPositionEndDate(iEmpID INTEGER,
                                   iJobID INTEGER) RETURNS DATE
  READS SQL DATA
BEGIN
  DECLARE dLeaveDate DATE DEFAULT NULL;
  DECLARE dEndDate   DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iJobID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of job change */
  SELECT MIN(from_date)
    INTO dEndDate
    FROM job_history JH
   WHERE employee_id = iEmpID
     AND job_id      <> iJobID
     AND from_date >= (SELECT MAX(from_date)
                         FROM job_history
                        WHERE employee_id = JH.employee_id
                          AND job_id      = iJobID);

  /* if no date of team change */
  IF dEndDate IS NULL THEN
    /* select hire date, but only if current job is the same */
    SELECT leave_date
      INTO dLeaveDate
      FROM employees
     WHERE id     = iEmpID
       AND job_id = iJobID;

    /* if hire date found presume it as team join date */
    IF dLeaveDate IS NOT NULL THEN
      SET dEndDate = dLeaveDate;
    END IF;
  END IF;

  RETURN dEndDate;
END //

DELIMITER ;
