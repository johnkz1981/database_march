Задачи к собеседованию

Задача 1. У вас есть социальная сеть, где пользователи (id, имя) могут 
ставить друг другу лайки. Создайте необходимые таблицы для хранения 
данной информации. Создайте запрос, который выведет информацию:
    • id пользователя;
    • имя;
    • лайков получено;
    • лайков поставлено;
    • взаимные лайки.
    
Задача 2. Для структуры из задачи 1 выведите список всех пользователей, 
которые поставили лайк пользователям A и B (id задайте произвольно), 
но при этом не поставили лайк пользователю C.

Задача 3. Добавим сущности «Фотография» и «Комментарии к фотографии». 
Нужно создать функционал для пользователей, который позволяет ставить 
лайки не только пользователям, но и фото или комментариям к фото. 
Учитывайте следующие ограничения:
    • пользователь не может дважды лайкнуть одну и ту же сущность;
    • пользователь имеет право отозвать лайк;
    • необходимо иметь возможность считать число полученных сущностью 
    лайков и выводить список пользователей, поставивших лайки;
    • в будущем могут появиться новые виды сущностей, которые можно лайкать.


-- Задача 1
-- Лайков получено
SELECT users.id, users.name, COUNT(likes.to_id) AS got_likes
  FROM users
    LEFT JOIN likes
      ON users.id = likes.to_id
    GROUP BY users.id;

-- Лайков поставлено
SELECT users.id, users.name, COUNT(likes.from_id) AS given_likes
  FROM users
    LEFT JOIN likes
      ON users.id = likes.from_id
    GROUP BY users.id;
    
-- Взаимные лайки  
SELECT users.id, users.name, COUNT(users.id) AS cross_likes
  FROM users
  LEFT JOIN likes AS likes_1
    ON users.id = likes_1.from_id
  INNER JOIN likes as likes_2
    ON likes_1.from_id = likes_2.to_id
    AND likes_1.to_id = likes_2.from_id
  GROUP BY users.id;
  
-- Общий запрос
SELECT users.id, users.name, got_likes, given_likes, cross_likes
  FROM users
  
  LEFT JOIN (
    SELECT to_id AS id, COUNT(to_id) AS got_likes 
      FROM likes
      GROUP BY to_id
  ) AS got_likes_request
      ON users.id = got_likes_request.id
    
  LEFT JOIN (
    SELECT from_id AS id, COUNT(from_id) AS given_likes
      FROM likes
      GROUP BY from_id
  ) AS given_likes_request
      ON users.id = given_likes_request.id
    
  LEFT JOIN (
    SELECT likes_1.from_id AS id, COUNT(likes_1.from_id) AS cross_likes
    FROM likes AS likes_1
      INNER JOIN likes as likes_2
        ON likes_1.from_id = likes_2.to_id
        AND likes_1.to_id = likes_2.from_id
      GROUP BY likes_1.from_id
  ) AS cross_likes_request
      ON users.id = cross_likes_request.id
;
  

-- Задача 2.  Выведите список всех пользователей,
-- которые поставили лайк пользователям A и B (2, 3),
-- но при этом не поставили лайк пользователю C (4)

SELECT users.id, users.name
  FROM users
  
  INNER JOIN likes AS take_1
    ON users.id = take_1.from_id
    AND take_1.to_id = 2
    
  INNER JOIN likes AS take_2
    ON users.id = take_2.from_id
    AND take_2.to_id = 3
    
  INNER JOIN (
    SELECT id, from_id
    FROM users 
    LEFT JOIN likes
      ON users.id = likes.from_id
      AND to_id = 4
  ) AS take_3
    ON users.id = take_3.id
    AND take_3.from_id IS NULL
;



