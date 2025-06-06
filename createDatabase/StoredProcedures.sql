-- Authenticate user
CREATE PROCEDURE sp_AuthenticateUser
    @username NVARCHAR(50)
AS
BEGIN
    SELECT user_id, username, password, full_name, department_id, manager_id, role_id
    FROM Users
    WHERE username = @username;
END;
GO

-- Create leave request
CREATE PROCEDURE sp_CreateLeaveRequest
    @user_id INT,
    @start_date DATE,
    @end_date DATE,
    @reason NVARCHAR(500)
AS
BEGIN
    INSERT INTO Leave_Requests (user_id, start_date, end_date, reason, status)
    VALUES (@user_id, @start_date, @end_date, @reason, 'Inprogress');
END;
GO

-- Get leave requests
CREATE PROCEDURE sp_GetLeaveRequests
    @user_id INT
AS
BEGIN
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM Users WHERE user_id = @user_id;

    IF EXISTS (SELECT 1 FROM Roles WHERE role_id = @role_id AND role_name = 'Director')
    BEGIN
        -- Director views all requests
        SELECT lr.request_id, lr.user_id, lr.start_date, lr.end_date, lr.reason, lr.status, lr.processed_by, lr.processed_reason, lr.created_at
        FROM Leave_Requests lr;
    END
    ELSE
    BEGIN
        -- View own requests, direct reports, or via Access_Scope
        SELECT lr.request_id, lr.user_id, lr.start_date, lr.end_date, lr.reason, lr.status, lr.processed_by, lr.processed_reason, lr.created_at
        FROM Leave_Requests lr
        WHERE lr.user_id = @user_id
           OR lr.user_id IN (
               SELECT user_id FROM Users WHERE manager_id = @user_id
           )
           OR lr.user_id IN (
               SELECT target_user_id
               FROM Access_Scope
               WHERE accessor_id = @user_id 
                 AND permission_type = 'View'
                 AND (expiry_date IS NULL OR expiry_date >= CAST(GETDATE() AS DATE))
           )
           OR lr.user_id IN (
               SELECT u.user_id
               FROM Users u
               JOIN Access_Scope a ON u.department_id = a.target_department_id
               WHERE a.accessor_id = @user_id 
                 AND a.permission_type = 'View'
                 AND (a.expiry_date IS NULL OR a.expiry_date >= CAST(GETDATE() AS DATE))
           );
    END
END;
GO

-- Process leave request
CREATE PROCEDURE sp_ProcessLeaveRequest
    @request_id INT,
    @processed_by INT,
    @status NVARCHAR(20),
    @processed_reason NVARCHAR(500)
AS
BEGIN
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM Users WHERE user_id = @processed_by;

    IF EXISTS (SELECT 1 FROM Roles WHERE role_id = @role_id AND role_name = 'Director')
        OR EXISTS (
            SELECT 1 
            FROM Leave_Requests lr 
            WHERE lr.request_id = @request_id 
              AND (
                  lr.user_id IN (
                      SELECT user_id FROM Users WHERE manager_id = @processed_by
                  )
                  OR lr.user_id IN (
                      SELECT target_user_id
                      FROM Access_Scope
                      WHERE accessor_id = @processed_by 
                        AND permission_type = 'Process'
                        AND (expiry_date IS NULL OR expiry_date >= CAST(GETDATE() AS DATE))
                  )
                  OR lr.user_id IN (
                      SELECT u.user_id
                      FROM Users u
                      JOIN Access_Scope a ON u.department_id = a.target_department_id
                      WHERE a.accessor_id = @processed_by 
                        AND a.permission_type = 'Process'
                        AND (a.expiry_date IS NULL OR a.expiry_date >= CAST(GETDATE() AS DATE))
                  )
              )
        )
    BEGIN
        UPDATE Leave_Requests
        SET status = @status,
            processed_by = @processed_by,
            processed_reason = @processed_reason,
            updated_at = GETDATE()
        WHERE request_id = @request_id;
    END
    ELSE
    BEGIN
        THROW 50001, 'User does not have permission to process this request.', 1;
    END
END;
GO

-- Get agenda (fixed expiry_date reference)
CREATE PROCEDURE sp_GetAgenda
    @user_id INT,
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    DECLARE @role_id INT;
    SELECT @role_id = role_id FROM Users WHERE user_id = @user_id;

    IF EXISTS (SELECT 1 FROM Roles WHERE role_id = @role_id AND role_name = 'Director')
    BEGIN
        -- Director views company-wide agenda
        SELECT u.user_id, u.full_name, a.date, a.status, d.department_name
        FROM Agenda a
        JOIN Users u ON a.user_id = u.user_id
        JOIN Departments d ON u.department_id = d.department_id
        WHERE a.date BETWEEN @start_date AND @end_date
        ORDER BY d.department_name, u.full_name, a.date;
    END
    ELSE
    BEGIN
        -- View agenda for direct reports or via Access_Scope
        SELECT u.user_id, u.full_name, a.date, a.status
        FROM Agenda a
        JOIN Users u ON a.user_id = u.user_id
        WHERE a.date BETWEEN @start_date AND @end_date
          AND (
              u.user_id IN (
                  SELECT user_id FROM Users WHERE manager_id = @user_id
              )
              OR u.user_id IN (
                  SELECT target_user_id
                  FROM Access_Scope
                  WHERE accessor_id = @user_id 
                    AND permission_type = 'View'
                    AND (expiry_date IS NULL OR expiry_date >= CAST(GETDATE() AS DATE))
              )
              OR u.department_id IN (
                  SELECT target_department_id
                  FROM Access_Scope
                  WHERE accessor_id = @user_id 
                    AND permission_type = 'View'
                    AND (expiry_date IS NULL OR expiry_date >= CAST(GETDATE() AS DATE))
              )
              OR u.department_id IN (
                  SELECT department_id FROM Departments WHERE id_manager = @user_id
              )
          )
        ORDER BY u.full_name, a.date;
    END
END;
GO

-- Check feature access
CREATE PROCEDURE sp_CheckFeatureAccess
    @user_id INT,
    @feature_name NVARCHAR(100)
AS
BEGIN
    SELECT COUNT(*) AS has_access
    FROM Users u
    JOIN Role_Features rf ON u.role_id = rf.role_id
    JOIN Features f ON rf.feature_id = f.feature_id
    WHERE u.user_id = @user_id AND f.feature_name = @feature_name;
END;
GO

-- Update department manager
CREATE PROCEDURE sp_UpdateDepartmentManager
    @department_id INT,
    @id_manager INT
AS
BEGIN
    UPDATE Departments
    SET id_manager = @id_manager
    WHERE department_id = @department_id;
END;
GO

-- Add access scope
CREATE PROCEDURE sp_AddAccessScope
    @accessor_id INT,
    @target_user_id INT = NULL,
    @target_department_id INT = NULL,
    @permission_type NVARCHAR(20),
    @expiry_date DATE = NULL
AS
BEGIN
    INSERT INTO Access_Scope (accessor_id, target_user_id, target_department_id, permission_type, expiry_date)
    VALUES (@accessor_id, @target_user_id, @target_department_id, @permission_type, @expiry_date);
END;
GO

-- Clean expired access scopes
CREATE PROCEDURE sp_CleanExpiredAccessScopes
AS
BEGIN
    DELETE FROM Access_Scope
    WHERE expiry_date IS NOT NULL 
      AND expiry_date < CAST(GETDATE() AS DATE);
END;
GO
