----------------------------------------------------------------------------------
-- 2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.

-- Уточнение: Придумать и реализовать две транзакции для БД сотрудников.
-- В первой транзакции должно быть задействовано, как минимум, две таблицы, во второй - три таблицы.
----------------------------------------------------------------------------------

USE employees;

-- Транзакция #1
START TRANSACTION;
BEGIN;

LOCK TABLES employees WRITE, dept_emp WRITE;

INSERT INTO employees
  VALUES (
    500002,
    STR_TO_DATE('1988-10-17', '%Y-%m-%d'),
    'Jesse',
    'Eisenberg',
    'M',
    CURDATE()
  );

INSERT INTO dept_emp
  VALUES (
    500002,
    'd005',
    CURDATE(),
    STR_TO_DATE('9999-01-01', '%Y-%m-%d')
  );

COMMIT;

UNLOCK TABLES;

-- Удаление новых записей
DELETE FROM employees WHERE emp_no = 500002;
DELETE FROM dept_emp WHERE emp_no = 500002;

--------------------------------------------------------------------

-- Транзакция #2
START TRANSACTION;
BEGIN;

LOCK TABLES employees WRITE, dept_manager WRITE, salaries WRITE;

INSERT INTO employees
  VALUES (
    500000,
    STR_TO_DATE('1988-10-17', '%Y-%m-%d'),
    'Jesse',
    'Eisenberg',
    'M',
    CURDATE()
  );

INSERT INTO dept_manager
  VALUES (
    'd005',
    500000,
    CURDATE(),
    STR_TO_DATE('9999-01-01', '%Y-%m-%d')
  );

INSERT INTO salaries
  VALUES (
    500000,
    60000,
    CURDATE(),
    STR_TO_DATE('9999-01-01', '%Y-%m-%d')
  );

COMMIT;

UNLOCK TABLES;
-----------------------------------------

-- Удаление новых записей
DELETE FROM employees WHERE emp_no = 500000;
DELETE FROM dept_manager WHERE emp_no = 500000;
DELETE FROM salaries WHERE emp_no = 500000;