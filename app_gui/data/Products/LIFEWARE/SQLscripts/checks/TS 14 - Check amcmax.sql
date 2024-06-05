INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(IF(TermsheetReport.`AMCmax` < 0, 'Negative AMCmax', NULL), 'AMCmax empty') AS Error,
    IF(TermsheetReport.`AMCmax` = 0, 'AMCmax = 0', NULL) AS Warning,
    TermsheetReport.`AMCmax`
FROM TermsheetReport
WHERE
    TermsheetReport.`AMCmax` <= 0 OR TermsheetReport.`AMCmax` IS NULL;