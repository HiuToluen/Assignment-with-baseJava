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
    updated_at DATETIME DEFAULT GETDATE(),
    title NVARCHAR(255) NOT NULL DEFAULT ''
);