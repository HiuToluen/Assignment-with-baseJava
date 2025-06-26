-- Insert roles (4 fixed roles)
INSERT INTO Roles (role_name) VALUES
('Employee'), ('Manager'), ('Department Manager'), ('Director');

-- Insert features with entrypoint
INSERT INTO Features (feature_name, entrypoint) VALUES
('Create Leave Request', '/request/create'),
('View Subordinate Requests', '/request/view-subordinates'),
('View Agenda', '/agenda');

-- Insert role-feature mappings
INSERT INTO Role_Features (role_id, feature_id) VALUES
(1, 1), -- Employee: Create Leave Request
(1, 3), -- Employee: View Agenda
(2, 1), -- Manager: Create Leave Request
(2, 2), -- Manager: View Subordinate Requests
(2, 3), -- Manager: View Agenda
(3, 1), -- Department Manager: Create Leave Request
(3, 2), -- Department Manager: View Subordinate Requests
(3, 3), -- Department Manager: View Agenda
(4, 1), -- Director: Create Leave Request
(4, 2), -- Director: View Subordinate Requests
(4, 3); -- Director: View Agenda

-- Insert departments (initially without managers)
INSERT INTO Departments (department_name, id_manager) VALUES
('IT Department', NULL),
('HR Department', NULL),
('Finance Department', NULL),
('Marketing Department', NULL);

-- Insert users with proper hierarchy
INSERT INTO Users (username, password, full_name, department_id, email) VALUES
('admin', '$2a$12$abcdefghijklmnopqrstuv$hashed_password', 'Admin User', 1, 'admin@example.com'),
('director1', '$2a$12$abcdefghijklmnopqrstuv$hashed_password', 'Mr Director', 1, 'director@example.com'),
('dept_manager1', '$2a$12$abcdefghijklmnopqrstuv$hashed_password', 'Mr Department Manager', 1, 'deptmanager@example.com'),
('manager1', '$2a$12$abcdefghijklmnopqrstuv$hashed_password', 'Mr Manager', 1, 'manager@example.com'),
('employee1', '$2a$12$abcdefghijklmnopqrstuv$hashed_password', 'Mr Employee', 1, 'employee@example.com');

-- Assign roles (admin assigns roles)
INSERT INTO User_Roles (user_id, role_id, assigned_by) VALUES
(2, 4, 1), -- director1 is Director
(3, 3, 1), -- dept_manager1 is Department Manager
(4, 2, 1), -- manager1 is Manager
(5, 1, 1); -- employee1 is Employee

-- Update department manager (Department Manager becomes manager of IT Department)
UPDATE Departments SET id_manager = 3 WHERE department_id = 1;

-- Update manager hierarchy based on new logic:
-- Employee -> Department Manager -> Director
-- Manager -> Department Manager -> Director
-- Department Manager -> Director
-- Director -> No manager

UPDATE Users SET manager_id = 3 WHERE user_id = 5; -- employee1 (Employee) reports to dept_manager1 (Department Manager)
UPDATE Users SET manager_id = 3 WHERE user_id = 4; -- manager1 (Manager) reports to dept_manager1 (Department Manager)
UPDATE Users SET manager_id = 2 WHERE user_id = 3; -- dept_manager1 (Department Manager) reports to director1 (Director)
UPDATE Users SET manager_id = NULL WHERE user_id = 2; -- director1 (Director) has no manager

-- Insert sample leave request
INSERT INTO Leave_Requests (user_id, start_date, end_date, reason, status)
VALUES (5, '2025-06-21', '2025-06-23', 'Vacation', 'Inprogress');

-- Insert sample agenda
INSERT INTO Agenda (user_id, date, status)
VALUES (5, '2025-06-20', 'Working');

-- Additional sample data for other departments
INSERT INTO Users (username, password, full_name, department_id, email) VALUES
('hr_employee', '$2a$12$abcdefghijklmnopqrstuv$hashed_password', 'HR Employee', 2, 'hr_employee@example.com'),
('hr_manager', '$2a$12$abcdefghijklmnopqrstuv$hashed_password', 'HR Manager', 2, 'hr_manager@example.com');

INSERT INTO User_Roles (user_id, role_id, assigned_by) VALUES
(6, 1, 1), -- hr_employee is Employee
(7, 2, 1); -- hr_manager is Manager

-- HR department has no Department Manager, so employees report to Director
UPDATE Users SET manager_id = 2 WHERE user_id = 6; -- hr_employee reports to director1
UPDATE Users SET manager_id = 2 WHERE user_id = 7; -- hr_manager reports to director1