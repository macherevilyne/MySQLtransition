INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IF(ISNULL(TermsheetReport.`IPC_SP`), 'IPC_SP empty', IF(TermsheetReport.`IPC_SP` < 0, 'Negative IPC_SP', NULL)) AS Error,
    IF(TermsheetReport.`IPC_SP` = 0, 'IPC_SP = 0', NULL) AS Warning,
    TermsheetReport.`IPC_SP`
FROM TermsheetReport
WHERE
    (TermsheetReport.`IPC_SP` < 0 OR ISNULL(TermsheetReport.`IPC_SP`));