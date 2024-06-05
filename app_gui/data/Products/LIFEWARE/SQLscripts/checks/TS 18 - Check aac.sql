INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IF(ISNULL(TermsheetReport.`AAC`), 'AAC empty', IF(TermsheetReport.`AAC` < 0, 'Negative AAC', IF(TermsheetReport.`AAC` > 1, 'Invalid AAC', NULL))) AS Error,
    IF(TermsheetReport.`AAC` > 0, 'AAC > 1%', NULL) AS Warning,
    TermsheetReport.`AAC`
FROM TermsheetReport
WHERE
    (TermsheetReport.`AAC` < 0 OR TermsheetReport.`AAC` > 0.01 OR ISNULL(TermsheetReport.`AAC`));