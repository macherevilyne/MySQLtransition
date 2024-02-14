INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`RC`, 0), 'RC empty') AS Error,
    IF(`RC` < 0, 'Negative RC', IF(`RC` > 1, 'Invalid RC', IF(`RC` > 0.01, 'High RC', NULL))) AS Warning,
    TermsheetReport.`RC`
FROM TermsheetReport
WHERE
    (`RC` < 0 OR `RC` > 0.01 OR ISNULL(`RC`));