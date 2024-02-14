INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    IFNULL(`RateAmmort`, 'RateAmmort empty') AS Error,
    IF(
        `RateAmmort` IS NULL OR `RateAmmort` < 0 OR `RateAmmort` > 1,
        IFNULL('High RateAmmort', IFNULL('RateAmmort = 0', 'Invalid RateAmmort')),
        NULL
    ) AS Warning,
    `RateAmmort`
FROM TermsheetReport;