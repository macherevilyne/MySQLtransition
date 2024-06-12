INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    CASE
        WHEN `Surrender fee` IS NULL THEN 'Surrender fee empty'
        WHEN `Surrender fee` < 0 THEN 'Negative Surrender fee'
        WHEN `Surrender fee` > 1000 THEN 'Large Surrender fee'
    END AS Error,
    CASE
        WHEN `Surrender fee` = 0 THEN 'Surrender fee = 0'
    END AS Warning,
    `Surrender fee` AS `Value`
FROM TermsheetReport
WHERE (`Surrender fee` IS NULL OR `Surrender fee` < 0 OR `Surrender fee` > 1000);