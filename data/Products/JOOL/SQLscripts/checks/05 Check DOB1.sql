INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber, 'Invalid DOB VP1' AS Error, DobVP1 AS Value, Status
FROM PolicyData
WHERE ((DobVP1 IS NULL
        OR DobVP1 <= STR_TO_DATE('01-01-1900', '%d-%m-%Y')
        OR DobVP1 > [ValuationDate]) AND (Status = 'Issued'
        OR Status = 'Terminated'));