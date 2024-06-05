INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IF(ISNULL(TermsheetReport.`AACmax`), 'AACmax empty', IF(TermsheetReport.`AACmax` < 0, 'Negative AACmax', NULL)) AS Error,
    IF(TermsheetReport.`AACmax` = 0, 'AACmax = 0', NULL) AS Warning,
    TermsheetReport.`AACmax`
FROM TermsheetReport
WHERE
    (TermsheetReport.`AACmax` < 0 OR ISNULL(TermsheetReport.`AACmax`));