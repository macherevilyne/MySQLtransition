INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT
    polno AS PolicyNumber,
    'Invalid policy currency' AS Error,
    PolicyCurrency AS Value, Status
FROM PolicyData
WHERE PolicyCurrency NOT IN ('SEK', 'NOK');