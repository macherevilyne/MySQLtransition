INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    `Tariff Symbol`,
    CASE
        WHEN `DurSCY - SP` IS NULL THEN 'DurSCY SP empty'
        WHEN `DurSCY - SP` < 0 THEN 'Negative DurSCY SP'
        WHEN `DurSCY - SP` > 10 THEN 'Invalid DurSCY SP'
    END AS Error,
    CASE
        WHEN `DurSCY - SP` = 0 THEN 'DurSCY SP = 0'
        WHEN `DurSCY - SP` > 5 THEN 'High DurSCY SP'
    END AS Warning,
    `DurSCY - SP` AS `Value`
FROM TermsheetReport
WHERE (`DurSCY - SP` IS NULL OR `DurSCY - SP` < 0 OR `DurSCY - SP` > 5);