mysql> CREATE DATABASE UDB;
Query OK, 1 row affected (0.02 sec)

mysql> USE UDB;
Database changed
mysql> CREATE TABLE Students ( StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT, Major VARCHAR(50) );
Query OK, 0 rows affected (0.05 sec)

mysql> CREATE TABLE Courses ( CourseID INT PRIMARY KEY, CourseName VARCHAR(50), Credits INT );
Query OK, 0 rows affected (0.04 sec)

mysql> CREATE TABLE Enrollments ( EnrollmentID INT PRIMARY KEY, StudentID INT, CourseID INT, Grade CHAR(2), FOREIGN KEY (StudentID) REFERENCES Students(StudentID), FOREIGN KEY (CourseID) REFERENCES Courses(CourseID) );
Query OK, 0 rows affected (0.09 sec)

mysql> CREATE TABLE Departments ( DeptID INT PRIMARY KEY, DeptName VARCHAR(50) );
Query OK, 0 rows affected (0.11 sec)

mysql> INSERT INTO Students (StudentID, Name, Age, Major) VALUES (1, 'Alice', 20, 'Computer Science'), (2, 'Bob', 22, 'Data Science'), (3, 'Charlie', 19, 'AI'), (4, 'David', 21, 'Computer Science'), (5, 'Eva', 23, 'AI'), (6, 'Frank', 20, 'Data Science');
Query OK, 6 rows affected (0.02 sec)
Records: 6  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Courses (CourseID, CourseName, Credits) VALUES (101, 'Database Systems', 3), (102, 'Machine Learning', 4), (103, 'Operating Systems', 3);
Query OK, 3 rows affected (0.02 sec)
Records: 3  Duplicates: 0  Warnings: 0

