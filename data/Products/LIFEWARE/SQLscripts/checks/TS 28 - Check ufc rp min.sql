INSERT INTO TersheetErrorTable (`Tariff Symbol`, Error, Warning, `Value`)
SELECT
    TermsheetReport.`Tariff Symbol`,
    IFNULL(NULLIF(`UFC_RPmin`, 0), 'UFC_RPmin empty') AS Error,
    IF(`UFC_RPmin` < 0, 'Negative UFC_RPmin', IF(`UFC_RPmin` > 0.08, 'High UFC_RPmin', NULL)) AS Warning,
    TermsheetReport.`UFC_RPmin`
FROM TermsheetReport
WHERE
    (`UFC_RPmin` < 0 OR `UFC_RPmin` > 0.08 OR ISNULL(`UFC_RPmin`));