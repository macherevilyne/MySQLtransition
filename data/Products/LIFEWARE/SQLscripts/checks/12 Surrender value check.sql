INSERT INTO `Error Table` (`Policy Nr`, Error, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    IF(Bestandsreport.`Surrender Value` > Bestandsreport.`Fund Reserve`, 'Surrender value > Fund reserve', NULL) AS Error,
    IF(
        Bestandsreport.`Surrender Value` > Bestandsreport.`Fund Reserve`,
        '',
        IF(
            Bestandsreport.`Surrender Value` < 0.9 * Bestandsreport.`Single Premium`,
            'Surrender value < 90% of single premium',
            ''
        )
    ) AS Warning,
    Bestandsreport.`Surrender Value` AS Expr1
FROM Bestandsreport
WHERE
    Bestandsreport.`Surrender Value` > Bestandsreport.`Fund Reserve` OR
    Bestandsreport.`Surrender Value` < 0.9 * Bestandsreport.`Single Premium`;