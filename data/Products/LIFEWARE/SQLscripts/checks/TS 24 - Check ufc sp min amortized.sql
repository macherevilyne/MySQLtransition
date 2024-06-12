INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`UFC_SPmin_amortized`, 0), 'UFC_SPmin_amortized empty') AS Error,
    IF(`UFC_SPmin_amortized` < 0, 'Negative UFC_SPmin_amortized', IF(`UFC_SPmin_amortized` > 0.08, 'High UFC_SPmin_amortized', NULL)) AS Warning,
    TermsheetReport.`UFC_SPmin_amortized`
FROM TermsheetReport
WHERE
    (`UFC_SPmin_amortized` < 0 OR `UFC_SPmin_amortized` > 0.08 OR ISNULL(`UFC_SPmin_amortized`));