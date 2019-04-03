-- DevOps

-- Репликация

-- Master MySQL Server: 192.168.56.101
-- Slave MySQL Server:  192.168.56.102

-- Настройка мастера:

$ sudo vim /etc/mysql/my.cnf

[mysqld]
server-id = 1
log-bin = /var/log/mysql/mysql-bin.log
tmpdir = /tmp
binlog_format = ROW
max_binlog_size = 500M
sync_binlog = 1
expire-logs-days = 7
slow_query_log

-- Перезапускаем сервер мастера

$ sudo systemctl restart mysql

-- Создание пользователя, под которым будет выполняться репликация 

mysql -u root -p

mysql> create user rpl_user@192.168.56.102 identified by 'password';

mysql> grant replication slave on *.* to rpl_user@192.168.56.102;

mysql> flush privileges;

-- Проверим, что права действительно выданы:

mysql> show grants for replica_user@192.168.56.102;

-- Создать базу данных и дамп.

mysql> CREATE DATABASE papers;
mysql> USE papers;
mysql> FLUSH TABLES WITH READ LOCK;

mysqldump -u root -p papers > papers.sql

mysql> UNLOCK TABLES;

-- Копируем дамп на слейв:

scp papers.sql victor@192.168.56.102:

-- Настройка слейва

$ sudo vim /etc/mysql/my.cnf

log_bin = /var/log/mysql/mysql-bin.log
server-id = 2
read_only = 1
tmpdir = /tmp
binlog_format = ROW
max_binlog_size = 500M
sync_binlog = 1
expire-logs-days = 7
slow_query_log   = 1

-- Перезапускаем слейв

$ sudo systemctl restart mysql

-- Инициализируем процесс репликации:

-- Сначала на мастере проверяем статус:
-- Обратите внимаяние на первые две строки вывода

mysql> show master status\G
*************************** 1. row ***************************
File: mysql-bin.000002
Position: 155
Binlog_Do_DB: 
Binlog_Ignore_DB: 
Executed_Gtid_Set: 
1 row in set (0.00 sec)


-- На слейве выполняем:

root@node-02:~# mysql -u root -p

-- Подставляем учётную запись пользователя и параметры лог файла (MASTER_LOG_FILE и MASTER_LOG_POS)

mysql> CHANGE MASTER TO MASTER_HOST='192.168.56.101',
-> MASTER_USER='rpl_user',
-> MASTER_PASSWORD='password',
-> MASTER_LOG_FILE='mysql-bin.000002',
-> MASTER_LOG_POS=155;

-- Создаём базу данных

mysql> CREATE DATABASE papers;
mysql> mysql -u root -p papers < papers.sql

-- Запускаем репликацию на слейве:

mysql> start slave;
Query OK, 0 rows affected (0.06 sec)
To check slave status, use:

-- Проверяем статус слейва:

mysql> show slave status\G
*************************** 1. row ***************************
               Slave_IO_State: Waiting for master to send event
                  Master_Host: 10.131.74.92
                  Master_User: rpl_user
                  Master_Port: 3306
                Connect_Retry: 60
              Master_Log_File: mysql-bin.000002
          Read_Master_Log_Pos: 550
               Relay_Log_File: node-02-relay-bin.000002
                Relay_Log_Pos: 717
        Relay_Master_Log_File: mysql-bin.000002
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes
              Replicate_Do_DB: 
          Replicate_Ignore_DB: 
           Replicate_Do_Table: 
       Replicate_Ignore_Table: 
      Replicate_Wild_Do_Table: 
  Replicate_Wild_Ignore_Table: 
                   Last_Errno: 0
                   Last_Error: 
                 Skip_Counter: 0
          Exec_Master_Log_Pos: 550
              Relay_Log_Space: 927
              Until_Condition: None
               Until_Log_File: 
                Until_Log_Pos: 0
           Master_SSL_Allowed: No
           Master_SSL_CA_File: 
           Master_SSL_CA_Path: 
              Master_SSL_Cert: 
            Master_SSL_Cipher: 
               Master_SSL_Key: 
        Seconds_Behind_Master: 0
