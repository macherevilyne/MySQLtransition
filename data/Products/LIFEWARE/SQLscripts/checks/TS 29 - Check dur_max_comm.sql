INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`DurMaxCommY`, 0), 'DurMaxCommY empty') AS Error,
    IF(`DurMaxCommY` < 0, 'Negative DurMaxCommY', IF(`DurMaxCommY` > 35, 'Large DurMaxCommY', NULL)) AS Warning,
    TermsheetReport.`DurMaxCommY`
FROM TermsheetReport
WHERE
    (`DurMaxCommY` < 0 OR `DurMaxCommY` > 35 OR ISNULL(`DurMaxCommY`));