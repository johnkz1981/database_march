----------------------------------------------------------------------------------
-- 1. Реализовать практические задания на примере других таблиц и запросов.

-- Уточнение: Создать транзакцию на основе триггера из предыдущего ДЗ.
-- После каждой операции транзакции поставить явно блокировку.
-- После первой операции - блокировку на чтение, после второй - на запись.
-- Исполняя команды по шагам, из другой сессии пробовать операции чтения и записи для блокированных таблиц.
-- В ДЗ приложить скрипт транзакции с блокировками.
----------------------------------------------------------------------------------

USE employees;

-- Транзакция
START TRANSACTION;
BEGIN;

LOCK TABLES employees READ;

INSERT INTO employees
  VALUES (
    500000,
    STR_TO_DATE('1988-10-17', '%Y-%m-%d'),
    'Jesse',
    'Eisenberg',
    'M',
    CURDATE()
  );


UNLOCK TABLES;

LOCK TABLES salaries WRITE;

INSERT INTO salaries
  VALUES (
    500000,
    1000,
    CURDATE(),
    LAST_DAY(CURDATE())
  );

UNLOCK TABLES;

COMMIT;
-----------------------------
ROLLBACK;


---- Проверки
SELECT * FROM employees WHERE emp_no = 500000;
SELECT * FROM salaries WHERE emp_no = 500000;

SELECT * FROM employees LIMIT 1;

INSERT INTO employees
  VALUES (
    600000,
    CURDATE(),
    'Name',
    'Name2',
    'M',
    CURDATE()
  );

SELECT * FROM salaries LIMIT 1;

INSERT INTO salaries
  VALUES (
    600000,
    1000,
    CURDATE(),
    CURDATE()
  );

-- Удаление новых записей
DELETE FROM employees WHERE emp_no = 500000;
DELETE FROM employees WHERE emp_no = 600000;
DELETE FROM salaries WHERE emp_no = 500000;
DELETE FROM salaries WHERE emp_no = 600000;