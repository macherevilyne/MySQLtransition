CREATE TABLE IF NOT EXISTS `ErrorTable` (
   `PolicyNumber` TEXT,
   `Error` TEXT,
   `Warning` TEXT,
   `Value` TEXT,
   `Status` TEXT,
   );

INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT
    polno AS PolicyNumber,
    'Invalid status' AS Error,
    Status AS Value, Status
FROM PolicyData
WHERE Status NOT IN ('Issued', 'Terminated', 'Void', 'Inactive', 'Pending');