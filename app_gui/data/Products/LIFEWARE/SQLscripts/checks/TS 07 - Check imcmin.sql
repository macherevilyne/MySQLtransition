INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN TermsheetReport.`IMCmin` IS NULL THEN 'IMCmin empty'
        WHEN TermsheetReport.`IMCmin` < 0 THEN 'Negative IMCmin'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`IMCmin` = 0 THEN 'IMCmin = 0'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`IMCmin`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMCmin` < 0 OR TermsheetReport.`IMCmin` IS NULL);