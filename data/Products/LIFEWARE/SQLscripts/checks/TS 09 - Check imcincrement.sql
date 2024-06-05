INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN TermsheetReport.`IMCIncrement` IS NULL THEN 'IMCincrement empty'
        WHEN TermsheetReport.`IMCIncrement` < 0 THEN 'Negative IMCincrement'
        WHEN TermsheetReport.`IMCIncrement` > 0.01 THEN 'Invalid IMCincrement'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`IMCIncrement` > 0 THEN 'IMCincrement > 1%'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`IMCIncrement`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMCIncrement` < 0 OR TermsheetReport.`IMCIncrement` > 0.01 OR TermsheetReport.`IMCIncrement` IS NULL);