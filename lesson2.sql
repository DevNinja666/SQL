IF DB_ID('HospitalDB') IS NOT NULL DROP DATABASE HospitalDB
CREATE DATABASE HospitalDB
GO
USE HospitalDB

CREATE TABLE Buildings(
Id INT IDENTITY PRIMARY KEY,
Name NVARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE Departments(
Id INT IDENTITY PRIMARY KEY,
Name NVARCHAR(100) NOT NULL,
BuildingId INT NOT NULL,
Floor INT NOT NULL CHECK(Floor>=1),
Financing MONEY NOT NULL CHECK(Financing>=0),
FOREIGN KEY(BuildingId) REFERENCES Buildings(Id)
)

CREATE TABLE Doctors(
Id INT IDENTITY PRIMARY KEY,
Name NVARCHAR(100) NOT NULL,
Surname NVARCHAR(100) NOT NULL,
Phone CHAR(10),
Salary MONEY NOT NULL CHECK(Salary>0),
Bonus MONEY NOT NULL CHECK(Bonus>=0),
DepartmentId INT NOT NULL,
FOREIGN KEY(DepartmentId) REFERENCES Departments(Id)
)

CREATE TABLE Patients(
Id INT IDENTITY PRIMARY KEY,
Name NVARCHAR(100) NOT NULL,
Surname NVARCHAR(100) NOT NULL,
Gender CHAR(1) CHECK(Gender IN('M','F')),
BirthDate DATE NOT NULL,
Phone CHAR(10)
)

CREATE TABLE Diseases(
Id INT IDENTITY PRIMARY KEY,
Name NVARCHAR(100) NOT NULL UNIQUE,
Severity INT NOT NULL CHECK(Severity BETWEEN 1 AND 5)
)

CREATE TABLE Rooms(
Id INT IDENTITY PRIMARY KEY,
RoomNumber INT NOT NULL,
Floor INT NOT NULL,
DepartmentId INT NOT NULL,
Capacity INT NOT NULL CHECK(Capacity>0),
FOREIGN KEY(DepartmentId) REFERENCES Departments(Id)
)

CREATE TABLE Examinations(
Id INT IDENTITY PRIMARY KEY,
PatientId INT NOT NULL,
DoctorId INT NOT NULL,
RoomId INT NOT NULL,
DiseaseId INT NOT NULL,
ExamDate DATE NOT NULL,
ExamTime TIME NOT NULL,
Price MONEY NOT NULL CHECK(Price>0),
FOREIGN KEY(PatientId) REFERENCES Patients(Id),
FOREIGN KEY(DoctorId) REFERENCES Doctors(Id),
FOREIGN KEY(RoomId) REFERENCES Rooms(Id),
FOREIGN KEY(DiseaseId) REFERENCES Diseases(Id)
)

CREATE TABLE Treatments(
Id INT IDENTITY PRIMARY KEY,
ExaminationId INT NOT NULL,
Description NVARCHAR(200) NOT NULL,
Cost MONEY NOT NULL CHECK(Cost>0),
FOREIGN KEY(ExaminationId) REFERENCES Examinations(Id)
)

INSERT INTO Buildings VALUES ('A'),('B'),('C')

INSERT INTO Departments VALUES
('Cardiology',1,2,50000),
('Neurology',1,3,40000),
('Oncology',2,1,60000),
('Surgery',3,4,80000)

INSERT INTO Doctors VALUES
('Ivan','Petrov','0551111111',1500,300,1),
('Anna','Sidorova','0552222222',1800,500,2),
('Ali','Mammadov','0553333333',2000,700,3),
('Leyla','Huseynova','0554444444',2200,900,4)

INSERT INTO Patients VALUES
('Elvin','Aliyev','M','1988-05-12','0501111111'),
('Nigar','Ismayilova','F','1992-10-01','0502222222'),
('Kamran','Rahimov','M','1975-03-22','0503333333'),
('Aysel','Quliyeva','F','2000-07-15','0504444444')

INSERT INTO Diseases VALUES
('Flu',1),
('Heart Attack',5),
('Cancer',5),
('Migraine',2)

INSERT INTO Rooms VALUES
(101,1,1,3),
(102,1,1,2),
(201,2,2,3),
(301,3,3,4),
(401,4,4,5)

INSERT INTO Examinations VALUES
(1,1,101,1,'2026-01-10','10:00',50),
(2,2,201,4,'2026-01-10','11:30',80),
(3,3,301,3,'2026-01-11','09:00',200),
(4,4,401,2,'2026-01-12','14:00',300)

INSERT INTO Treatments VALUES
(1,'Medication',20),
(2,'MRI',100),
(3,'Chemotherapy',500),
(4,'Heart surgery',2000)

SELECT d.Name,d.Surname,d.Salary+d.Bonus AS TotalIncome FROM Doctors d

SELECT dep.Name,SUM(d.Salary+d.Bonus) FROM Doctors d
JOIN Departments dep ON d.DepartmentId=dep.Id
GROUP BY dep.Name

SELECT r.RoomNumber,COUNT(e.Id) FROM Rooms r
LEFT JOIN Examinations e ON r.Id=e.RoomId
GROUP BY r.RoomNumber

SELECT p.Name,p.Surname,dis.Name,e.ExamDate,e.ExamTime
FROM Examinations e
JOIN Patients p ON e.PatientId=p.Id
JOIN Diseases dis ON e.DiseaseId=dis.Id

SELECT dep.Name,COUNT(e.Id) 
FROM Examinations e
JOIN Rooms r ON e.RoomId=r.Id
JOIN Departments dep ON r.DepartmentId=dep.Id
GROUP BY dep.Name

SELECT Name,Surname FROM Doctors
WHERE Salary > (SELECT AVG(Salary) FROM Doctors)

SELECT Name,Surname FROM Patients
WHERE Id IN
(SELECT PatientId FROM Examinations WHERE Price>100)

SELECT dep.Name,SUM(e.Price)
FROM Examinations e
JOIN Rooms r ON e.RoomId=r.Id
JOIN Departments dep ON r.DepartmentId=dep.Id
GROUP BY dep.Name
