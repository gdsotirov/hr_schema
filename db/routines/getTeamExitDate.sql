DELIMITER //

CREATE FUNCTION getTeamExitDate(iEmpID INTEGER,
                                iDepID INTEGER) RETURNS DATE
  READS SQL DATA
BEGIN
  DECLARE dLeaveDate DATE DEFAULT NULL;
  DECLARE dExitDate  DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iDepID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of team change */
  SELECT MIN(from_date)
    INTO dExitDate
    FROM team_change TE
   WHERE employee_id = iEmpID
     AND department <> iDepID
     AND from_date >= (SELECT MAX(from_date)
                         FROM team_change
                        WHERE employee_id = TE.employee_id
                          AND department = iDepID);

  /* if no date of team change */
  IF dExitDate IS NULL THEN
    /* select leave date, but only if current team is the same */
    SELECT leave_date
      INTO dLeaveDate
      FROM employees
     WHERE id = iEmpID
       AND department_id = iDepID;

	/* if leave date found presume it as team exit date */
	IF dLeaveDate IS NOT NULL THEN
      SET dExitDate = dLeaveDate;
    END IF;
  END IF;

  RETURN dExitDate;
END //

DELIMITER ;
