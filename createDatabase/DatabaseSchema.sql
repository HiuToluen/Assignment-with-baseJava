-- Create database
CREATE DATABASE LeaveManagement;
GO

USE LeaveManagement;
GO

CREATE TABLE Roles (
    role_id INT PRIMARY KEY IDENTITY(1,1),
    role_name NVARCHAR(50) NOT NULL
);

-- Create Features table with entrypoint
CREATE TABLE Features (
    feature_id INT PRIMARY KEY IDENTITY(1,1),
    feature_name NVARCHAR(100) NOT NULL,
    entrypoint NVARCHAR(255), -- URL or endpoint path
    CONSTRAINT UQ_Features_Name UNIQUE (feature_name)
);

-- Create Departments table with specific departments
CREATE TABLE Departments (
    department_id INT PRIMARY KEY IDENTITY(1,1),
    department_name NVARCHAR(100) NOT NULL,
    id_manager INT
);

-- Create Users table (without is_admin, username unique)
CREATE TABLE Users (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) UNIQUE NOT NULL, -- Ensure uniqueness
    password NVARCHAR(256) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    manager_id INT,
    email NVARCHAR(100)
);

-- Create Role_Features table
CREATE TABLE Role_Features (
    role_id INT NOT NULL,
    feature_id INT NOT NULL,
    PRIMARY KEY (role_id, feature_id)
);

-- Create User_Roles table
CREATE TABLE User_Roles (
    user_role_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    assigned_by INT NOT NULL,
    assigned_at DATETIME DEFAULT GETDATE()
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
    CONSTRAINT UQ_Agenda_User_Date UNIQUE (user_id, date)
);

-- Create Access_Scope table
CREATE TABLE Access_Scope (
    access_id INT PRIMARY KEY IDENTITY(1,1),
    accessor_id INT NOT NULL,
    target_user_id INT,
    target_department_id INT,
    permission_type NVARCHAR(20) NOT NULL CHECK (permission_type IN ('View', 'Process')),
    expiry_date DATE,
    CONSTRAINT CHK_Access_Scope_Target CHECK (target_user_id IS NOT NULL OR target_department_id IS NOT NULL)
);

-- Add foreign keys after all tables are created
ALTER TABLE Users
ADD CONSTRAINT FK_Users_Department FOREIGN KEY (department_id) REFERENCES Departments(department_id),
    CONSTRAINT FK_Users_Manager FOREIGN KEY (manager_id) REFERENCES Users(user_id);

ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_Manager FOREIGN KEY (id_manager) REFERENCES Users(user_id);

ALTER TABLE Role_Features
ADD CONSTRAINT FK_Role_Features_Role FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    CONSTRAINT FK_Role_Features_Feature FOREIGN KEY (feature_id) REFERENCES Features(feature_id);

ALTER TABLE User_Roles
ADD CONSTRAINT FK_User_Roles_User FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_User_Roles_Role FOREIGN KEY (role_id) REFERENCES Roles(role_id),
    CONSTRAINT FK_User_Roles_AssignedBy FOREIGN KEY (assigned_by) REFERENCES Users(user_id);

ALTER TABLE Leave_Requests
ADD CONSTRAINT FK_Leave_Requests_User FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Leave_Requests_ProcessedBy FOREIGN KEY (processed_by) REFERENCES Users(user_id);

ALTER TABLE Agenda
ADD CONSTRAINT FK_Agenda_User FOREIGN KEY (user_id) REFERENCES Users(user_id);

ALTER TABLE Access_Scope
ADD CONSTRAINT FK_Access_Scope_Accessor FOREIGN KEY (accessor_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Access_Scope_TargetUser FOREIGN KEY (target_user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Access_Scope_TargetDept FOREIGN KEY (target_department_id) REFERENCES Departments(department_id);

ALTER TABLE User_Roles
DROP CONSTRAINT FK_User_Roles_User;
GO

ALTER TABLE User_Roles
ADD CONSTRAINT FK_User_Roles_User
FOREIGN KEY (user_id)
REFERENCES Users(user_id)
ON DELETE CASCADE;
GO