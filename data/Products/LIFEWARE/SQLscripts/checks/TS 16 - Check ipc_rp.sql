INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IF(ISNULL(TermsheetReport.`IPC_RP`), 'IPC_RP empty', IF(TermsheetReport.`IPC_RP` < 0, 'Negative IPC_RP', NULL)) AS Error,
    IF(TermsheetReport.`IPC_RP` = 0, 'IPC_RP = 0', NULL) AS Warning,
    TermsheetReport.`IPC_RP`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IPC_RP` < 0 OR ISNULL(TermsheetReport.`IPC_RP`));