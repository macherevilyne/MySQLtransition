INSERT INTO ErrorTable (PolicyNumber, Error, Value, Status)
SELECT polno AS PolicyNumber, 'Invalid SVValDat' AS Error, SVValDat AS Value, Status
FROM PolicyData
WHERE (SVValDat IS NULL OR SVValDat > (PolicyValue - SCIMCAmortized));