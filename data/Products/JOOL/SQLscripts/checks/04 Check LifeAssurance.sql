INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT
    polno AS PolicyNumber,
    'Invalid Life Assurance' AS Error,
    Life_Assurance AS Value, Status
FROM PolicyData
WHERE (
        (Life_Assurance NOT IN ('Own Life', 'Life of Another', 'Multiple Life, Last Survivor')
        AND (Status = 'Issued' OR Status = 'Terminated')
        )
         OR (Life_Assurance IS NULL AND (Status = 'Issued' OR Status = 'Terminated'))
    );