INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    IFNULL(`DurECY`, 'DurECY empty') AS Error,
    IF(
        `DurECY` IS NULL OR `DurECY` < 0 OR `DurECY` > 10,
        IFNULL('High DurECY', IFNULL('DurECY = 0', 'Invalid DurECY')),
        NULL
    ) AS Warning,
    `DurECY`
FROM TermsheetReport;