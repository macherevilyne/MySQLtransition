INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'Invalid currency' AS Error,
    TermsheetReport.`Tariff Currency`
FROM TermsheetReport
WHERE
    (TermsheetReport.`Tariff Currency` NOT IN ('EUR', 'USD', 'GBP', 'CHF', 'CZK', 'PLN') OR TermsheetReport.`Tariff Currency` IS NULL);