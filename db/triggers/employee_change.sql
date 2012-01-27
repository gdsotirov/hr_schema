DELIMITER /

CREATE TRIGGER employee_change
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
  IF OLD.department_id != NEW.department_id THEN
    UPDATE departments
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END - 1
     WHERE id = OLD.department_id;

    UPDATE departments
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END + 1
     WHERE id = NEW.department_id;
  END IF;

  IF OLD.division_id != NEW.division_id THEN
    UPDATE divisions
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END - 1
     WHERE id = OLD.division_id;

    UPDATE divisions
       SET size = CASE
                    WHEN size IS NULL THEN 0
                    ELSE size
                  END + 1
     WHERE id = NEW.division_id;
  END IF;
END /

DELIMITER ;
