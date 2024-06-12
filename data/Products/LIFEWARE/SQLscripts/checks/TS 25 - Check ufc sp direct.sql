INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`UFC_SPmax_direct`, 0), 'UFC_SPmax_direct empty') AS Error,
    IF(`UFC_SPmax_direct` < 0, 'Negative UFC_SPmax_direct', IF(`UFC_SPmax_direct` > 0.08, 'High UFC_SPmax_direct', NULL)) AS Warning,
    TermsheetReport.`UFC_SPmax_direct`
FROM TermsheetReport
WHERE
    (`UFC_SPmax_direct` < 0 OR `UFC_SPmax_direct` > 0.08 OR ISNULL(`UFC_SPmax_direct`));