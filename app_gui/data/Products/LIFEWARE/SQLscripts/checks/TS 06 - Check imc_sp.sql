INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN TermsheetReport.`IMC_SP` IS NULL THEN 'IMC_SP empty'
        WHEN TermsheetReport.`IMC_SP` < 0 THEN 'Negative IMC_SP'
        WHEN TermsheetReport.`IMC_SP` > 0.01 THEN 'Invalid IMC_SP'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`IMC_SP` > 0 THEN 'IMC_SP > 1%'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`IMC_SP`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMC_SP` < 0 OR TermsheetReport.`IMC_SP` > 0.01 OR TermsheetReport.`IMC_SP` IS NULL);