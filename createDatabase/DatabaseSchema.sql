-- Create database
CREATE DATABASE LeaveManagement;
GO
USE LeaveManagement;
GO

-- Create Roles table
CREATE TABLE Roles (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name NVARCHAR(50) NOT NULL
);

-- Create Features table
CREATE TABLE Features (
    feature_id INT PRIMARY KEY IDENTITY(1,1),
    feature_name NVARCHAR(100) NOT NULL
);

-- Create Users table 
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) UNIQUE NOT NULL,
    password NVARCHAR(256) NOT NULL, -- Hashed password
    full_name NVARCHAR(100) NOT NULL,
    department_id INT,
    manager_id INT,
    role_id INT NOT NULL,
    email NVARCHAR(100)
);

-- Create Departments table 
CREATE TABLE Departments (
    department_id INT PRIMARY KEY IDENTITY(1,1),
    department_name NVARCHAR(100) NOT NULL,
    id_manager INT
);

-- Create Role_Features table
CREATE TABLE Role_Features (
    role_id INT,
    feature_id INT,
    PRIMARY KEY (role_id, feature_id)
);

-- Create Leave_Requests table
CREATE TABLE Leave_Requests (
    request_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    reason NVARCHAR(500),
    status NVARCHAR(20) NOT NULL CHECK (status IN ('Inprogress', 'Approved', 'Rejected')),
    processed_by INT,
    processed_reason NVARCHAR(500),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- Create Agenda table
CREATE TABLE Agenda (
    agenda_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    date DATE NOT NULL,
    status NVARCHAR(20) NOT NULL CHECK (status IN ('Working', 'OnLeave')),
    UNIQUE (user_id, date)
);

-- Create Access_Scope table
CREATE TABLE Access_Scope (
    access_id INT PRIMARY KEY IDENTITY(1,1),
    accessor_id INT NOT NULL,
    target_user_id INT,
    target_department_id INT,
    permission_type NVARCHAR(20) NOT NULL CHECK (permission_type IN ('View', 'Process')),
    expiry_date DATE, -- Access expiration date
    CHECK (target_user_id IS NOT NULL OR target_department_id IS NOT NULL)
);

ALTER TABLE Users
ADD 
    FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    FOREIGN KEY (manager_id) REFERENCES Users(user_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id);

-- Add foreign key to Departments
ALTER TABLE Departments
ADD FOREIGN KEY (id_manager) REFERENCES Users(user_id);

-- Add foreign keys to Role_Features
ALTER TABLE Role_Features
ADD 
    FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    FOREIGN KEY (feature_id) REFERENCES Features(feature_id);

-- Add foreign keys to Leave_Requests
ALTER TABLE Leave_Requests
ADD 
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (processed_by) REFERENCES Users(user_id);

-- Add foreign key to Agenda
ALTER TABLE Agenda
ADD FOREIGN KEY (user_id) REFERENCES Users(user_id);

-- Add foreign keys to Access_Scope
ALTER TABLE Access_Scope
ADD 
    FOREIGN KEY (accessor_id) REFERENCES Users(user_id),
    FOREIGN KEY (target_user_id) REFERENCES Users(user_id),
    FOREIGN KEY (target_department_id) REFERENCES Departments(department_id);