INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    `Tariff Symbol`,
    'Invalid Amort Table' AS Error,
    `Amort Table` AS `Value`
FROM TermsheetReport
WHERE (`Amort Table` IS NULL OR `Amort Table` NOT IN (0, 1));