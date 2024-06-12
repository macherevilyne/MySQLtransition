INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN TermsheetReport.`IMCmax` IS NULL THEN 'IMCmax empty'
        WHEN TermsheetReport.`IMCmax` < 0 THEN 'Negative IMCmax'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`IMCmax` = 0 THEN 'IMCmax = 0'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`IMCmax`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMCmax` <= 0 OR TermsheetReport.`IMCmax` IS NULL);