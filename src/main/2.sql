CREATE TABLE Users (
    id INT PRIMARY KEY NOT NULL,
    realName VARCHAR(50) NOT NULL,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'student'
);
INSERT INTO Users (id, realName, password, role) VALUES
(1001, 'Student_01', 'password123', 'student'),
(1002, 'Teacher_01', 'securepass456', 'teacher'),
(1003, 'Admin', 'mypassword789', 'admin'),
(1004, 'Student_02', 'pass1234', 'student'),
(1005, 'Teacher_02', 'greenpass567', 'teacher');