DELIMITER //

CREATE FUNCTION `emp_getTimeCurPosition`(EmpID INTEGER)
  RETURNS VARCHAR(20) CHARSET utf8
  READS SQL DATA
BEGIN
  DECLARE vcResult VARCHAR(20) DEFAULT NULL;
  DECLARE dEmpLeaveDate DATE DEFAULT NULL;
  DECLARE dLastPosFromDate DATE DEFAULT NULL;
  DECLARE dLastPosToDate DATE DEFAULT NULL;

  SELECT EMP.leave_date,
         JH.from_date
    INTO dEmpLeaveDate,
         dLastPosFromDate
    FROM employees   EMP
         LEFT OUTER JOIN job_history JH  ON JH.employee_id = EMP.id
                                        AND JH.job_id = EMP.job_id
                                        AND JH.from_date = (SELECT MAX(from_date)
                                                              FROM job_history
                                                             WHERE employee_id = EMP.id
                                                               AND job_id      = EMP.job_id
                                                           )
   WHERE EMP.id = EmpID;

  IF dLastPosFromDate IS NULL THEN
    SET vcResult := 'n/a';
  ELSE
    IF dEmpLeaveDate IS NULL THEN
      SET dLastPosToDate := CURDATE();
    ELSE
      SET dLastPosToDate := dEmpLeaveDate;
    END IF;

    SET vcResult := utl_getDateDiffStr(dLastPosFromDate, dLastPosToDate);
  END IF;

  RETURN vcResult;
END //

DELIMITER ;
