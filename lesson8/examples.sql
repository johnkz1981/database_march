-- PostrgeSQL

-- Массивы как типы данных

CREATE TABLE picnics (
  holiday VARCHAR(50),
  sandwich TEXT[],
  side TEXT[] [],
  dessert TEXT ARRAY,
  beverage TEXT ARRAY[4]
);

INSERT INTO picnics VALUES (
  'Labor Day',
     '{"roast beef","veggie","turkey"}',
     '{
        {"potato salad","green salad"},
        {"chips","crackers"}
     }',
     '{"fruit cocktail","berry pie","ice cream"}',
     '{"soda","juice","beer","water"}'
);

-- Использование типа данных path

CREATE TABLE trails (
  name VARCHAR(255),
  route path
);

INSERT INTO trails VALUES (
  'Dool Trail - Creeping Forest Trail Loop',
     '((37.172,-122.22261666667),
     (37.171616666667,-122.22385),
     (37.1735,-122.2236),
     (37.175416666667,-122.223),
     (37.1758,-122.22378333333),
     (37.179466666667,-122.22866666667),
     (37.18395,-122.22675),
     (37.180783333333,-122.22466666667),
     (37.176116666667,-122.2222),
     (37.1753,-122.22293333333),
     (37.173116666667,-122.22281666667))'
);

-- Создание пользовательского типа данных

CREATE TYPE wine AS (
  vineyard VARCHAR(50),
  title VARCHAR(50),
  year INT
);

-- Создание индекса по условию

CREATE INDEX order_idx ON orders (order_id)
  WHERE status_id = 6;
 
  
  
-- Redis

-- Установка Redis  
# sudo apt update
# sudo apt install redis-server

-- Вход в клиент
# redis-cli

-- Добавить пару ключ-значение
127.0.0.1:6379> set test:1:string "hello"
OK

-- Возвратить значение
127.0.0.1:6379> get test:1:string
"hello"

-- Изменить строку значения
127.0.0.1:6379> append test:1:string " world"
(integer) 11

127.0.0.1:6379> get test:1:string
"hello world"

-- Проверка на существование
127.0.0.1:6379> exists test:1:string 
(integer) 1

127.0.0.1:6379> exists test2:1:string 
(integer) 0

-- Выборка ключей по шаблону
127.0.0.1:6379> keys test:*
1) "test:1:string"

-- Проверка времени жизни
127.0.0.1:6379> ttl test:1:string
(integer) -1

  


