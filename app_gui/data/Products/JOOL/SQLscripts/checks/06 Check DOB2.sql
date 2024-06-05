INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber, 'Invalid DOB VP2' AS Error, DobVP2 AS Value, Status
FROM PolicyData
WHERE ((DobVP2 IS NULL OR DobVP2 <= STR_TO_DATE('01-01-1900', '%d-%m-%Y') OR DobVP2 > [ValuationDate])
        AND (Status = 'Issued' OR Status = 'Terminated')
        AND (Life_Assurance = 'Multiple Life, Last Survivor'));
