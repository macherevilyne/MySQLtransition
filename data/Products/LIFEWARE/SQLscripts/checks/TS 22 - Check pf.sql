INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`PF`, 0), 'PF empty') AS Error,
    IF(`PF` > 0, 'PF > 1000', NULL) AS Warning,
    TermsheetReport.`PF`
FROM TermsheetReport
WHERE
    (`PF` < 0 OR `PF` > 1000 OR ISNULL(`PF`));