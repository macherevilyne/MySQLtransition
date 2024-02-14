INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IF(ISNULL(TermsheetReport.`AACmin`), 'AACmin empty', IF(TermsheetReport.`AACmin` < 0, 'Negative AACmin', NULL)) AS Error,
    IF(TermsheetReport.`AACmin` = 0, 'AACmin = 0', NULL) AS Warning,
    TermsheetReport.`AACmin`
FROM TermsheetReport
WHERE
    (TermsheetReport.`AACmin` < 0 OR ISNULL(TermsheetReport.`AACmin`));