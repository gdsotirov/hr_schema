DELIMITER /

CREATE TRIGGER employee_add
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
  UPDATE departments
     SET size = CASE
                  WHEN `size` IS NULL THEN 0
                  ELSE `size`
                END + 1
   WHERE id = NEW.department_id;

  UPDATE divisions
     SET size = CASE
                  WHEN size IS NULL THEN 0
                  ELSE size
                END + 1
   WHERE id = NEW.division_id;
END /

DELIMITER ;
