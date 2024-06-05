INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    IFNULL(`DurPCY`, 'DurPCY empty') AS Error,
    IF(
        `DurPCY` IS NULL OR `DurPCY` < 0 OR `DurPCY` > 10,
        IFNULL('High DurPCY', IFNULL('DurPCY = 0', 'Invalid DurPCY')),
        NULL
    ) AS Warning,
    `DurPCY`
FROM TermsheetReport;