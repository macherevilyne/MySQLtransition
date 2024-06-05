INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'AMC Slide empty' AS Error,
    TermsheetReport.`AMC Slide`
FROM TermsheetReport
WHERE
    (TermsheetReport.`AMC Slide` IS NULL AND TermsheetReport.`AMC%` IS NULL);