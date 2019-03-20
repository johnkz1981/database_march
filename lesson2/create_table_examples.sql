-- Создать временную таблицу
CREATE TEMPORARY TABLE take0 (
  id INT PRIMARY KEY,
  login VARCHAR(50),
  connected_at TIMESTAMP DEFAULT NOW()
);

-- Склонировать таблицу с помощью AS
CREATE TABLE cloned_as AS SELECT * FROM take0;

-- Склонировать таблицу с помощью LIKE
CREATE TABLE cloned_like LIKE take0;

-- Столбцы с ключами
CREATE TABLE indx (
  a INT,
  b INT,
  c INT,
  d INT,
  INDEX indx_idx (a),
  CONSTRAINT indx_pk PRIMARY KEY (b),
  CONSTRAINT indx_uq UNIQUE KEY (c),
  CONSTRAINT indx_fk FOREIGN KEY (d) REFERENCES cloned_like(id),
  CONSTRAINT indx_ch CHECK (c <= 100)
);

-- Использование NOT NULL значения по умолчанию
CREATE TABLE take1 (
  id INT NOT NULL,
  name VARCHAR(50) DEFAULT 'some_value'
);

-- Автоприращение, первичный и внешний ключ (объявление в определении столбца) 
CREATE TABLE take2 ( 
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) UNIQUE KEY COMMENT 'Commented column'
);

-- Использование генерируемого значения в столбце
CREATE TABLE take3 (
  a INT,
  b INT,
  c INT GENERATED ALWAYS AS (a*b) STORED
);

-- Расширенное определение внешнего ключа
CREATE TABLE take7 (
  id INT PRIMARY KEY,
  parent_id INT,
  FOREIGN KEY (parent_id) REFERENCES take2(id)
    MATCH FULL
    ON DELETE CASCADE
);
  
  
