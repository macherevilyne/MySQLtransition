INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber, 'Invalid SC IMC Amortized' AS Error, SCIMCAmortized AS Value, Status
FROM PolicyData
WHERE (SCIMCAmortized IS NULL OR SCIMCAmortized < 0)
   OR (SCIMCAmortized > 0 AND Product <> 'FAS SEK');