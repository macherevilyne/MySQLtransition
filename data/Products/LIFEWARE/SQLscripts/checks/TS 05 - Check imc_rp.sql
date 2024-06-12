INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN TermsheetReport.`IMC_RP` IS NULL THEN 'IMC_RP empty'
        WHEN TermsheetReport.`IMC_RP` < 0 THEN 'Negative IMC_RP'
        WHEN TermsheetReport.`IMC_RP` > 0.01 THEN 'Invalid IMC_RP'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`IMC_RP` > 0 THEN 'IMC_RP > 1%'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`IMC_RP`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IMC_RP` < 0 OR TermsheetReport.`IMC_RP` > 0.01 OR TermsheetReport.`IMC_RP` IS NULL);