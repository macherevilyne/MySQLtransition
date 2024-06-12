INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'Invalid IMC Type' AS Error,
    TermsheetReport.`IMC Type`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMC Type` NOT IN ('MIXED', 'ONLY AMORTIZED') OR TermsheetReport.`IMC Type` IS NULL);