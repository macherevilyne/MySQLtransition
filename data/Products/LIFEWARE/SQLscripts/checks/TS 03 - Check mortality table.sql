INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'Invalid mortality table' AS Error,
    TermsheetReport.`Mortality Table`
FROM TermsheetReport
WHERE
    (TermsheetReport.`Mortality Table` NOT IN ('DAV94', 'EK95', 'QuantumItaly', 'UNISEXDAV94', 'QuantumItalyUnisex', 'paulImportUKTable', 'paulImportUKSmokerTable') OR TermsheetReport.`Mortality Table` IS NULL);