mysql> INSERT INTO Enrollments (EnrollmentID, StudentID, CourseID, Grade) VALUES (1, 1, 101, 'A'), (2, 2, 102, 'B'), (3, 3, 101, 'A'), (4, 4, 103, 'C'), (5, 5, 102, 'A'), (6, 6, 101, 'B');
Query OK, 6 rows affected (0.01 sec)
Records: 6  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE Students ADD Email VARCHAR(100);
Query OK, 0 rows affected (0.04 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> DROP TABLE Departments;
Query OK, 0 rows affected (0.03 sec)

mysql> UPDATE Students SET Major = 'Data Science' WHERE StudentID = 1;
Query OK, 1 row affected (0.02 sec)
Rows matched: 1  Changed: 1  Warnings: 0

mysql> DELETE FROM Students WHERE Age < 18;
Query OK, 0 rows affected (0.00 sec)

mysql> SELECT Name, Major FROM Students WHERE Age > 19;
+-------+------------------+
| Name  | Major            |
+-------+------------------+
| Alice | Data Science     |
| Bob   | Data Science     |
| David | Computer Science |
| Eva   | AI               |
| Frank | Data Science     |
+-------+------------------+
5 rows in set (0.00 sec)

mysql> SELECT AVG(Age) AS AvgAge FROM Students;
+---------+
| AvgAge  |
+---------+
| 20.8333 |
+---------+
1 row in set (0.00 sec)

mysql> SELECT Major, COUNT(*) AS StudentCount FROM Students GROUP BY Major HAVING COUNT(*) > 1;
+--------------+--------------+
| Major        | StudentCount |
+--------------+--------------+
| Data Science |            3 |
| AI           |            2 |
+--------------+--------------+
2 rows in set (0.00 sec)

mysql> SELECT * FROM Students WHERE Age > 20 AND Major = 'Computer Science';
+-----------+-------+------+------------------+-------+
| StudentID | Name  | Age  | Major            | Email |
+-----------+-------+------+------------------+-------+
|         4 | David |   21 | Computer Science | NULL  |
+-----------+-------+------+------------------+-------+
1 row in set (0.00 sec)

mysql> SELECT Name, Grade, RANK() OVER (ORDER BY Grade DESC) AS RankInClass FROM Enrollments;
ERROR 1054 (42S22): Unknown column 'Name' in 'field list'
mysql> SELECT s.Name, c.CourseName FROM Students s INNER JOIN Enrollments e ON s.StudentID = e.StudentID INNER JOIN Courses c ON e.CourseID = c.CourseID;
+---------+-------------------+
| Name    | CourseName        |
+---------+-------------------+
| Alice   | Database Systems  |
| Bob     | Machine Learning  |
| Charlie | Database Systems  |
| David   | Operating Systems |
| Eva     | Machine Learning  |
| Frank   | Database Systems  |
+---------+-------------------+
6 rows in set (0.00 sec)

mysql> SELECT s.Name, c.CourseName FROM Students s LEFT JOIN Enrollments e ON s.StudentID = e.StudentID LEFT JOIN Courses c ON e.CourseID = c.CourseID;
+---------+-------------------+
| Name    | CourseName        |
+---------+-------------------+
| Alice   | Database Systems  |
| Bob     | Machine Learning  |
| Charlie | Database Systems  |
| David   | Operating Systems |
| Eva     | Machine Learning  |
| Frank   | Database Systems  |
+---------+-------------------+
6 rows in set (0.00 sec)

mysql> SELECT s.Name, c.CourseName FROM Students s CROSS JOIN Courses c;
+---------+-------------------+
| Name    | CourseName        |
+---------+-------------------+
| Alice   | Operating Systems |
| Alice   | Machine Learning  |
| Alice   | Database Systems  |
| Bob     | Operating Systems |
| Bob     | Machine Learning  |
| Bob     | Database Systems  |
| Charlie | Operating Systems |
| Charlie | Machine Learning  |
| Charlie | Database Systems  |
| David   | Operating Systems |
| David   | Machine Learning  |
| David   | Database Systems  |
| Eva     | Operating Systems |
| Eva     | Machine Learning  |
| Eva     | Database Systems  |
| Frank   | Operating Systems |
| Frank   | Machine Learning  |
| Frank   | Database Systems  |
+---------+-------------------+
18 rows in set (0.00 sec)

mysql> SELECT s1.Name AS Student1, s2.Name AS Student2 FROM Students s1 JOIN Students s2 ON s1.Major = s2.Major AND s1.StudentID <> s2.StudentID;
+----------+----------+
| Student1 | Student2 |
+----------+----------+
| Frank    | Alice    |
| Bob      | Alice    |
| Frank    | Bob      |
| Alice    | Bob      |
| Eva      | Charlie  |
| Charlie  | Eva      |
| Bob      | Frank    |
| Alice    | Frank    |
+----------+----------+
8 rows in set (0.00 sec)

mysql> SELECT Major, STRING_AGG(Name, ', ') AS Students FROM Students GROUP BY Major;
ERROR 1305 (42000): FUNCTION udb.STRING_AGG does not exist
mysql> SELECT Major, GROUP_CONCAT(Name, ', ') AS Students FROM Students GROUP BY Major;
+------------------+-----------------------+
| Major            | Students              |
+------------------+-----------------------+
| AI               | Charlie, ,Eva,        |
| Computer Science | David,                |
| Data Science     | Alice, ,Bob, ,Frank,  |
+------------------+-----------------------+
3 rows in set (0.00 sec)

mysql> SELECT Name FROM Students WHERE Age > (SELECT AVG(Age) FROM Students);
+-------+
| Name  |
+-------+
| Bob   |
| David |
| Eva   |
+-------+
3 rows in set (0.00 sec)

mysql> SELECT Name FROM Students s WHERE EXISTS (SELECT * FROM Enrollments e WHERE e.StudentID = s.StudentID AND e.Grade = 'A');
+---------+
| Name    |
+---------+
| Alice   |
| Charlie |
| Eva     |
+---------+
3 rows in set (0.00 sec)

mysql> SELECT Major, AvgAge FROM (SELECT Major, AVG(Age) AS AvgAge FROM Students GROUP BY Major) t;
+------------------+---------+
| Major            | AvgAge  |
+------------------+---------+
| Data Science     | 20.6667 |
| AI               | 21.0000 |
| Computer Science | 21.0000 |
+------------------+---------+
3 rows in set (0.00 sec)

mysql> SELECT Name FROM Students UNION SELECT CourseName FROM Courses;
+-------------------+
| Name              |
+-------------------+
| Alice             |
| Bob               |
| Charlie           |
| David             |
| Eva               |
| Frank             |
| Database Systems  |
| Machine Learning  |
| Operating Systems |
+-------------------+
9 rows in set (0.00 sec)

mysql> SELECT StudentID FROM Enrollments INTERSECT SELECT StudentID FROM Students;
+-----------+
| StudentID |
+-----------+
|         1 |
|         2 |
|         3 |
|         4 |
|         5 |
|         6 |
+-----------+
6 rows in set (0.00 sec)

mysql> SELECT StudentID FROM Students EXCEPT SELECT StudentID FROM Enrollments;
Empty set (0.00 sec)

mysql> ALTER TABLE Students ADD CONSTRAINT AgeCheck CHECK (Age >= 17);
Query OK, 6 rows affected (0.11 sec)
Records: 6  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE Students DROP CONSTRAINT AgeCheck;
Query OK, 0 rows affected (0.02 sec)
Records: 0  Duplicates: 0  Warnings: 0

mysql> BEGIN; INSERT INTO Enrollments VALUES (101, 1, 101, 'A'); UPDATE Students SET Major = 'AI' WHERE StudentID = 1; COMMIT;
Query OK, 0 rows affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)

