INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber,
       'No corresponding Cost Parameter set' AS Error,
       NULL AS Value,
       Status
FROM PolicyData
LEFT JOIN CostParameters ON PolicyData.polno = CostParameters.polno
WHERE CostParameters.polno IS NULL;