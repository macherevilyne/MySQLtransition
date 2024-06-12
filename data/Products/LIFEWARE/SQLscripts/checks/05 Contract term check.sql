INSERT INTO `Error Table` (`Policy Nr`, Error, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    CASE
        WHEN Bestandsreport.`Contract Term (years)` IS NULL THEN 'Contract term empty'
        WHEN Bestandsreport.`Contract Term (years)` < Bestandsreport.`Contribution Term (years)` THEN 'Contract term < Contribution term'
        ELSE ''
    END AS Error,
    CASE
        WHEN Bestandsreport.`Contract Term (years)` IS NULL THEN ''
        WHEN Bestandsreport.`Contract Term (years)` < Bestandsreport.`Contribution Term (years)` THEN ''
        WHEN Bestandsreport.`Contract Term (years)` < 5 THEN 'Contract term <5'
        WHEN Bestandsreport.`Contract Term (years)` > 99 THEN 'Contract term >99'
        ELSE ''
    END AS Warning,
    Bestandsreport.`Contract Term (years)`
FROM Bestandsreport
WHERE
    Bestandsreport.`Contract Term (years)` IS NULL OR
    Bestandsreport.`Contract Term (years)` < 5 OR
    Bestandsreport.`Contract Term (years)` > 99 OR
    Bestandsreport.`Contract Term (years)` < Bestandsreport.`Contribution Term (years)`;