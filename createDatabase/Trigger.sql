-- Update Agenda on leave request changes
CREATE TRIGGER tr_UpdateAgenda
ON Leave_Requests
AFTER INSERT, UPDATE
AS
BEGIN
    -- Remove outdated Agenda entries
    DELETE FROM Agenda
    WHERE user_id IN (SELECT user_id FROM inserted)
      AND date IN (
          SELECT date
          FROM inserted i
          CROSS APPLY (
              SELECT DATEADD(DAY, number, i.start_date) AS date
              FROM master..spt_values
              WHERE type = 'P' AND number <= DATEDIFF(day, i.start_date, i.end_date)
          ) d
      );

    -- Insert new Agenda entries for approved requests
    INSERT INTO Agenda (user_id, date, status)
    SELECT i.user_id, date, 'OnLeave'
    FROM inserted i
    CROSS APPLY (
        SELECT DATEADD(day, number, i.start_date) AS date
        FROM master..spt_values
        WHERE type = 'P' AND number <= DATEDIFF(day, i.start_date, i.end_date)
    ) d
    WHERE i.status = 'Approved';
END;
GO
