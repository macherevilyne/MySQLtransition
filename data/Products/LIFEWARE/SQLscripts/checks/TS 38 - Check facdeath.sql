INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    CASE
        WHEN `facdeath` IS NULL THEN 'facdeath empty'
        WHEN `facdeath` < 0 THEN 'Negative facdeath'
        WHEN `facdeath` > 1 THEN 'Invalid facdeath'
    END AS Error,
    CASE
        WHEN `facdeath` = 0 THEN 'facdeath = 0'
        WHEN `facdeath` > 0.5 THEN 'High facdeath'
    END AS Warning,
    `facdeath` AS `Value`
FROM TermsheetReport
WHERE (`facdeath` IS NULL OR `facdeath` < 0 OR `facdeath` > 0.5);