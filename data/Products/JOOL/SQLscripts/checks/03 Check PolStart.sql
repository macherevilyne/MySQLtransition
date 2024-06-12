INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber, 'Policy start empty or invalid' AS Error, PolStart AS Value, Status
FROM PolicyData
WHERE (PolStart IS NULL AND (Status = 'Issued' OR Status = 'Terminated'))
   OR (PolStart < STR_TO_DATE('01-01-2010', '%d-%m-%Y'));

