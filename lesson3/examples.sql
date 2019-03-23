USE departments;

-- Объединение столбцов с CONCAT и использование алиаса для имени столбца
SELECT * FROM departments;
SELECT dept_name AS 'Department Name' FROM departments;
SELECT CONCAT(first_name, ' ', last_name) AS 'Full name' FROM employees;

-- Выборка уникальных значений
SELECT DISTINCT gender AS distinct_gender FROM employees;

-- Выборка по условию
SELECT first_name, last_name, gender FROM employees WHERE gender='M';
SELECT emp_no FROM salaries WHERE salary <= 50000;
SELECT DISTINCT(emp_no) FROM salaries WHERE salary <= 50000;
SELECT DISTINCT(emp_no) FROM salaries WHERE salary > 60000;

-- Логические операции
SELECT 10 IS TRUE;
SELECT 'table' IS NOT NULL;
SELECT NOT 10;
SELECT NOT 0;

SELECT 1 AND 1;
SELECT 1 AND 0;

SELECT 1 OR 1;
SELECT 1 OR 0;

SELECT 1 XOR 1;
SELECT 1 XOR 0;

-- Выборка по множеству
SELECT * FROM salaries WHERE emp_no IN (10001, 10002, 10003);

-- Выборка по диапазону
SELECT * FROM salaries WHERE emp_no BETWEEN 10001 AND 10003;

-- Выборка по частичному соответствию
SELECT * FROM employees WHERE first_name LIKE 'B%';
SELECT * FROM employees WHERE first_name LIKE '_____';

-- Выборка с использованием регулярных выражений
SELECT first_name FROM employees WHERE first_name REGEXP BINARY '^Ky';
SELECT first_name FROM employees WHERE first_name REGEXP BINARY 'a$';

-- Поиск средненго значения
SELECT AVG(salary) FROM salaries;
SELECT emp_no, AVG(salary)
  FROM salaries 
  GROUP BY emp_no;

-- Подсчёт строк
SELECT COUNT(*) FROM salaries;
SELECT emp_no, COUNT(*)
  FROM salaries 
  GROUP BY emp_no;

-- Поиск минимального значения  
SELECT MIN(salary) FROM salaries;
SELECT MIN(avg_salary) FROM (
  SELECT emp_no, AVG(salary) AS avg_salary FROM salaries GROUP BY emp_no
) AS salary_details;

-- Поиск максимального значения
SELECT emp_no, MAX(salary)
  FROM salaries
  GROUP BY emp_no;

-- Суммирование  
SELECT emp_no, SUM(salary)
  FROM salaries
  GROUP BY emp_no;
  
-- Использования условия HAVING
SELECT emp_no, MAX(salary) AS max_salary
  FROM salaries
  GROUP BY emp_no
  HAVING max_salary >= 150000;

-- Сортировка  
SELECT * FROM departments ORDER BY dept_name;
SELECT * FROM departments ORDER BY dept_no DESC;

-- Лимит на вывод строк
SELECT * FROM departments
  ORDER BY dept_no
  LIMIT 1;
  
SELECT * FROM salaries
  ORDER BY salary ASC
  LIMIT 1;
  
SELECT * FROM departments
  ORDER BY dept_no
  LIMIT 1;

-- Оффсетный сдвиг  
SELECT * FROM departments
  ORDER BY dept_no
  LIMIT 2, 5;

-- Создаём таблицы для работы с JOIN  
CREATE TABLE customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE orders(
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE,
    amount DECIMAL(8,2),
    customer_id INT,
    FOREIGN KEY(customer_id) REFERENCES customers(id)
);

INSERT INTO customers (first_name, last_name, email) 
VALUES ('Eric', 'Mann', 'eric_mann@gmail.com'),
       ('Bill', 'Gates', 'bg@gmail.com'),
       ('Milly', 'Cow', 'milly_cow@gmail.com'),
       ('Brad', 'Gillmour', 'gillmour@gmail.com'),
       ('Sonny', 'Kazakov', 'sonny_cool@gmail.com'),
       ('Max', 'Pillow', 'max_pillow@aol.com');
       
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2017-04-08', 104.45, 3),
       ('2017-12-22', 34.46, 3),
       ('2018-09-04', 335.78, 1),
       ('2018-10-04', 24.56, 2),
       ('2018-02-06', 6.50, 4),
       ('2018-01-23', 760.23, 5);

