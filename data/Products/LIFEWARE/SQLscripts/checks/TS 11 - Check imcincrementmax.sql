INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN TermsheetReport.`IMCIncrementmax` IS NULL THEN 'IMCincrementmax empty'
        WHEN TermsheetReport.`IMCIncrementmax` < 0 THEN 'Negative IMCIncrementmax'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`IMCIncrementmax` = 0 THEN 'IMCIncrementmax = 0'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`IMCIncrementmax`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMCIncrementmax` <= 0 OR TermsheetReport.`IMCIncrementmax` IS NULL);