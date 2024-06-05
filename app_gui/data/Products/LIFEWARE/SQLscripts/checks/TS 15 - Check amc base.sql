INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'Invalid AMC Base' AS Error,
    TermsheetReport.`AMC Base`
FROM TermsheetReport
WHERE
    (TermsheetReport.`AMC Base` NOT IN ('Investment', 'Premium', 'max(Premium,Investment)')) OR (TermsheetReport.`AMC Base` IS NULL);