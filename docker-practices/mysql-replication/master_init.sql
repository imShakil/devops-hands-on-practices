CREATE USER IF NOT EXISTS 'replication_user'@'%' IDENTIFIED WITH mysql_native_password BY 'Mh@006';
GRANT REPLICATION SLAVE ON *.* TO 'replication_user'@'%';
FLUSH PRIVILEGES;
