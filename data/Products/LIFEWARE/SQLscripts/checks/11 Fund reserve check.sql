INSERT INTO `Error Table` (`Policy Nr`, Error, Warning, `Data Value`)
SELECT
    Bestandsreport.`Policy Nr`,
    IF(Bestandsreport.`Fund Reserve` <= -1000, 'Fund reserve <=-1000', NULL) AS Error,
    IF(
        Bestandsreport.`Fund Reserve` <= 0, '',
        IF(
            Bestandsreport.`Fund Reserve` > 100000, 'Fund reserve >100000',
            IF(
                Bestandsreport.`Fund Reserve` < 0.9 * Bestandsreport.`Single Premium`,
                'Fund reserve <90% of single premium',
                ''
            )
        )
    ) AS Warning,
    Bestandsreport.`Fund Reserve` AS Expr1
FROM Bestandsreport
WHERE
    Bestandsreport.`Fund Reserve` <= 0 OR
    Bestandsreport.`Fund Reserve` > 100000 OR
    Bestandsreport.`Fund Reserve` < 0.9 * Bestandsreport.`Single Premium`;