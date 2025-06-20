-- Insert roles (4 fixed roles)
INSERT INTO Roles (role_name) VALUES 
('Employee'), ('Manager'), ('Department Manager'), ('Director');

-- Insert features with entrypoint
INSERT INTO Features (feature_name, entrypoint) VALUES 
('Create Leave Request', '/leaveRequests/create'),
('Process Leave Request', '/leaveRequests/process'),
('View Department Agenda', '/agenda/department'),
('View Company Agenda', '/agenda/company'),
('Manage Permissions', '/admin/permissions'),
('View All Requests', '/leaveRequests/all');

-- Insert role-feature mappings
INSERT INTO Role_Features (role_id, feature_id) VALUES
(1, 1), -- Employee: Create Leave Request
(2, 1), (2, 2), (2, 3), -- Manager: Create, Process, View Dept Agenda
(3, 1), (3, 2), (3, 3), -- Dept Manager: Create, Process, View Dept Agenda
(4, 1), (4, 2), (4, 3), (4, 4), (4, 5), (4, 6); -- Director: All permissions

-- Insert specific departments
INSERT INTO Departments (department_name, id_manager) VALUES 
('IT Department', NULL),
('HR Department', NULL),
('Finance Department', NULL),
('Marketing Department', NULL);

-- Insert users with admin account and hierarchy
INSERT INTO Users (username, password, full_name, department_id, email) VALUES 
('admin', 'hashed_password', 'Admin User', 1, 'admin@example.com'), -- Admin account
('teo', 'hashed_password', 'Mr Teo', 1, 'teo@example.com'),        -- Employee in IT
('nam', 'hashed_password', 'Mr Nam', 1, 'nam@example.com'),        -- Manager in IT
('tit', 'hashed_password', 'Mr Tit', 1, 'tit@example.com');        -- Dept Manager in IT

-- Assign roles (admin assigns roles, excluding admin itself)
INSERT INTO User_Roles (user_id, role_id, assigned_by) VALUES 
(2, 1, 1), -- Teo is Employee
(3, 2, 1), -- Nam is Manager
(4, 3, 1); -- Tit is Dept Manager
-- Admin (user_id = 1) không thuộc User_Roles, sẽ được kiểm tra qua username

-- Update manager hierarchy
UPDATE Users SET manager_id = 3 WHERE user_id = 2; -- Teo (Employee) reports to Nam (Manager)
UPDATE Users SET manager_id = 4 WHERE user_id = 3; -- Nam (Manager) reports to Tit (Dept Manager)
UPDATE Users SET manager_id = 1 WHERE user_id = 4; -- Tit (Dept Manager) reports to Admin

-- Update department manager
UPDATE Departments SET id_manager = 4 WHERE department_id = 1; -- Tit is Dept Manager for IT Department

-- Insert sample leave request
INSERT INTO Leave_Requests (user_id, start_date, end_date, reason, status) 
VALUES (2, '2025-06-21', '2025-06-23', 'Vacation', 'Inprogress');

-- Insert sample agenda
INSERT INTO Agenda (user_id, date, status) 
VALUES (2, '2025-06-20', 'Working');