INSERT INTO `Error Table` (`Policy Nr`, Error, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    IF(
        Bestandsreport.`Clawback` > 0.07 * PremiumSum(
            IFNULL(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0),
            IFNULL(CAST(REPLACE(Bestandsreport.`singlePremiumSum`, ',', '.') AS DECIMAL(10, 2)), 0),
            Bestandsreport.`Pay Frequency (per year)`,
            IFNULL(Bestandsreport.`Contribution Term (years)`, 0)
        ),
        'Clawback > 7% of premium sum',
        IF(Bestandsreport.`Clawback` < 0, 'Clawback negative', NULL)
    ) AS Error,
    Bestandsreport.`Clawback` AS Expr1
FROM Bestandsreport
WHERE
    Bestandsreport.`Clawback` > 0.07 * PremiumSum(
        IFNULL(CAST(REPLACE(Bestandsreport.`Regular Premium`, ',', '.') AS DECIMAL(10, 2)), 0),
        IFNULL(CAST(REPLACE(Bestandsreport.`singlePremiumSum`, ',', '.') AS DECIMAL(10, 2)), 0),
        Bestandsreport.`Pay Frequency (per year)`,
        IFNULL(Bestandsreport.`Contribution Term (years)`, 0)
    )
    OR Bestandsreport.`Clawback` < 0;