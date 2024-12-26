-- create table
CREATE TABLE User (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    Age INT
);

-- insert data
INSERT INTO Users (ID, Name, Age) VALUES (1, 'Alice', 20);
INSERT INTO Users (ID, Name, Age) VALUES (2, 'Bob', 25);

-- select data
SELECT * FROM Users WHERE Age > 20;

-- update data
UPDATE Users SET Age = 30 WHERE ID = 1;

-- delete data
DELETE FROM Users WHERE ID = 2;