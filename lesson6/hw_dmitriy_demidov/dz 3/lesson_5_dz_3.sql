----------------------------------------------------------------------------------
-- 3. Проанализировать несколько запросов с помощью EXPLAIN.
----------------------------------------------------------------------------------

-- Первый запрос
EXPLAIN
  SELECT COUNT(emp_no)
    FROM dept_emp
    WHERE dept_emp.to_date >= CURDATE()\G;

-- ВЫВОД первый запрос
-- *************************** 1. row ***************************
--            id: 1
--   select_type: SIMPLE
--         table: dept_emp
--    partitions: NULL
--          type: ALL
-- possible_keys: NULL
--           key: NULL
--       key_len: NULL
--           ref: NULL
--          rows: 331140
--      filtered: 33.33
--         Extra: Using where
-- 1 row in set, 1 warning (0.00 sec)
-- **************************************************************
-- Запрос не оптимальный так как отсутсвует ключ у "dept_emp.to_date"
-- Если подобные запросы буду использоваться часто, нужно будет добавить ключ к данному полю
-----------------------------------------------------------------

-- Второй запрос
EXPLAIN
  SELECT
    salaries.emp_no,
    CONCAT(employees.first_name, ' ', employees.last_name) AS full_name,
    AVG(salary) AS emp_avg_salary
  FROM salaries
  INNER JOIN employees
    ON salaries.emp_no = employees.emp_no
  INNER JOIN dept_emp
    ON salaries.emp_no = dept_emp.emp_no
  WHERE dept_emp.to_date >= CURDATE()
  GROUP BY emp_no
  HAVING emp_avg_salary > 1.2 * (SELECT AVG(salary) FROM employees.salaries);

-- ВЫВОД второй запрос
-- *************************** 1. row ***************************
--            id: 1
--   select_type: PRIMARY
--         table: employees
--    partitions: NULL
--          type: ALL
-- possible_keys: PRIMARY
--           key: NULL
--       key_len: NULL
--           ref: NULL
--          rows: 239264
--      filtered: 100.00
--         Extra: Using temporary
-- **************************************************************
-- Здесь мы сканируем всю таблицу, но благодаря ключу нагрузка минимальная.
-- *************************** 2. row ***************************
--            id: 1
--   select_type: PRIMARY
--         table: dept_emp
--    partitions: NULL
--          type: ref
-- possible_keys: PRIMARY,emp_no
--           key: PRIMARY
--       key_len: 4
--           ref: employees.employees.emp_no
--          rows: 1
--      filtered: 33.33
--         Extra: Using where
-- **************************************************************
-- Здесь мы так же делаем выборку по ключам, нагрузка будет минимальна.
-- *************************** 3. row ***************************
--            id: 1
--   select_type: PRIMARY
--         table: salaries
--    partitions: NULL
--          type: ref
-- possible_keys: PRIMARY,emp_no
--           key: PRIMARY
--       key_len: 4
--           ref: employees.employees.emp_no
--          rows: 8
--      filtered: 100.00
--         Extra: NULL
-- **************************************************************
-- Здесь я так понял у нас первый JOIN с employees и так как объединение
-- идет по ключам, нагрузка тут небольшая
-- *************************** 4. row ***************************
--            id: 2
--   select_type: SUBQUERY
--         table: salaries
--    partitions: NULL
--          type: ALL
-- possible_keys: NULL
--           key: NULL
--       key_len: NULL
--           ref: NULL
--          rows: 2093004
--      filtered: 100.00
--         Extra: NULL
-- **************************************************************
-- А вот это самый тяжелый запрос, в котором не используются ключи и мы выбираем большое кол-во данных из-за того, что в операторе HAVING для каждого сравнения делается отдельный запрос к "employees.salaries" с подсчетом результатов.
-- И это больше всего в данной ситуации нагружает нашу БД.
-- Чтобы решить проблему можно переписать запрос по-другому:
EXPLAIN
SELECT *
  FROM (
    SELECT
      salaries.emp_no,
      CONCAT(employees.first_name, ' ', employees.last_name) AS full_name,
      AVG(salary) AS emp_avg_salary
    FROM salaries
    INNER JOIN employees
      ON salaries.emp_no = employees.emp_no
    INNER JOIN dept_emp
      ON salaries.emp_no = dept_emp.emp_no
    WHERE dept_emp.to_date >= CURDATE()
    GROUP BY emp_no
  ) AS tbl
  WHERE emp_avg_salary > 1.2 * (SELECT AVG(salary) FROM employees.salaries);
-- Скриншоты с результатами MySQL Workbench приложу к ДЗ.
-----------------------------------------------------------------