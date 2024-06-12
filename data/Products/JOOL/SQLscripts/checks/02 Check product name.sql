INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT
    polno AS PolicyNumber,
    'Invalid product name' AS Error,
    Product AS Value, Status
FROM PolicyData
WHERE Product NOT IN ('FAS SEK', 'FBS SEK', 'FBN NOK');