Query OK, 1 row affected (0.00 sec)
Rows matched: 1  Changed: 1  Warnings: 0

Query OK, 0 rows affected (0.01 sec)

mysql> CREATE INDEX idx_student_major ON Students(Major); DROP INDEX idx_student_major;
Query OK, 0 rows affected (0.06 sec)
Records: 0  Duplicates: 0  Warnings: 0

ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '' at line 1
mysql> SELECT * FROM Students WHERE Major = 'Data Science';
+-----------+-------+------+--------------+-------+
| StudentID | Name  | Age  | Major        | Email |
+-----------+-------+------+--------------+-------+
|         2 | Bob   |   22 | Data Science | NULL  |
|         6 | Frank |   20 | Data Science | NULL  |
+-----------+-------+------+--------------+-------+
2 rows in set (0.00 sec)

mysql> SELECT Name, Age FROM Students ORDER BY Age DESC;
+---------+------+
| Name    | Age  |
+---------+------+
| Eva     |   23 |
| Bob     |   22 |
| David   |   21 |
| Alice   |   20 |
| Frank   |   20 |
| Charlie |   19 |
+---------+------+
6 rows in set (0.00 sec)

mysql> SELECT Name, Age FROM Students ORDER BY Age DESC, Name ASC;
+---------+------+
| Name    | Age  |
+---------+------+
| Eva     |   23 |
| Bob     |   22 |
| David   |   21 |
| Alice   |   20 |
| Frank   |   20 |
| Charlie |   19 |
+---------+------+
6 rows in set (0.00 sec)

mysql> SELECT * FROM Students LIMIT 5;
+-----------+---------+------+------------------+-------+
| StudentID | Name    | Age  | Major            | Email |
+-----------+---------+------+------------------+-------+
|         1 | Alice   |   20 | AI               | NULL  |
|         2 | Bob     |   22 | Data Science     | NULL  |
|         3 | Charlie |   19 | AI               | NULL  |
|         4 | David   |   21 | Computer Science | NULL  |
|         5 | Eva     |   23 | AI               | NULL  |
+-----------+---------+------+------------------+-------+
5 rows in set (0.00 sec)

mysql> SELECT TOP 5 * FROM Students;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near '5 * FROM Students' at line 1
mysql> SELECT * FROM Students FETCH FIRST 5 ROWS ONLY;
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'FETCH FIRST 5 ROWS ONLY' at line 1
mysql> WITH AvgAge AS (SELECT AVG(Age) AS AgeValue FROM Students) SELECT * FROM Students WHERE Age > (SELECT AgeValue FROM AvgAge);
+-----------+-------+------+------------------+-------+
| StudentID | Name  | Age  | Major            | Email |
+-----------+-------+------+------------------+-------+
|         2 | Bob   |   22 | Data Science     | NULL  |
|         4 | David |   21 | Computer Science | NULL  |
|         5 | Eva   |   23 | AI               | NULL  |
+-----------+-------+------+------------------+-------+
3 rows in set (0.00 sec)