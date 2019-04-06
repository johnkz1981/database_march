-- Создать таблицу с явным определением движка
CREATE TABLE example (a INT, b INT)) ENGINE=MYISAM RAW_FORMAT=STATIC;

-- Создание дампа
# mysqldump -u root -p geodata > ./backups/geodata.sql

-- Дамп для InnoDB
# mysqldump --single_transaction -u root -p geodata > ./backups/geodata.sql

-- Дамп структуры без данных
# mysqldump --no-data -u root -p geodata > ./backups/geodata.sql

-- Дапм одной таблицы
# mysqldump -u root -p geodata _countries > ./backups/geodata_countries.sql

-- Сжатый дамп
# mysqldump -u root -p geodata | gzip > ./backups/geodata_archived.sql.gz

-- Восстановление из дампа
# mysql -u root -p geodata < ./backups/geodata.sql

-- Создание пользователя
CREATE USER newuser@localhost IDENTIFIED BY 'password';

-- Сщздание пользователя с правом регистрации из определённой сети
CREATE USER 'newuser'@'192.168.56.%' IDENTIFIED BY 'password';

-- Проверка текущего пользователя
SELECT USER();

-- Просмотр пользователей системы
SELECT Host, User FROM mysql.user;

-- Выдача прав
GRANT ALL [PRIVILEGES] ON *.* TO 'newuser'@'localhost';

-- Применение изменений по правам
FLUSH PRIVILEGES;

-- Отозвать права
REVOKE ALL ON *.* FROM newuser@localhost;

-- Выдача прав с определением конкретной таблицы
GRANT SELECT ON geodata._countries TO 'newuser'@'localhost';

-- Удаление пользователя
DROP USER 'newuser'@'localhost';






