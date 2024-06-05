INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    'Tariff code double counted' AS Error,
    COUNT(TermsheetReport.`Tariff Symbol`) AS `CountOfTariff Symbol`
FROM TermsheetReport
GROUP BY TermsheetReport.`Tariff Symbol`
HAVING COUNT(TermsheetReport.`Tariff Symbol`) > 1;