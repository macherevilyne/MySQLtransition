INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`UFC_SPmin_direct`, 0), 'UFC_SPmin_direct empty') AS Error,
    IF(`UFC_SPmin_direct` < 0, 'Negative UFC_SPmin_direct', IF(`UFC_SPmin_direct` > 0.08, 'High UFC_SPmin_direct', NULL)) AS Warning,
    TermsheetReport.`UFC_SPmin_direct`
FROM TermsheetReport
WHERE
    (`UFC_SPmin_direct` < 0 OR `UFC_SPmin_direct` > 0.08 OR ISNULL(`UFC_SPmin_direct`));