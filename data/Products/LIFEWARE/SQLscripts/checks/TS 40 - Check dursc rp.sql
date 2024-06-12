INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    CASE
        WHEN `DurSCY - RP` IS NULL THEN 'DurSCY RP empty'
        WHEN `DurSCY - RP` < 0 THEN 'Negative DurSCY RP'
        WHEN `DurSCY - RP` > 10 THEN 'Invalid DurSCY RP'
    END AS Error,
    CASE
        WHEN `DurSCY - RP` = 0 THEN 'DurSCY RP = 0'
        WHEN `DurSCY - RP` > 5 THEN 'High DurSCY RP'
    END AS Warning,
    `DurSCY - RP` AS `Value`
FROM TermsheetReport
WHERE (`DurSCY - RP` IS NULL OR `DurSCY - RP` < 0 OR `DurSCY - RP` > 5);