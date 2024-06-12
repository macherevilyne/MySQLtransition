INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`UFC_RPmax`, 0), 'UFC_RPmax empty') AS Error,
    IF(`UFC_RPmax` < 0, 'Negative UFC_RPmax', IF(`UFC_RPmax` > 0.08, 'High UFC_RPmax', NULL)) AS Warning,
    TermsheetReport.`UFC_RPmax`
FROM TermsheetReport
WHERE
    (`UFC_RPmax` < 0 OR `UFC_RPmax` > 0.08 OR ISNULL(`UFC_RPmax`));