-- Поиск заказов пользователя с использованием двух запросов       
SELECT id FROM customers WHERE last_name = 'Kazakov';
SELECT * FROM orders WHERE customer_id = 5;

-- Поиск заказов пользователя с использованием вложенного запроса
SELECT * FROM orders WHERE customer_id = (
  SELECT id FROM customers WHERE last_name = 'Kazakov'
);

-- CROSS JOIN
SELECT * FROM customers, orders;

-- CROSS JOIN с условием
SELECT * FROM customers, orders
  WHERE customers.id = orders.customer_id;
  
SELECT first_name, last_name, order_date, amount
  FROM customers, orders
  WHERE customers.id = orders.customer_id;

-- Использование INNER JOIN  
SELECT * FROM customers
  JOIN orders
  ON customers.id = orders.customer_id;
  
SELECT first_name, last_name, order_date, amount
  FROM customers
  INNER JOIN orders
  ON customers.id = orders.customer_id;
  
SELECT first_name, last_name, order_date, amount
  FROM customers
  JOIN orders
    ON orders.customer_id = customers.id
  ORDER BY order_date;

-- Использование INNER JOIN с агрегирущими функциями  
SELECT first_name, last_name, SUM(amount) AS total_spent
  FROM customers
  JOIN orders
    ON customers.id = orders.customer_id
  GROUP BY orders.customer_id
  ORDER BY total_spent;  
  
SELECT first_name, last_name, SUM(amount) AS total_spent
  FROM customers c
  JOIN orders o
    ON c.id = o.customer_id
  GROUP BY o.customer_id
  ORDER BY total_spent;  
  
SELECT * FROM customers
  INNER JOIN orders
    ON customers.id = orders.customer_id;

-- OUTER JOINS    
-- Использование LEFT OUTER JOIN    
SELECT * FROM customers
  LEFT JOIN orders
    ON customers.id = orders.customer_id;
    
SELECT first_name, last_name, order_date, amount
  FROM customers
  LEFT JOIN orders
    ON customers.id = orders.customer_id;
    
SELECT first_name, last_name, order_date, amount
  FROM customers
  LEFT JOIN orders
    ON customers.id = orders.customer_id
  WHERE orders.order_date IS NULL;
  
SELECT first_name, last_name, IFNULL(SUM(amount), 0) AS total_spent
  FROM customers
  LEFT JOIN orders
    ON customers.id = orders.customer_id
  GROUP BY customers.id
  ORDER BY total_spent;

-- Использование RIGTH OUTER JOIN  
SELECT * FROM customers
  RIGHT JOIN orders
    ON customers.id = orders.customer_id;

-- Сравнение работы RIGNT JOIN и LEFT JOIN    
SELECT * FROM orders
  RIGHT OUTER JOIN customers
    ON customers.id = orders.customer_id;
    
SELECT * FROM customers
  LEFT OUTER JOIN orders
    ON customers.id = orders.customer_id;

-- Создание таблицы для работы с UNION    
CREATE TABLE vip_customers(
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100)
);

INSERT INTO vip_customers (first_name, last_name, email) 
VALUES ('Anna', 'Kurnikova', 'anna_kurnikova@gmail.com'),
       ('Bill', 'Gates', 'bg@gmail.com'),
       ('Donald', 'Trump', 'bg@gmail.com');

-- Использование UNION       
(SELECT * FROM customers)
  UNION ALL
(SELECT * FROM vip_customers);

-- Обновление данных UPDATE
UPDATE vip_customers
  SET email = 'supertrump@rambler.ru'
  WHERE first_name = 'Donald' AND last_name = 'Trump';

--- Удаление строк DELETE  
DELETE FROM vip_customers
  WHERE first_name = 'Bill' AND last_name = 'Gates';

-- Вставка строк INSERT  
INSERT INTO vip_customers (first_name, last_name, email)
  VALUES ('Olga', 'Buzova', 'buzova@yandex.ru');
  
INSERT INTO vip_customers (first_name, last_name)
  VALUES ('Lady', 'Gaga');

-- Использование INSERT ... SELECT  
INSERT INTO
  customers (first_name, last_name, email)
  SELECT
    vip_customers.first_name,
    vip_customers.last_name,
    vip_customers.email
  FROM vip_customers;
  
