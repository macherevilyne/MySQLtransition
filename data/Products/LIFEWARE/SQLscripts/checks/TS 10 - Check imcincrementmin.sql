INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN TermsheetReport.`IMCIncrementmin` IS NULL THEN 'IMCmin empty'
        WHEN TermsheetReport.`IMCIncrementmin` < 0 THEN 'Negative IMCIncrementmin'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`IMCIncrementmin` = 0 THEN 'IMCIncrementmin = 0'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`IMCIncrementmin`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMCIncrementmin` < 0 OR TermsheetReport.`IMCIncrementmin` IS NULL);