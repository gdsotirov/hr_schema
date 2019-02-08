DELIMITER //

CREATE PROCEDURE emp_calcTotalSnrty(IN EmpID INT, OUT SenYrs INT, OUT SenMns INT, OUT SenDys INT)
  READS SQL DATA
  DETERMINISTIC
BEGIN
  DECLARE dFromDt   DATE;
  DECLARE dToDt     DATE;
  DECLARE iEmpYrs   INT DEFAULT 0;
  DECLARE iEmpMns   INT DEFAULT 0;
  DECLARE iEmpDys   INT DEFAULT 0;
  DECLARE done INT DEFAULT FALSE;
  DECLARE emps_cur CURSOR FOR
  SELECT EMP.hire_date, IFNULL(EMP.leave_date, NOW())
    FROM persons   PER,
         employees EMP
   WHERE EMP.person_id = PER.id
     AND EMP.person_id = (SELECT person_id
                            FROM employees
                           WHERE id = EmpID);
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  /* Initialize with prior internship period */
  SELECT IFNULL(prior_internship_yrs, 0), IFNULL(prior_internship_mns, 0), IFNULL(prior_internship_dys, 0)
    INTO SenYrs, SenMns, SenDys
    FROM persons P
   WHERE P.id = (SELECT E.person_id
                   FROM employees E
                  WHERE E.id = EmpID);

  OPEN emps_cur;

  /* A person could have been employee more than once, so loop employees */
  emps_loop: LOOP
    FETCH emps_cur INTO dFromDt, dToDt;

    IF done THEN
      LEAVE emps_loop;
    END IF;

    CALL utl_getDateDiff(dFromDt, dToDt, iEmpYrs, iEmpMns, iEmpDys);

    SET SenDys = SenDys + iEmpDys;
    /* 30 days are considered 1 month */
    IF SenDys > 30 THEN
      SET SenMns = SenMns + 1;
      SET SenDys = SenDys - 30;
    END IF;

    SET SenMns = SenMns + iEmpMns;
    /* 12 months are definitelly a year */
    IF SenMns > 12 THEN
      SET SenYrs = SenYrs + 1;
      SET SenMns = SenMns - 12;
    END IF;

    SET SenYrs = SenYrs + iEmpYrs;
  END LOOP;

  CLOSE emps_cur;
END //

DELIMITER ;
