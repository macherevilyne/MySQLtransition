INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`UFC_SPmax_amortized`, 0), 'UFC_SPmax_amortized empty') AS Error,
    IF(`UFC_SPmax_amortized` = 0, 'UFC_SPmax_amortized = 0', IF(`UFC_SPmax_amortized` > 0.08, 'High UFC_SPmax_amortized', NULL)) AS Warning,
    TermsheetReport.`UFC_SPmax_amortized`
FROM TermsheetReport
WHERE
    (`UFC_SPmax_amortized` < 0 OR `UFC_SPmax_amortized` > 0.08 OR ISNULL(`UFC_SPmax_amortized`));