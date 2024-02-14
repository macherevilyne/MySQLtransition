INSERT INTO `Error Table` (`Policy Nr`, Error, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    CASE
        WHEN Bestandsreport.`Contribution Term (years)` IS NULL THEN 'Contribution term empty'
        WHEN Bestandsreport.`Contribution Term (years)` < 5 THEN 'Contribution term <5'
        WHEN Bestandsreport.`Contribution Term (years)` > 40 THEN 'Contribution term >40'
        ELSE ''
    END AS Error,
    CASE
        WHEN Bestandsreport.`Contribution Term (years)` IS NULL THEN ''
        WHEN Bestandsreport.`Contribution Term (years)` < 5 THEN 'Contribution term <5'
        WHEN Bestandsreport.`Contribution Term (years)` > 40 THEN 'Contribution term >40'
        ELSE ''
    END AS Warning,
    Bestandsreport.`Contribution Term (years)`
FROM Bestandsreport
WHERE
    (
        IF(
            Bestandsreport.`Contribution Term (years)` IS NULL,
            IF(Bestandsreport.`Regular Premium` IS NULL, 'ok', 'error'),
            ''
        ) = 'error'
    )
    OR Bestandsreport.`Contribution Term (years)` < 5
    OR Bestandsreport.`Contribution Term (years)` > 40;