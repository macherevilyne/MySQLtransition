INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    CASE
        WHEN `Surrender charge initialRate` IS NULL THEN 'SC empty'
        WHEN `Surrender charge initialRate` < 0 THEN 'Negative SC'
        WHEN `Surrender charge initialRate` > 1 THEN 'Invalid SC'
    END AS Error,
    CASE
        WHEN `Surrender charge initialRate` = 0 THEN 'SC = 0'
        WHEN `Surrender charge initialRate` > 0.05 THEN 'High SC'
    END AS Warning,
    `Surrender charge initialRate` AS `Value`
FROM TermsheetReport
WHERE (`Surrender charge initialRate` IS NULL OR `Surrender charge initialRate` < 0 OR `Surrender charge initialRate` > 0.05);