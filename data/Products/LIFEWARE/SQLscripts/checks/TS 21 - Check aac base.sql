INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'Invalid AAC Base' AS Error,
    TermsheetReport.`AAC Base`
FROM TermsheetReport
WHERE
    (TermsheetReport.`AAC Base` NOT IN ('Investment', 'Premium', 'max(Premium,Investment)') OR ISNULL(TermsheetReport.`AAC Base`));