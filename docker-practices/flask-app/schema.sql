USE mydb;
CREATE TABLE IF NOT EXISTS user(userId INT NOT NULL, username VARCHAR(100) NOT NULL);
INSERT INTO mydb.user(userId, username) VALUES(1,'xiaoming');
INSERT INTO mydb.user(userId, username) VALUES(2,'xiaobai');
CREATE TABLE IF NOT EXISTS tasks(id INT AUTO_INCREMENT PRIMARY KEY, title VARCHAR(255) NOT NULL, description TEXT);
INSERT INTO mydb.tasks(title, description) VALUES('Task 1', 'Description of task 1'), ('Task 2', 'Description of task 2'), ('Task 3', 'Description of task 3');
