INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(`RPC`, 'RC empty') AS Error,
    IF(
        `RPC` IS NULL OR `RPC` < 0 OR `RPC` > 0.05,
        IFNULL('High RPC', IFNULL('RPC = 0', 'Invalid RPC')),
        NULL
    ) AS Warning,
    TermsheetReport.`RPC`
FROM TermsheetReport;