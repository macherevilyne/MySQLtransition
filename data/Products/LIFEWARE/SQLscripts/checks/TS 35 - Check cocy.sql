INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    IFNULL(`CoCY`, 'CoCY empty') AS Error,
    IF(
        `CoCY` IS NULL OR `CoCY` < 0 OR `CoCY` > 1,
        IFNULL('High CoCY', IFNULL('CoCY = 0', 'Invalid CoCY')),
        NULL
    ) AS Warning,
    `CoCY`
FROM TermsheetReport;