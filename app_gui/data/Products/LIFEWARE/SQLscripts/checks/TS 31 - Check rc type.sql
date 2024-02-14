INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'Invalid RC Type' AS Error,
    TermsheetReport.`RC Type`
FROM TermsheetReport
WHERE
    (`RC Type` NOT IN ('STANDARD', 'REBATED', 'EBN Special', 'EER Special') OR ISNULL(`RC Type`));