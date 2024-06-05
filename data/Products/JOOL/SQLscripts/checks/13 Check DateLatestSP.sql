INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber,
       'Invalid Date Latest SP' AS Error,
       DateLatestSP AS Value,
       Status
FROM PolicyData
WHERE (DateLatestSP IS NULL AND Status = 'Issued' AND PolStart <= [ValuationDate]);