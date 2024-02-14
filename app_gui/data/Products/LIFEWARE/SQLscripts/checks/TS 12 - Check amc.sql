INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    CASE
        WHEN (TermsheetReport.`AMC` IS NULL AND TermsheetReport.`AMC Slide` IS NULL) THEN 'AMC empty'
        WHEN TermsheetReport.`AMC` < 0 THEN 'Negative AMC'
        WHEN TermsheetReport.`AMC` > 0.01 THEN 'Invalid AMC'
        ELSE NULL
    END AS Error,
    CASE
        WHEN TermsheetReport.`AMC` > 0 THEN 'AMC > 1%'
        ELSE NULL
    END AS Warning,
    TermsheetReport.`AMC`
FROM TermsheetReport
WHERE
    (TermsheetReport.`AMC` < 0 OR TermsheetReport.`AMC` > 0.01) OR
    (TermsheetReport.`AMC` IS NULL AND TermsheetReport.`AMC Slide` IS NULL);