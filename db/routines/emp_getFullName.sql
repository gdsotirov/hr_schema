DELIMITER //

CREATE FUNCTION emp_getFullName(EmpID INTEGER) RETURNS VARCHAR(256)
  READS SQL DATA
BEGIN
  DECLARE vcResult   VARCHAR(256) DEFAULT NULL;
  DECLARE vcFrstName VARCHAR(64) DEFAULT NULL;
  DECLARE vcMdleName VARCHAR(64) DEFAULT NULL;
  DECLARE vcMaidName VARCHAR(32) DEFAULT NULL;
  DECLARE vcLastName VARCHAR(64) DEFAULT NULL;
  DECLARE dEmpLeaveDate DATE DEFAULT NULL;

  SELECT PER.first_name,
         PER.middle_name,
         PER.maiden_name,
         PER.last_name,
         EMP.leave_date
    INTO vcFrstName,
         vcMdleName,
         vcMaidName,
         vcLastName,
         dEmpLeaveDate
    FROM employees EMP,
         persons   PER
   WHERE EMP.id = EmpID
     AND EMP.person_id = PER.id;

  IF vcMaidName IS NOT NULL THEN
    SET vcLastName := CONCAT(vcMaidName, '-', vcLastName);
  END IF;

  IF vcMdleName IS NOT NULL THEN
    SET vcResult := CONCAT(vcLastName, ', ', vcFrstName, ' ', vcMdleName);
  ELSE
    SET vcResult := CONCAT(vcLastName, ', ', vcFrstName);
  END IF;

  IF dEmpLeaveDate IS NOT NULL THEN
    SET vcResult := CONCAT(vcResult, ' (until ', DATE_FORMAT(dEmpLeaveDate, '%Y-%m-%d'), ')');
  END IF;

  RETURN vcResult;
END //

DELIMITER ;
