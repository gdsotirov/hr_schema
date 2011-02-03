DELIMITER //

CREATE PROCEDURE hr_change_teamlead(IN iDepID INTEGER,
                                    IN iNewTL INTEGER)
BEGIN
  /* change deparments manager */
  UPDATE departments
     SET manager_id = iNewMgr
   WHERE id = iDepID;

  /* change manger for the employees in the department */
  UPDATE employees
     SET manager_id = iNewMgr
   WHERE department_id = iDepID;
END //

DELIMITER ;
