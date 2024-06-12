INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT
    polno AS PolicyNumber,
    'Invalid Term' AS Error,
    Term AS Value, Status
FROM PolicyData
WHERE (Term <> 1 AND Term <> 5) OR Term IS NULL;