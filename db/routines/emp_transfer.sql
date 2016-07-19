DELIMITER //

CREATE PROCEDURE emp_transfer(IN iEmpID     INTEGER,
                              IN dBeginDate DATE,
                              IN iJobID     INTEGER,
                              IN iTeamID    INTEGER,
                              IN nSalary    DECIMAL,
                              IN cCurrency  CHAR(3),
                              IN dGrantedOn DATE,
                              IN iGrantedBy INTEGER,
                              IN dApprOn    DATE,
                              IN iApprBy    INTEGER)
BEGIN
  DECLARE emp_cnt INTEGER DEFAULT 0;
  DECLARE job_cnt INTEGER DEFAULT 0;
  DECLARE tm_cnt  INTEGER DEFAULT 0;

  SELECT COUNT(*)
    INTO emp_cnt
    FROM employees
   WHERE id = iEmpID;

  IF ( emp_cnt = 0 ) THEN
    SET @msg = CONCAT('Unknown employee with identifier <', iEmpID, '>!');
    SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = @msg;
  END IF;

  IF dBeginDate IS NULL THEN
    SET dBeginDate := CURDATE();
  END IF;

  /* log into history and than do changes */
  IF iJobID IS NOT NULL THEN
    SELECT COUNT(*)
      INTO job_cnt
      FROM jobs
     WHERE id = iJobID;

    IF ( job_cnt = 0 ) THEN
      SET @msg = CONCAT('Unknown job with identifier <', iJobID, '>!');
      SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = @msg;
    END IF;

    INSERT INTO job_history
      (employee_id, from_date, job_id, granted_on, granted_by, approved_on, approved_by)
    SELECT
      EMP.id, dBeginDate, iJobID, dGrantedOn, iGrantedBy, dApprOn, iApprBy
      FROM employees EMP
     WHERE id = iEmpID
       AND NOT EXISTS (SELECT 1
                         FROM job_history
                        WHERE employee_id = EMP.id
                          AND from_date = dBeginDate
                          AND job_id = iJobID);
  END IF;

  IF iTeamID IS NOT NULL THEN
    SELECT COUNT(*)
      INTO tm_cnt
      FROM departments
     WHERE id = iTeamID;

    IF ( tm_cnt = 0 ) THEN
      SET @msg = CONCAT('Unknown department with identifier <', iJobID, '>!');
      SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = @msg;
    END IF;

    INSERT INTO team_change
      (employee_id, from_date, department, granted_on, granted_by, approved_on, approved_by)
    SELECT
       EMP.id, dBeginDate, iTeamID, dGrantedOn, iGrantedBy, dApprOn, iApprBy
      FROM employees EMP
     WHERE id = iEmpID
       AND NOT EXISTS (SELECT 1
                         FROM team_change
                        WHERE employee_id = EMP.id
                          AND from_date = dBeginDate
                          AND department = iTeamID);
  END IF;

  IF nSalary IS NOT NULL AND cCurrency IS NOT NULL THEN
    INSERT INTO sal_history
      (employee_id, from_date, amount, currency, granted_on, granted_by, approved_on, approved_by)
    SELECT
       EMP.id, dBeginDate, nSalary, cCurrency, dGrantedOn, iGrantedBy, dApprOn, iApprBy
      FROM employees EMP
     WHERE id = iEmpID
       AND NOT EXISTS (SELECT 1
                         FROM sal_history
                        WHERE employee_id = EMP.id
                          AND from_date = dBeginDate
                          AND salary = nSalary);
  END IF;
END //

DELIMITER ;
