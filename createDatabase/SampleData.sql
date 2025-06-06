-- Insert departments
INSERT INTO Departments (department_name, id_manager) VALUES ('IT', NULL), ('HR', NULL);

-- Insert roles
INSERT INTO Roles (role_name) VALUES 
('Employee'), 
('Team Leader'), 
('Department Manager'), 
('Vice Director'), 
('Director');

-- Insert features
INSERT INTO Features (feature_name) VALUES 
('Create Leave Request'), 
('Process Leave Request'), 
('View Department Agenda'), 
('View Company Agenda'),
('Manage Permissions');

-- Insert role-feature mappings
INSERT INTO Role_Features (role_id, feature_id) VALUES 
(1, 1), -- Employee: Create request
(2, 1), (2, 2), (2, 3), -- Team Leader: Create, process, view dept agenda
(3, 1), (3, 2), (3, 3), -- Dept Manager: Create, process, view dept agenda
(4, 1), (4, 2), (4, 3), -- Vice Director: Create, process, view dept agenda
(5, 1), (5, 2), (5, 3), (5, 4), (5, 5); -- Director: All permissions

-- Insert users
INSERT INTO Users (username, password, full_name, department_id, manager_id, role_id, email)
VALUES 
('teo', 'hashed_password', 'Mr Teo', 1, 4, 1, 'teo@example.com'), -- Employee
('nam', 'hashed_password', 'Mr Nam', 1, 2, 2, 'nam@example.com'), -- Team Leader
('tit', 'hashed_password', 'Mr Tit', 1, 5, 3, 'tit@example.com'), -- Dept Manager
('vice', 'hashed_password', 'Vice Director', 1, 5, 4, 'vice@example.com'), -- Vice Director
('chairman', 'hashed_password', 'Chairman', 1, NULL, 5, 'chairman@example.com'), -- Director
('lan', 'hashed_password', 'Ms Lan', 1, 4, 1, 'lan@example.com'); -- Employee (temp leader)

-- Update department managers
UPDATE Departments SET id_manager = 2 WHERE department_id = 1; -- Mr Tit manages IT
UPDATE Departments SET id_manager = 5 WHERE department_id = 2; -- Chairman temporarily manages HR

-- Insert access scopes
INSERT INTO Access_Scope (accessor_id, target_user_id, target_department_id, permission_type, expiry_date)
VALUES 
(2, NULL, 1, 'View', NULL), -- Dept Manager views IT
(2, NULL, 1, 'Process', NULL), -- Dept Manager processes IT
(4, 1, NULL, 'View', NULL), -- Team Leader views Mr Teo
(4, 1, NULL, 'Process', NULL), -- Team Leader processes Mr Teo
(5, NULL, 1, 'View', NULL), -- Vice Director views IT
(5, NULL, 2, 'View', NULL), -- Vice Director views HR
(6, 1, NULL, 'View', '2025-06-30'), -- Ms Lan (temp leader) views Mr Teo
(6, 1, NULL, 'Process', '2025-06-30'); -- Ms Lan processes Mr Teo

-- Insert leave request
INSERT INTO Leave_Requests (user_id, start_date, end_date, reason, status)
VALUES (1, '2025-01-01', '2025-01-03', 'Wedding', 'Inprogress');

-- Insert agenda
INSERT INTO Agenda (user_id, date, status)
VALUES (1, '2025-01-04', 'Working');
