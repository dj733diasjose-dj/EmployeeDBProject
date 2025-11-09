
-- EMPLOYEE MANAGEMENT SYSTEM
-- Created by: Dias Jose
-- Purpose: Demonstration SQL project 

-- 1?? Create a fresh database
--------------------------------------------------------------
-- Fix: Drop database safely if already exists
--------------------------------------------------------------
USE master;  -- switch away from EmployeeDB
GO

IF DB_ID('EmployeeDB') IS NOT NULL
BEGIN
    ALTER DATABASE EmployeeDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE EmployeeDB;
END
GO

CREATE DATABASE EmployeeDB;
GO

USE EmployeeDB;
GO



-- 2?? Drop tables if they already exist (safe re-run)

IF OBJECT_ID('Salaries', 'U') IS NOT NULL DROP TABLE Salaries;
IF OBJECT_ID('Employees', 'U') IS NOT NULL DROP TABLE Employees;
IF OBJECT_ID('Departments', 'U') IS NOT NULL DROP TABLE Departments;
GO

-- 3?? Create Tables


CREATE TABLE Departments (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);
GO

CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Gender VARCHAR(10),
    DOB DATE,
    DeptID INT,
    JoiningDate DATE,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);
GO

CREATE TABLE Salaries (
    SalaryID INT PRIMARY KEY,
    EmpID INT,
    BaseSalary DECIMAL(10,2),
    Bonus DECIMAL(10,2),
    FOREIGN KEY (EmpID) REFERENCES Employees(EmpID)
);
GO


-- 4?? Insert Sample Data

INSERT INTO Departments VALUES
(1, 'IT', 'Mumbai'),
(2, 'HR', 'Delhi'),
(3, 'Finance', 'Bangalore');
GO

INSERT INTO Employees VALUES
(101, 'Dias Jose', 'Male', '1995-02-15', 1, '2020-03-01'),
(102, 'Kalyani Priyadarshan', 'Female', '1998-07-22', 2, '2021-06-12'),
(103, 'Gokul Manoharan', 'Male', '1990-09-10', 1, '2018-01-05'),
(104, 'Kajal Agarwal', 'Female', '1997-11-28', 3, '2019-09-20');
GO

INSERT INTO Salaries VALUES
(1, 101, 50000, 5000),
(2, 102, 45000, 3000),
(3, 103, 60000, 8000),
(4, 104, 55000, 4000);
GO


-- 5?? Queries (Reports / Analytics)


-- 1. View all employee details with department names
SELECT 
    e.EmpID,
    e.EmpName,
    e.Gender,
    d.DeptName,
    d.Location,
    e.JoiningDate
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID;
GO

-- 2. Calculate total salary for each employee
SELECT 
    e.EmpName,
    s.BaseSalary,
    s.Bonus,
    (s.BaseSalary + s.Bonus) AS TotalSalary
FROM Employees e
JOIN Salaries s ON e.EmpID = s.EmpID;
GO

-- 3. Employees who joined after 2020
SELECT EmpName, JoiningDate 
FROM Employees 
WHERE YEAR(JoiningDate) > 2020;
GO

-- 4. Average salary per department
SELECT 
    d.DeptName,
    AVG(s.BaseSalary + s.Bonus) AS AvgSalary
FROM Employees e
JOIN Salaries s ON e.EmpID = s.EmpID
JOIN Departments d ON e.DeptID = d.DeptID
GROUP BY d.DeptName;
GO

-- 5. Highest-paid employee
SELECT TOP 1 
    e.EmpName, 
    (s.BaseSalary + s.Bonus) AS TotalSalary
FROM Employees e
JOIN Salaries s ON e.EmpID = s.EmpID
ORDER BY TotalSalary DESC;
GO


-- 6?? Create a View (for HR Reporting)


IF OBJECT_ID('EmployeeSalaryView', 'V') IS NOT NULL DROP VIEW EmployeeSalaryView;
GO

CREATE VIEW EmployeeSalaryView AS
SELECT 
    e.EmpName,
    d.DeptName,
    s.BaseSalary,
    s.Bonus,
    (s.BaseSalary + s.Bonus) AS TotalSalary
FROM Employees e
JOIN Departments d ON e.DeptID = d.DeptID
JOIN Salaries s ON e.EmpID = s.EmpID;
GO

-- View all data from the view
SELECT * FROM EmployeeSalaryView;
GO


