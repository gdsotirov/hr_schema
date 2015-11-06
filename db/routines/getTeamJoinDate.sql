DELIMITER //

CREATE FUNCTION getTeamJoinDate(iEmpID INTEGER,
                                iDepID INTEGER) RETURNS DATE
BEGIN
  DECLARE dHireDate DATE DEFAULT NULL;
  DECLARE dJoinDate DATE DEFAULT NULL;

  /* check arguments */
  IF iEmpID IS NULL OR iDepID IS NULL THEN
    RETURN NULL;
  END IF;

  /* select date of team change */
  SELECT MAX(from_date)
    INTO dJoinDate
    FROM team_change
   WHERE employee_id = iEmpID
     AND department = iDepID;

  /* if no date of team change */
  IF dJoinDate IS NULL THEN
    /* select hire date, but only if current team is the same */
    SELECT hire_date
      INTO dHireDate
      FROM employees
     WHERE id = iEmpID
       AND department_id = iDepID;

	/* if hire date found presume it as team join date */
	IF dHireDate IS NOT NULL THEN
      SET dJoinDate = dHireDate;
    END IF;
  END IF;

  RETURN dJoinDate;
END //

DELIMITER ;
