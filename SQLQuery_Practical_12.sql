--Create the database Employee Management 
CREATE DATABASE EmployeeManagement;

--Use the EmployeeManagement database
USE EmployeeManagement;

--Task 1: Basic Employee Table

--Create the Employee table in the EmployeeManagement database
CREATE TABLE Employee (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50) NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    MobileNumber VARCHAR(10) NOT NULL,
    Address VARCHAR(100) NULL
);

--Insert the values in the Employeee table.
INSERT INTO Employee (FirstName, MiddleName, LastName, DOB, MobileNumber, Address)
VALUES
('John', 'A', 'Doe', '1990-05-15', '9876543210', '123 Main St'),
('Jane', NULL, 'Smith', '1988-11-23', '9123456789', '456 Oak Ave'),
('Robert', 'B', 'Brown', '1992-03-10', '9001234567', '789 Pine Rd'),
('Emily', NULL, 'Clark', '1995-07-28', '8899988776', '321 Elm St'),
('Michael', 'C', 'Davis', '1987-01-02', '9988776655', '654 Maple Blvd'),
('Sarah', NULL, 'Johnson', '1993-12-19', '9776655443', '987 Birch Ln'),
('David', 'K', 'Wilson', '1991-04-17', '9332211445', '231 Cedar St'),
('Olivia', NULL, 'Taylor', '1994-08-05', '9223344556', '876 Spruce Dr'),
('James', 'M', 'Anderson', '1989-09-12', '9112233445', '145 Redwood Ct'),
('Sophia', NULL, 'Thomas', '1996-06-30', '9099887766', '369 Willow Way');

--Task 2: Employee Table with Identity and Salary
CREATE TABLE Employee1 (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50) NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    MobileNumber VARCHAR(10) NOT NULL,
    Address VARCHAR(100) NULL,
    Salary DECIMAL(18, 2) NOT NULL
);

--Insert records into Employee1 table
INSERT INTO Employee1 (FirstName, MiddleName, LastName, DOB, MobileNumber, Address, Salary) VALUES 
('John', 'A', 'Doe', '1990-05-21', '9876543210', 'New York', 50000.00),
('Alice', NULL, 'Smith', '1985-08-15', '1234567890', 'Los Angeles', 60000.00),
('Bob', 'C', 'Williams', '1992-02-10', '5556667777', 'Chicago', 55000.00),
('David', 'M', 'Brown', '1988-11-25', '9988776655', 'Houston', 70000.00),
('Emma', NULL, 'Johnson', '1995-07-19', '7788994455', 'San Francisco', 62000.00),
('Michael', 'J', 'Miller', '1983-06-05', '6655443322', 'Boston', 80000.00),
('Sophia', 'R', 'Davis', '1991-09-30', '8899776655', 'Seattle', 48000.00),
('Liam', 'T', 'Wilson', '1994-04-10', '1122334455', 'Dallas', 53000.00),
('Olivia', NULL, 'Anderson', '1989-03-14', '2233445566', 'Atlanta', 75000.00),
('Ethan', 'K', 'Thomas', '1996-12-20', '3344556677', 'Denver', 67000.00);

--Task 3: Employee with Designation (Foreign Key Relationship)

-- Create Table 1: Designation
CREATE TABLE Designation (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    Designation VARCHAR(50) NOT NULL
);

--Insert the values in Designation table
INSERT INTO Designation (Designation)
VALUES 
('Senior Software Engineer'),
('Team Lead'),
('HR Manager');

-- Create Table 2: Employee
CREATE TABLE Employee2 (
    Id INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    FirstName VARCHAR(50) NOT NULL,
    MiddleName VARCHAR(50) NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    MobileNumber VARCHAR(10) NOT NULL,
    Address VARCHAR(100) NULL,
    Salary DECIMAL(18,2) NOT NULL,
    DesignationId INT NULL,
    FOREIGN KEY (DesignationId) REFERENCES Designation(Id)
);

INSERT INTO Employee2 (FirstName, MiddleName, LastName, DOB, MobileNumber, Address, Salary, DesignationId) 
VALUES 
('John', 'A', 'Doe', '1990-05-10', '9876543210', '123 Street, NY', 75000, 1),
('Jane', NULL, 'Smith', '1985-08-15', '9123456789', '456 Road, LA', 90000, 2),
('Mike', 'B', 'Johnson', '1992-03-22', '9988776655', '789 Avenue, TX', 80000, 1),
('Sara', NULL, 'Wilson', '1995-07-18', '9776655443', NULL, 70000, 1);

--Create View 
CREATE VIEW vw_EmployeeDetailsView AS
SELECT 
    E.Id AS EmployeeId,
    E.FirstName,
    E.MiddleName,
    E.LastName,
    D.Designation,
    E.DOB,
    E.MobileNumber,
    E.Address,
    E.Salary
FROM 
    Employee2 E
LEFT JOIN 
    Designation D ON E.DesignationId = D.Id;

--Select from View
SELECT * FROM vw_EmployeeDetailsView;

--Insert Designation SP
CREATE PROCEDURE sp_InsertDesignation
    @Designation VARCHAR(50)
AS
BEGIN
    INSERT INTO Designation (Designation)
    VALUES (@Designation);
END;

--Insert Employee SP
CREATE PROCEDURE InsertEmployee
    @FirstName VARCHAR(50),
    @MiddleName VARCHAR(50) = NULL,
    @LastName VARCHAR(50),
    @DOB DATE,
    @MobileNumber VARCHAR(10),
    @Address VARCHAR(100) = NULL,
    @Salary DECIMAL(18,2),
    @DesignationId INT = NULL
AS
BEGIN
    INSERT INTO Employee2 (
        FirstName,
        MiddleName,
        LastName,
        DOB,
        MobileNumber,
        Address,
        Salary,
        DesignationId
    )
    VALUES (
        @FirstName,
        @MiddleName,
        @LastName,
        @DOB,
        @MobileNumber,
        @Address,
        @Salary,
        @DesignationId
    );
END;

--List of Employees SP 
CREATE PROCEDURE GetEmployeeDetailsOrderedByDOB
AS
BEGIN
    SELECT 
        E.Id AS [EmployeeId],
        E.FirstName,
        E.MiddleName,
        E.LastName,
        D.Designation,
        E.DOB,
        E.MobileNumber,
        E.Address,
        E.Salary
    FROM 
        Employee2 E
    LEFT JOIN 
        Designation D ON E.DesignationId = D.Id
    ORDER BY 
        E.DOB;
END;

--Get employee based on DesignationId SP
CREATE PROCEDURE GetEmployeesByDesignationId
    @DesignationId INT
AS
BEGIN
    SELECT 
        E.Id AS [EmployeeId],
        E.FirstName,
        E.MiddleName,
        E.LastName,
        E.DOB,
        E.MobileNumber,
        E.Address,
        E.Salary
    FROM 
        Employee2 E
    WHERE 
        E.DesignationId = @DesignationId
    ORDER BY 
        E.FirstName;
END;

EXEC GetEmployeesByDesignationId @DesignationId = 2;

--Create Non-Clustered index on the DesignationId column of the Employee table
CREATE NONCLUSTERED INDEX IX_Employee_DesignationId
ON Employee2 (DesignationId);


