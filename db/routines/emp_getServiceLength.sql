DELIMITER //

CREATE FUNCTION emp_getServiceLength(EmpID INTEGER)
  RETURNS VARCHAR(20)
  READS SQL DATA
BEGIN
  DECLARE vcResult VARCHAR(20) DEFAULT NULL;
  DECLARE dEmpHireDate DATE DEFAULT NULL;
  DECLARE dEmpLeaveDate DATE DEFAULT NULL;

  SELECT hire_date,
         CASE
           WHEN leave_date IS NULL THEN CURDATE()
           ELSE leave_date
         END
    INTO dEmpHireDate,
         dEmpLeaveDate
    FROM employees
   WHERE ID = EmpID;

  SET vcResult := utl_getDateDiffStr(dEmpHireDate, dEmpLeaveDate);

  RETURN vcResult;
END //

DELIMITER ;