Master_SSL_Verify_Server_Cert: No
                Last_IO_Errno: 0
                Last_IO_Error: 
               Last_SQL_Errno: 0
               Last_SQL_Error: 
  Replicate_Ignore_Server_Ids: 
             Master_Server_Id: 1
                  Master_UUID: d62cd5d2-784a-11e8-9768-eacea5a1be5e
             Master_Info_File: mysql.slave_master_info
                    SQL_Delay: 0
          SQL_Remaining_Delay: NULL
      Slave_SQL_Running_State: Slave has read all relay log; waiting for more updates
           Master_Retry_Count: 86400
                  Master_Bind: 
      Last_IO_Error_Timestamp: 
     Last_SQL_Error_Timestamp: 
               Master_SSL_Crl: 
           Master_SSL_Crlpath: 
           Retrieved_Gtid_Set: 
            Executed_Gtid_Set: 
                Auto_Position: 0
         Replicate_Rewrite_DB: 
                 Channel_Name: 
           Master_TLS_Version: 
       Master_public_key_path: 
        Get_master_public_key: 0
1 row in set (0.00 sec)
Slave IO and SQL should indicate running state:

Slave_IO_Running: Yes
Slave_SQL_Running: Yes




-- Настройка кластера

-- Заходим в MySQL Shell
sudo mysqlsh

-- Создаём 3 сервера в песочнице
dba.deploySandboxInstance(3310);
dba.deploySandboxInstance(3320);
dba.deploySandboxInstance(3330);

-- Присоединяемся к первому
shell.connect(“root@localhost:3310”);
-- Создаём кластер

cluster = dba.createCluster(‘mycluster’);

-- добавляем остальные инстансы в кластер
cluster.addInstance(“root@localhost:3320”);
cluster.addInstance(“root@localhost:3330”);

-- Смотрим статус кластера
cluster.status();

-- На Линуксе можем посмотреть процессы (в терминале)
ps -ef|grep mysqld

-- И посмотреть саму песочницу
cd ~/mysql-sandboxes

-- Убедимся, что роутер пока не запущен
ps -ef|grep router

-- Созданим новый роутер
mysqlrouter --bootstrap root@localhost:3310 --directory /tmp/myrouter

-- Запустим роутер
cd /tmp/myrouter/
./start.sh

-- Проверим, что роутер запустился (должен быть процесс с именем выбранной директории)
ps -ef|grep router

-- Подключимся к роутеру 
sudo mysqlsh –uri root@localhost:6446

-- Переходим в SQL режим
\sql

-- Проверяем, на что указывает роутер
select @@port;

-- переходим в JS режим
\js

-- Присоединяемся к первому инстансу кластера
shell.connect(“root@localhost:3310”);

-- Проверяем статус кластера
cluster=dba.getCluster();
cluster.status();

-- Проверяем работу кластера
-- Создаём БД и таблицу на одном инстансе, и проверяем что они появляются на всех инстансах
mysql -uroot -p -P3310 -h127.0.0.1
mysql -uroot -p -P3320 -h127.0.0.1
mysql -uroot -p -P3330 -h127.0.0.1

show databases;
create database test_01;
use test_01;
show tables;


-- Проверяем отказоустойчивость кластера
-- Останавливаем один инстанс
sudo mysqlsh
shell.connect(“root@localhost:6446”);
dba.killSandboxInstance(3310);

-- Проверяем на что указывает роутер теперь
\sql
select @@port;

-- Смотрим статус кластера
\js
cluster=dba.getCluster();
cluster.status();

-- Запускаем остановленный инстанс опять
-- и проверяем статус кластера
dba.startSandboxInstance(3310);
cluster.status();





