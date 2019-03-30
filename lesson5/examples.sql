-- Транзакции

CREATE TABLE test (a INT, b INT);
INSERT INTO test (a, b) VALUE (1, 1);

START TRANSACTION;
BEGIN;
INSERT INTO test (a, b) VALUE (2, 2);
COMMIT;

START TRANSACTION;
BEGIN;
INSERT INTO test (a, b) VALUE (3, 3);
ROLLBACK;

SET TRANSACTION ISOLATION LEVEL READ COMMITED;

-- Использование EXPLAIN

EXPLAIN SELECT first_name< last_name, title
  FROM employees
    JOIN dept_emp
      ON employees.emp_no = dept_emp.emp_no
    JOIN departments 
      ON departments.dept_no = dept_emp.dept_no
    JOIN titles
      ON titles.emp_no = employees.emp_no
  WHERE dept_emp.to_date >= CURDATE()
    AND titles.to_date >= CURDATE()
    AND departments.dept_name = 'Production';



