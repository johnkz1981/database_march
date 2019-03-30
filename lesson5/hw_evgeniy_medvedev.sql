
CREATE FUNCTION return_full_name(first VARCHAR(14), last VARCHAR(16))
    RETURNS INT 
    READS SQL DATA
RETURN (
    SELECT dept_manager.emp_no
    FROM dept_manager
             JOIN employees e on dept_manager.emp_no = e.emp_no
    WHERE first_name = first
      AND last_name = last);

SELECT return_full_name("Margareta", "Markovitch");


delimiter //
CREATE TRIGGER insert_bonus
    AFTER INSERT
    ON employees
    FOR EACH ROW
    BEGIN
        INSERT INTO salaries (emp_no, salary, from_date, to_date)
        VALUES (NEW.emp_no, 100, CURDATE(), '2019-03-31');
    END//
delimiter ;
