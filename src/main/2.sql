CREATE TABLE Users (
    id INT PRIMARY KEY NOT NULL,
    realName VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'student'
);
INSERT INTO Users (id, realName, password, role) VALUES
(1001, '张伟', 'password123', 'student'),
(1002, '李娜', 'securepass456', 'teacher'),
(1003, '王强', 'mypassword789', 'admin'),
(1004, '刘洋', 'pass1234', 'student'),
(1005, '陈静', 'greenpass567', 'teacher');