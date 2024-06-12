INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(IF(TermsheetReport.`AMCmin` < 0, 'Negative AMCmin', NULL), 'AMCmin empty') AS Error,
    IF(TermsheetReport.`AMCmin` = 0, 'AMCmin = 0', NULL) AS Warning,
    TermsheetReport.`AMCmin`
FROM TermsheetReport
WHERE
    TermsheetReport.`AMCmin` < 0 OR TermsheetReport.`AMCmin` IS NULL;